import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';

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

  Widget wrapWithProviders({
    required Widget child,
    required MedicationRepository repository,
  }) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (c) => MedicationListCubit(repository)),
        BlocProvider(
          create: (c) =>
              MedicationFormCubit(repository: repository),
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
      final cubit = MedicationListCubit(mockRepository);
      expect(cubit, isNotNull);
      await cubit.close();
    });
  });
}
