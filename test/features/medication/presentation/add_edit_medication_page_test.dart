import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/add_edit_medication_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

class FakeMedication extends Fake implements Medication {}

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderScheduler extends Mock implements ReminderSchedulerService {}

void main() {
  late MockMedicationRepository mockRepository;
  late MockReminderScheduler mockScheduler;
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
    mockScheduler = MockReminderScheduler();
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
          scheduler: mockScheduler,
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

      // Enter dosage amount
      final dosageAmountInput = find.byKey(const Key('dosage_amount'));
      await tester.ensureVisible(dosageAmountInput);
      await tester.enterText(dosageAmountInput, '200');

      // Select dosage unit: 'pill'
      // Find the DropdownButton (which contains the current value 'mg')
      final dosageUnitDropdown = find.byWidgetPredicate(
        (widget) => widget is DropdownButton<String> && find.descendant(of: find.byWidget(widget), matching: find.text('mg')).evaluate().isNotEmpty,
        description: 'DropdownButton containing "mg"',
      );
      await tester.ensureVisible(dosageUnitDropdown);
      await tester.tap(dosageUnitDropdown);
      await tester.pumpAndSettle(); // Wait for the dropdown menu to open

      // Find and tap the 'pill' option
      await tester.tap(find.text('pill').last); // .last to avoid issues if 'pill' appears elsewhere
      await tester.pumpAndSettle(); // Wait for the dropdown menu to close

      // Select frequency type: 'daily' (which displays as 'Every day')
      // Find the DropdownButton (which contains the current value 'Every day')
      final frequencyTypeDropdown = find.byWidgetPredicate(
        (widget) => widget is DropdownButton<String> && find.descendant(of: find.byWidget(widget), matching: find.text('Every day')).evaluate().isNotEmpty,
        description: 'DropdownButton containing "Every day"',
      );
      await tester.ensureVisible(frequencyTypeDropdown);
      await tester.tap(frequencyTypeDropdown);
      await tester.pumpAndSettle(); // Wait for the dropdown menu to open

      // Find and tap the 'Every day' option
      await tester.tap(find.text('Every day').last);
      await tester.pumpAndSettle(); // Wait for the dropdown menu to close

      // Add schedule time: tap 'Add Time' and then 'OK' on the time picker
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle(); // Wait for time picker to appear
      await tester.tap(find.text('OK')); // Just tap OK to select current time
      await tester.pumpAndSettle(); // Wait for time picker to close

      // Enter pills remaining
      // Find the AppInput by its label text, then its internal TextField
      final pillsRemainingInput = find.widgetWithText(AppInput, 'Pills Remaining');
      await tester.ensureVisible(pillsRemainingInput);
      await tester.enterText(find.descendant(of: pillsRemainingInput, matching: find.byType(TextField)), '30');

      // Enter refill alert at
      // Find the AppInput by its label text, then its internal TextField
      final refillAlertInput = find.widgetWithText(AppInput, 'Refill Alert At');
      await tester.ensureVisible(refillAlertInput);
      await tester.enterText(find.descendant(of: refillAlertInput, matching: find.byType(TextField)), '10');

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
