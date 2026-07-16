import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/domain/dashboard_domain_service.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/dashboard_page.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
    when(() => mockRepository.watchAllMedications()).thenAnswer(
      (_) => const Stream<Result<List<Medication>>>.empty(),
    );
    when(
      () => mockRepository.getDoseLogsForDateRange(any(), any()),
    ).thenAnswer((_) async => const Success<List<DoseLog>>([]));
  });

  Widget pumpDashboard() => MaterialApp(
        home: BlocProvider(
          create: (_) => DashboardCubit(
            repository: mockRepository,
            domainService: DashboardDomainService(),
          ),
          child: const DashboardPage(),
        ),
      );

  group('DashboardPage — widget tests', () {
    testWidgets('renders empty medications summary', (tester) async {
      when(() => mockRepository.getAllMedications()).thenAnswer(
        (_) async => const Success<List<Medication>>([]),
      );

      await tester.pumpWidget(pumpDashboard());
      await tester.pumpAndSettle();

      expect(find.text('TakeYourPills'), findsOneWidget);
      expect(find.textContaining('Good'), findsOneWidget);
      expect(
        find.text('Add a medication to see your next dose here.'),
        findsOneWidget,
      );
    });

    testWidgets('renders next dose from repository data', (tester) async {
      final laterHour = (DateTime.now().hour + 3).clamp(0, 23);
      final meds = [
        Medication(
          id: 2,
          name: 'Lisinopril',
          dosageAmount: '10',
          dosageUnit: 'mg',
          iconName: 'pill',
          scheduleTimes: '["${laterHour.toString().padLeft(2, '0')}:30"]',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ];

      when(() => mockRepository.getAllMedications()).thenAnswer(
        (_) async => Success<List<Medication>>(meds),
      );

      await tester.pumpWidget(pumpDashboard());
      await tester.pumpAndSettle();

      expect(find.text('TakeYourPills'), findsOneWidget);
      expect(find.text('Lisinopril'), findsWidgets);
    });
  });
}
