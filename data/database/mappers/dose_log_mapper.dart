import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/dose_logs.dart';
import 'package:drift/drift.dart';

class DoseLogMapper {
  static DoseLog toEntity(DoseLogData model) {
    return DoseLog(
      id: model.id,
      medicationId: model.medicationId,
      scheduleId: model.scheduleId,
      scheduledTime: model.scheduledTime,
      actualTime: model.actualTime,
      status: DoseLogStatus.values[model.status],
      snoozeCount: model.snoozeCount,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static DoseLogData toModel(DoseLog entity) {
    return DoseLogData(
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
  }

  static DoseLogsCompanion toCompanion(DoseLog entity) {
    return DoseLogsCompanion(
      id: entity.id == 0 ? const Value.absent() : Value(entity.id),
      medicationId: Value(entity.medicationId),
      scheduleId: entity.scheduleId == null
          ? const Value.absent()
          : Value(entity.scheduleId!),
      scheduledTime: Value(entity.scheduledTime),
      actualTime: entity.actualTime == null
          ? const Value.absent()
          : Value(entity.actualTime!),
      status: Value(entity.status.index),
      snoozeCount: Value(entity.snoozeCount),
      notes: entity.notes == null
          ? const Value.absent()
          : Value(entity.notes!),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
    );
  }

  static List<DoseLog> toEntityList(List<DoseLogData> models) {
    return models.map(toEntity).toList();
  }
}
