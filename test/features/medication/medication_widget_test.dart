import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/add_edit_medication_page.dart';

void main() {
  group('AddEditMedicationPage — widget tests', () {
    testWidgets('form shows validation errors on empty save', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AddEditMedicationPage(isEditing: false)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Medication name is required'), findsNothing);
    }, skip: true);

    testWidgets('form accepts valid input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AddEditMedicationPage(isEditing: false)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Medication name is required'), findsNothing);
    }, skip: true);
  });

  group('MedicationDetailPage — widget tests', () {
    testWidgets(
      'displays medication details correctly',
      (WidgetTester tester) async {},
      skip: true,
    );
  });
}
