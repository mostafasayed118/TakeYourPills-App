import 'package:drift/drift.dart';

import '../../../core/entities/dose_log.dart'
    as domain;
import '../app_database.dart';


/// Maps between Drift's [DoseLogData] and domain [domain.DoseLog].
class DoseLogMapper {
  static domain.DoseLog toEntity(DoseLogData model) => domain.DoseLog(
      id: model.id,
      medicationId: model.medicationId,
      scheduleId: model.scheduleId,
      scheduledTime: model.scheduledTime,
      actualTime: model.actualTime,
      status: _safeParseStatus(model.status),
      snoozeCount: model.snoozeCount,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );

  static DoseLogData toModel(domain.DoseLog entity) => DoseLogData(
      id: entity.id,
      medicationId: entity.medicationId,
      scheduleId: entity.scheduleId,
      scheduledTime: entity.scheduledTime,
      actualTime: entity.actualTime,
      status: entity.status.index,
      snoozeCount: entity.snoozeCount,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );

  static DoseLogsCompanion toCompanion(domain.DoseLog entity) => DoseLogsCompanion(
      id: entity.id == 0 ? const Value.absent() : Value(entity.id),
      medicationId: Value(entity.medicationId),
      scheduleId: entity.scheduleId == null
          ? const Value.absent()
          : Value(entity.scheduleId),
      scheduledTime: Value(entity.scheduledTime),
      actualTime: entity.actualTime == null
          ? const Value.absent()
          : Value(entity.actualTime),
      status: Value(entity.status.index),
      snoozeCount: Value(entity.snoozeCount),
      notes: entity.notes == null
          ? const Value.absent()
          : Value(entity.notes),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );

  static List<domain.DoseLog> toEntityList(List<DoseLogData> models) => models.map(toEntity).toList();

  static domain.DoseLogStatus _safeParseStatus(int index) {
    if (index >= 0 && index < domain.DoseLogStatus.values.length) {
      return domain.DoseLogStatus.values[index];
    }
    return domain.DoseLogStatus.pending; // Safe fallback
  }
}
