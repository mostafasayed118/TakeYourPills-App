import 'medication_read_repository.dart';
import 'medication_write_repository.dart';

/// Combined interface for medication repository operations.
/// Prefer injecting specific read/write interfaces for better testability.
abstract class MedicationRepository
    implements MedicationReadRepository, MedicationWriteRepository {}
