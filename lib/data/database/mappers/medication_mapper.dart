import 'package:drift/drift.dart';

import '../../../core/entities/medication.dart' as domain;
import '../app_database.dart';

/// Maps between Drift's [MedicationData] and domain [domain.Medication].
class MedicationMapper {
  static domain.Medication toEntity(MedicationData model) => domain.Medication(
      id: model.id,
      name: model.name,
      dosageAmount: model.dosageAmount,
      dosageUnit: model.dosageUnit,
      iconName: model.iconName,
      colorHex: model.colorHex,
      frequencyType: model.frequencyType,
      frequencyDays: model.frequencyDays ?? '[]',
      frequencyInterval: model.frequencyInterval,
      scheduleTimes: model.scheduleTimes,
      startDate: model.startDate,
      endDate: model.endDate,
      instructions: model.instructions,
      isPaused: model.isPaused,
      pillsRemaining: model.pillsRemaining,
      refillThreshold: model.refillThreshold,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );

  /// Companion for INSERT — id is absent so SQLite auto-increments.
  static MedicationsCompanion toCreateCompanion(domain.Medication entity) =>
      MedicationsCompanion(
        name: Value(entity.name),
        dosageAmount: Value(entity.dosageAmount),
        dosageUnit: Value(entity.dosageUnit),
        iconName: Value(entity.iconName),
        colorHex: Value(entity.colorHex),
        frequencyType: Value(entity.frequencyType),
        frequencyDays: Value(entity.frequencyDays),
        frequencyInterval: Value(entity.frequencyInterval),
        scheduleTimes: Value(entity.scheduleTimes),
        startDate: Value(entity.startDate),
        endDate: Value(entity.endDate),
        instructions: Value(entity.instructions),
        isPaused: Value(entity.isPaused),
        pillsRemaining: Value(entity.pillsRemaining),
        refillThreshold: Value(entity.refillThreshold),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );

  /// Companion for UPDATE — id is included.
  static MedicationsCompanion toUpdateCompanion(domain.Medication entity) =>
      MedicationsCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        dosageAmount: Value(entity.dosageAmount),
        dosageUnit: Value(entity.dosageUnit),
        iconName: Value(entity.iconName),
        colorHex: Value(entity.colorHex),
        frequencyType: Value(entity.frequencyType),
        frequencyDays: Value(entity.frequencyDays),
        frequencyInterval: Value(entity.frequencyInterval),
        scheduleTimes: Value(entity.scheduleTimes),
        startDate: Value(entity.startDate),
        endDate: Value(entity.endDate),
        instructions: Value(entity.instructions),
        isPaused: Value(entity.isPaused),
        pillsRemaining: Value(entity.pillsRemaining),
        refillThreshold: Value(entity.refillThreshold),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );

  static List<domain.Medication> toEntityList(List<MedicationData> models) =>
      models.map(toEntity).toList();
}
