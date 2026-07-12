import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sentry/sentry.dart';

/// Captures uncaught errors for diagnostics.
///
/// Default implementation writes rolling local logs (no network).
/// When `--dart-define=SENTRY_DSN=...` is set, also forwards to Sentry.
abstract class CrashReportingService {
  Future<void> init();

  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? context,
  });

  Future<void> recordFlutterError(FlutterErrorDetails details);

  /// Most recent log entries (newest last), for support / about screen.
  Future<List<String>> recentEntries({int limit = 50});

  /// Share-friendly dump of recent logs.
  Future<String> exportLogsAsText({int limit = 100});

  /// True when a remote sink (Sentry) is active.
  bool get remoteEnabled;
}

/// Builds local-only or local+Sentry reporting based on compile-time DSN.
///
/// Enable remote reporting with:
/// `flutter run --dart-define=SENTRY_DSN=https://...@....ingest.sentry.io/...`
CrashReportingService createCrashReportingService() {
  // Compile-time injection is intentional for release builds without secrets in source.
  // ignore: do_not_use_environment
  const dsn = String.fromEnvironment('SENTRY_DSN');
  final local = LocalCrashReportingService();
  if (dsn.isEmpty) {
    return local;
  }
  return CompositeCrashReportingService(
    local: local,
    remote: SentryCrashReportingService(dsn: dsn),
  );
}

/// Fan-out: always persist locally; optionally send to Sentry.
class CompositeCrashReportingService implements CrashReportingService {
  CompositeCrashReportingService({
    required this.local,
    required this.remote,
  });

  final CrashReportingService local;
  final CrashReportingService remote;

  @override
  bool get remoteEnabled => remote.remoteEnabled;

  @override
  Future<void> init() async {
    await local.init();
    await remote.init();
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? context,
  }) async {
    await local.recordError(error, stack, fatal: fatal, context: context);
    await remote.recordError(error, stack, fatal: fatal, context: context);
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    await local.recordFlutterError(details);
    await remote.recordFlutterError(details);
  }

  @override
  Future<List<String>> recentEntries({int limit = 50}) =>
      local.recentEntries(limit: limit);

  @override
  Future<String> exportLogsAsText({int limit = 100}) async {
    final body = await local.exportLogsAsText(limit: limit);
    if (!remoteEnabled) return body;
    return '$body\n\n---\nRemote: Sentry enabled for this build.';
  }
}

class LocalCrashReportingService implements CrashReportingService {
  static const _fileName = 'crash_reports.log';
  static const _maxBytes = 256 * 1024; // 256 KB rolling cap

  File? _file;
  bool _ready = false;
  final _writeLock = _AsyncLock();

  @override
  bool get remoteEnabled => false;

  @override
  Future<void> init() async {
    if (_ready) return;
    try {
      final dir = await getApplicationSupportDirectory();
      _file = File(p.join(dir.path, _fileName));
      if (!_file!.existsSync()) {
        await _file!.create(recursive: true);
      }
      _ready = true;
    } on Object catch (e, st) {
      if (kDebugMode) {
        debugPrint('CrashReporting init failed: $e\n$st');
      }
    }
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    await recordError(
      details.exception,
      details.stack,
      fatal: true,
      context: details.context?.toString(),
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? context,
  }) async {
    if (kDebugMode) {
      debugPrint(
        'CrashReport${fatal ? ' [FATAL]' : ''}: $error'
        '${context != null ? '\ncontext: $context' : ''}'
        '${stack != null ? '\n$stack' : ''}',
      );
    }

    if (!_ready || _file == null) return;

    final entry = {
      'ts': DateTime.now().toUtc().toIso8601String(),
      'fatal': fatal,
      'error': error.toString(),
      'context': ?context,
      'stack': ?stack?.toString(),
    };

    await _writeLock.run(() async {
      try {
        await _file!.writeAsString(
          '${jsonEncode(entry)}\n',
          mode: FileMode.append,
          flush: true,
        );
        await _trimIfNeeded();
      } on Object catch (e) {
        if (kDebugMode) {
          debugPrint('CrashReport write failed: $e');
        }
      }
    });
  }

  Future<void> _trimIfNeeded() async {
    final file = _file;
    if (file == null || !file.existsSync()) return;
    final length = file.lengthSync();
    if (length <= _maxBytes) return;

    final lines = await file.readAsLines();
    final keep = lines.skip(lines.length ~/ 2).toList();
    await file.writeAsString('${keep.join('\n')}\n', flush: true);
  }

  @override
  Future<List<String>> recentEntries({int limit = 50}) async {
    if (!_ready || _file == null || !_file!.existsSync()) {
      return const [];
    }
    try {
      final lines = await _file!.readAsLines();
      if (lines.length <= limit) return lines;
      return lines.sublist(lines.length - limit);
    } on Object {
      return const [];
    }
  }

  @override
  Future<String> exportLogsAsText({int limit = 100}) async {
    final entries = await recentEntries(limit: limit);
    if (entries.isEmpty) {
      return 'No crash logs recorded.';
    }
    return entries.join('\n');
  }
}

/// Optional remote sink — active only when [dsn] is non-empty.
class SentryCrashReportingService implements CrashReportingService {
  SentryCrashReportingService({required this.dsn});

  final String dsn;
  bool _enabled = false;

  @override
  bool get remoteEnabled => _enabled;

  @override
  Future<void> init() async {
    if (dsn.isEmpty) return;
    try {
      await Sentry.init((options) {
        options.dsn = dsn;
        options.environment = kReleaseMode ? 'production' : 'debug';
        options.tracesSampleRate = 0;
        options.sendDefaultPii = false;
      });
      _enabled = true;
      if (kDebugMode) {
        debugPrint('Sentry crash reporting enabled');
      }
    } on Object catch (e, st) {
      if (kDebugMode) {
        debugPrint('Sentry init failed: $e\n$st');
      }
      _enabled = false;
    }
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (!_enabled) return;
    await Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
      withScope: (scope) {
        scope.setTag('fatal', 'true');
        scope.setContexts('flutter', {
          'library': details.library,
          'context': details.context?.toString(),
        });
      },
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? context,
  }) async {
    if (!_enabled) return;
    await Sentry.captureException(
      error,
      stackTrace: stack,
      withScope: (scope) {
        scope.setTag('fatal', fatal.toString());
        if (context != null) {
          scope.setTag('context', context);
        }
      },
    );
  }

  @override
  Future<List<String>> recentEntries({int limit = 50}) async => const [];

  @override
  Future<String> exportLogsAsText({int limit = 100}) async =>
      _enabled ? 'Sentry remote sink is enabled.' : 'Sentry not enabled.';
}

class _AsyncLock {
  Future<void> _tail = Future.value();

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await action());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }
}
