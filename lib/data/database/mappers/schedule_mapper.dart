import 'package:takeyourpills_healthcare_app/core/entities/schedule.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/schedules.dart';
import 'package:drift/drift.dart';

class ScheduleMapper {
  static Schedule toEntity(ScheduleData model) {
    return Schedule(
      id: model.id,
      medicationId: model.medicationId,
      hour: model.hour,
      minute: model.minute,
      weekdaysBitfield: model.weekdaysBitfield,
      isAsNeeded: model.isAsNeeded,
    );
  }

  static ScheduleData toModel(Schedule entity) {
    return ScheduleData(
      id: entity.id,
      medicationId: entity.medicationId,
      hour: entity.hour,
      minute: entity.minute,
      weekdaysBitfield: entity.weekdaysBitfield,
      isAsNeeded: entity.isAsNeeded,
    );
  }

  static SchedulesCompanion toCompanion(Schedule entity) {
    return SchedulesCompanion(
      id: entity.id == 0 ? const Value.absent() : Value(entity.id),
      medicationId: Value(entity.medicationId),
      hour: Value(entity.hour),
      minute: Value(entity.minute),
      weekdaysBitfield: Value(entity.weekdaysBitfield),
      isAsNeeded: Value(entity.isAsNeeded),
    );
  }

  static List<Schedule> toEntityList(List<ScheduleData> models) {
    return models.map(toEntity).toList();
  }
}
