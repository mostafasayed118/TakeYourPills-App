import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/dashboard_page.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepository;

  setUp(() {
    mockRepository = MockMedicationRepository();
  });

  group('DashboardPage — widget tests', () {
    testWidgets('renders empty state when no medications', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.getAllMedications(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RepositoryProvider<MedicationRepository>(
              create: (_) => mockRepository,
              child: const DashboardPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('TakeYourPills'), findsOneWidget);
      expect(find.text('Good Morning, Alex'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('renders medications in dashboard elements', (
      WidgetTester tester,
    ) async {
      final meds = [
        Medication(
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
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        Medication(
          id: 2,
          name: 'Lisinopril',
          dosageAmount: '10',
          dosageUnit: 'mg',
          iconName: 'pill',
          colorHex: '',
          frequencyType: 'daily',
          frequencyDays: '[]',
          frequencyInterval: 1,
          scheduleTimes: '["09:00","21:00"]',
          isPaused: false,
          createdAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2),
        ),
      ];

      when(
        () => mockRepository.getAllMedications(),
      ).thenAnswer((_) async => meds);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RepositoryProvider<MedicationRepository>(
              create: (_) => mockRepository,
              child: const DashboardPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('TakeYourPills'), findsOneWidget);
      expect(find.text('Good Morning, Alex'), findsOneWidget);
      expect(find.text('Lisinopril'), findsOneWidget);
      expect(find.text('Vitamin D3'), findsOneWidget);
    });
  });
}

class RepositoryProvider<T> extends StatelessWidget {
  final T Function(BuildContext) create;
  final Widget child;

  const RepositoryProvider({
    required this.create,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
