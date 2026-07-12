import 'package:drift/drift.dart';

import '../../../core/entities/schedule.dart'
    as domain;
import '../app_database.dart';

/// Maps between Drift's [ScheduleData] and domain [domain.Schedule].
class ScheduleMapper {
  static domain.Schedule toEntity(ScheduleData model) => domain.Schedule(
      id: model.id,
      medicationId: model.medicationId,
      hour: model.hour,
      minute: model.minute,
      weekdaysBitfield: model.weekdaysBitfield,
      isAsNeeded: model.isAsNeeded,
    );

  static ScheduleData toModel(domain.Schedule entity) => ScheduleData(
      id: entity.id,
      medicationId: entity.medicationId,
      hour: entity.hour,
      minute: entity.minute,
      weekdaysBitfield: entity.weekdaysBitfield,
      isAsNeeded: entity.isAsNeeded,
    );

  static SchedulesCompanion toCompanion(domain.Schedule entity) => SchedulesCompanion(
      id: entity.id == 0 ? const Value.absent() : Value(entity.id),
      medicationId: Value(entity.medicationId),
      hour: Value(entity.hour),
      minute: Value(entity.minute),
      weekdaysBitfield: Value(entity.weekdaysBitfield),
      isAsNeeded: Value(entity.isAsNeeded),
    );

  static List<domain.Schedule> toEntityList(List<ScheduleData> models) => models.map(toEntity).toList();
}
