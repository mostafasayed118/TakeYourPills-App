import 'package:flutter/foundation.dart';
import '../../core/entities/dose_log.dart';
import '../entities/medication.dart';

/// Reactive state container for dashboard data.
/// Uses ValueNotifier for fine-grained rebuilds.
class DashboardState extends ChangeNotifier {
  double _adherenceRate = 0;
  List<Medication> _medications = [];
  List<DoseLog> _todayDoseLogs = [];
  bool _isLoading = false;
  String? _error;

  double get adherenceRate => _adherenceRate;
  List<Medication> get medications => List.unmodifiable(_medications);
  List<DoseLog> get todayDoseLogs => List.unmodifiable(_todayDoseLogs);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAdherence(double rate) {
    if (_adherenceRate != rate) {
      _adherenceRate = rate;
      notifyListeners();
    }
  }

  void updateMedications(List<Medication> medications) {
    if (!listEquals(_medications, medications)) {
      _medications = medications;
      notifyListeners();
    }
  }

  void updateDoseLogs(List<DoseLog> logs) {
    if (!listEquals(_todayDoseLogs, logs)) {
      _todayDoseLogs = logs;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
