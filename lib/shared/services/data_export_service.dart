import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/entities/dose_log.dart';
import '../../core/entities/medication.dart';
import '../../core/error/result.dart';
import '../../data/repositories/medication_repository.dart';

/// Exports local medication data as portable JSON for backup / sharing.
class DataExportService {
  DataExportService({required MedicationRepository repository})
    : _repository = repository;

  final MedicationRepository _repository;

  static const exportFormatVersion = 1;

  /// Builds the export map without writing to disk (testable).
  Future<Map<String, dynamic>> buildExportPayload() async {
    final medsResult = await _repository.getAllMedications();
    final medications = medsResult.getOrNull() ?? const <Medication>[];

    final doseLogs = <DoseLog>[];
    for (final med in medications) {
      final logsResult = await _repository.getDoseLogsForMedication(med.id);
      final logs = logsResult.getOrNull() ?? const <DoseLog>[];
      doseLogs.addAll(logs);
    }

    // Stable order for diffs / tests.
    doseLogs.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    return {
      'formatVersion': exportFormatVersion,
      'app': 'TakeYourPills',
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'medicationCount': medications.length,
      'doseLogCount': doseLogs.length,
      'medications': medications.map((m) => m.toJson()).toList(),
      'doseLogs': doseLogs.map((d) => d.toJson()).toList(),
    };
  }

  Future<String> buildExportJson({bool pretty = true}) async {
    final payload = await buildExportPayload();
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(payload);
    }
    return jsonEncode(payload);
  }

  /// Writes JSON under the app documents directory and returns the file.
  Future<File> writeExportFile() async {
    final json = await buildExportJson();
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File(p.join(dir.path, 'takeyourpills_export_$stamp.json'));
    await file.writeAsString(json, flush: true);
    return file;
  }

  /// Writes the export file and opens the system share sheet.
  Future<ShareResult> shareExport() async {
    final file = await writeExportFile();
    return SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'TakeYourPills data export',
        text:
            'Local medication backup from TakeYourPills. '
            'Contains health-related data — share only with people you trust.',
      ),
    );
  }
}
