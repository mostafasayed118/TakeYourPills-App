import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

class FakeMedication extends Fake implements Medication {}

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderScheduler extends Mock implements ReminderSchedulerService {}

void main() {
  late MockMedicationRepository mockRepository;
  late MockReminderScheduler mockScheduler;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
    mockScheduler = MockReminderScheduler();
  });

  Widget wrapWithProviders({
    required Widget child,
    required MedicationRepository repository,
  }) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (c) => MedicationListCubit(repository, scheduler: mockScheduler)),
        BlocProvider(
          create: (c) =>
              MedicationFormCubit(repository: repository, scheduler: mockScheduler),
        ),
      ],
      child: MaterialApp(home: child),
    );

  group('Medication Integration Tests', () {
    testWidgets('FORM: Provider setup works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithProviders(
          repository: mockRepository,
          child: const Material(child: Text('Test')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('MedicationListCubit can be created', (
      WidgetTester tester,
    ) async {
      final cubit = MedicationListCubit(mockRepository, scheduler: mockScheduler);
      expect(cubit, isNotNull);
      await cubit.close();
    });
  });
}
