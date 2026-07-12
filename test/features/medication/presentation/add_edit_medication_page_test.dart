import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/add_edit_medication_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';

class FakeMedication extends Fake implements Medication {}

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepository;
  final testMed = Medication(
    id: 1,
    name: 'Aspirin',
    dosageAmount: '100',
    dosageUnit: 'mg',
    iconName: 'pill',
    frequencyDays: '[]',
    scheduleTimes: '["08:00"]',
    instructions: 'Take with food',
    pillsRemaining: 30,
    refillThreshold: 10,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(FakeMedication());
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
  });

  Widget createTestWidget({
    required Widget child,
    bool isEditing = false,
    String? medicationId,
  }) {
    final router = GoRouter(
      initialLocation: '/add',
      routes: [
        GoRoute(
          path: '/',
          builder: (c, s) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: 'add',
              builder: (c, s) => Scaffold(body: child),
            ),
            GoRoute(
              path: 'add-medication/:medicationId',
              builder: (c, s) =>
                  const Scaffold(body: Text('Edit Medication Page')),
            ),
          ],
        ),
      ],
    );
    return RepositoryProvider<MedicationRepository>(
      create: (c) => mockRepository,
      child: BlocProvider<MedicationFormCubit>(
        create: (c) => MedicationFormCubit(
          repository: mockRepository,
          isEditing: isEditing,
          existingMedId: medicationId != null
              ? int.tryParse(medicationId)
              : null,
        ),
        child: MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        ),
      ),
    );
  }

  group('AddEditMedicationPage Widget Tests', () {
    testWidgets('renders initial form in add mode', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getMedicationById(any()),
      ).thenAnswer((_) async => const Success<Medication?>(null));

      await tester.pumpWidget(
        createTestWidget(child: const AddEditMedicationPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Medication'), findsOneWidget);
      expect(find.byType(AppInput), findsWidgets);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Save Medication'), findsOneWidget);
    });

    testWidgets('renders form in edit mode with existing data', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getMedicationById(1),
      ).thenAnswer((_) async => Success<Medication?>(testMed));

      await tester.pumpWidget(
        createTestWidget(
          child: const AddEditMedicationPage(
            isEditing: true,
            medicationId: '1',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Medication'), findsOneWidget);
      expect(find.text('Aspirin'), findsWidgets);
      expect(find.text('mg'), findsOneWidget);
      expect(find.text('Take with food'), findsOneWidget);
      expect(find.text('Pills Remaining'), findsOneWidget);
      expect(find.text('Refill Alert At'), findsOneWidget);
    });

    testWidgets('shows validation errors when saving empty form', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getMedicationById(any()),
      ).thenAnswer((_) async => const Success<Medication?>(null));

      await tester.pumpWidget(
        createTestWidget(child: const AddEditMedicationPage()),
      );
      await tester.pumpAndSettle();

      // Scroll to save button if needed
      final saveBtn = find.text('Save Medication');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();

      // Tap save without entering anything
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Expect validation error for name
      expect(find.text('Medication name is required'), findsOneWidget);
    });

    testWidgets('calls repository createMedication when valid form submitted', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getMedicationById(any()),
      ).thenAnswer((_) async => const Success<Medication?>(null));

      when(
        () => mockRepository.createMedication(any()),
      ).thenAnswer((_) async => const Success(1));

      await tester.pumpWidget(
        createTestWidget(child: const AddEditMedicationPage()),
      );
      await tester.pumpAndSettle();

      // Enter name
      final nameInput = find.byKey(const Key('medication_name'));
      await tester.ensureVisible(nameInput);
      await tester.enterText(nameInput, 'Ibuprofen');

      // Enter dosage
      final dosageInput = find.byKey(const Key('dosage_amount'));
      await tester.ensureVisible(dosageInput);
      await tester.enterText(dosageInput, '200');

      // Enter schedule time
      final scheduleInput = find.byKey(const Key('schedule_times'));
      await tester.ensureVisible(scheduleInput);
      await tester.enterText(scheduleInput, '08:00');

      // Save form
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      final saveBtn = find.text('Save Medication');
      await tester.tap(saveBtn);
      // Wait a short duration instead of pumpAndSettle to avoid timeout from indefinite animations
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => mockRepository.createMedication(any())).called(1);
    });
  });
}
