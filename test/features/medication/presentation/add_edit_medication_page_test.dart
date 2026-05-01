import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/add_edit_medication_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    colorHex: '',
    frequencyType: 'daily',
    frequencyDays: '[]',
    frequencyInterval: 1,
    scheduleTimes: '["08:00"]',
    isPaused: false,
    instructions: 'Take with food',
    pillsRemaining: 30,
    refillThreshold: 10,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeMedication());
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
  });

  Widget _createTestWidget({
    required Widget child,
    bool isEditing = false,
    String? medicationId,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (c, s) => Scaffold(body: child),
          routes: [
            GoRoute(
              path: '/add-medication/:medicationId',
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
              ? int.tryParse(medicationId!)
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
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        _createTestWidget(child: const AddEditMedicationPage(isEditing: false)),
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
      ).thenAnswer((_) async => testMed);

      await tester.pumpWidget(
        _createTestWidget(
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
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        _createTestWidget(child: const AddEditMedicationPage(isEditing: false)),
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
      ).thenAnswer((_) async => null);
      
      when(
        () => mockRepository.createMedication(any()),
      ).thenAnswer((_) async => 1);

      await tester.pumpWidget(
        _createTestWidget(child: const AddEditMedicationPage(isEditing: false)),
      );
      await tester.pumpAndSettle();

      // Enter name
      final nameInput = find.byType(AppInput).at(0);
      await tester.ensureVisible(nameInput);
      await tester.enterText(nameInput, 'Ibuprofen');
      
      // Enter dosage
      final dosageInput = find.byType(AppInput).at(1);
      await tester.ensureVisible(dosageInput);
      await tester.enterText(dosageInput, '200');
      
      // Select unit (already defaults to mg)
      
      // Save form
      final saveBtn = find.text('Save Medication');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      verify(() => mockRepository.createMedication(any())).called(1);
    });
  });
}
