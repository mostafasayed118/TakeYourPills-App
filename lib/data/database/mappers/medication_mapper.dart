import '../../../core/entities/medication.dart'
    as domain;
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

  static MedicationData toModel(domain.Medication entity) => MedicationData(
      id: entity.id,
      name: entity.name,
      dosageAmount: entity.dosageAmount,
      dosageUnit: entity.dosageUnit,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      frequencyType: entity.frequencyType,
      frequencyDays: entity.frequencyDays,
      frequencyInterval: entity.frequencyInterval,
      scheduleTimes: entity.scheduleTimes,
      startDate: entity.startDate,
      endDate: entity.endDate,
      instructions: entity.instructions,
      isPaused: entity.isPaused,
      pillsRemaining: entity.pillsRemaining,
      refillThreshold: entity.refillThreshold,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );

  static List<domain.Medication> toEntityList(List<MedicationData> models) => models.map(toEntity).toList();

  static List<MedicationData> toModelList(List<domain.Medication> entities) => entities.map(toModel).toList();
}
