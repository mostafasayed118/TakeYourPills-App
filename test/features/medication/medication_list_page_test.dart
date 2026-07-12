import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/medication_list_page.dart';

class FakeMedication extends Fake implements Medication {}

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
  });

  group('MedicationListPage — widget tests', () {
    testWidgets('renders empty state when no medications', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getAllMedications(),
      ).thenAnswer((_) async => const Success<List<Medication>>([]));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MedicationRepository>.value(
            value: mockRepository,
            child: BlocProvider(
              create: (context) => MedicationListCubit(mockRepository),
              child: const MedicationListPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No medications yet'), findsOneWidget);
      expect(find.text('Add Medication'), findsOneWidget);
    });

    testWidgets('renders medication list with items', (
      WidgetTester tester,
    ) async {
      final meds = [
        Medication(
          id: 1,
          name: 'Aspirin',
          dosageAmount: '100',
          dosageUnit: 'mg',
          iconName: 'pill',
          frequencyDays: '[]',
          scheduleTimes: '["08:00"]',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        Medication(
          id: 2,
          name: 'Lisinopril',
          dosageAmount: '10',
          dosageUnit: 'mg',
          iconName: 'pill',
          frequencyDays: '[]',
          scheduleTimes: '["09:00","21:00"]',
          createdAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2),
        ),
      ];

      when(
        () => mockRepository.getAllMedications(),
      ).thenAnswer((_) async => Success<List<Medication>>(meds));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MedicationRepository>.value(
            value: mockRepository,
            child: BlocProvider(
              create: (context) => MedicationListCubit(mockRepository),
              child: const MedicationListPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Lisinopril'), findsOneWidget);
      expect(find.text('100 mg'), findsOneWidget);
      expect(find.text('10 mg'), findsOneWidget);
    });

    testWidgets('shows error state when loading fails', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getAllMedications(),
      ).thenAnswer((_) async => const ResultFailure<List<Medication>>('DB error'));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MedicationRepository>.value(
            value: mockRepository,
            child: BlocProvider(
              create: (context) => MedicationListCubit(mockRepository),
              child: const MedicationListPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Error: DB error'), findsOneWidget);
    });
  });
}
