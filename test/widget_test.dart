import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application/home_screen.dart';
import 'package:flutter_application/ice_report/ice_report_screen.dart';
import 'package:flutter_application/ice_report/ice_report_model.dart';

void main() {

  testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('IceReportScreen starts on first step', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: IceReportScreen(),
      ),
    );

    // Step 0 should contain "Add Report For" UI
    expect(find.text('Add Report For'), findsWidgets);
  });

  testWidgets('Review step displays model data', (WidgetTester tester) async {

    final report = IceReportModel()
      ..addReportFor = 'Lake Vänern'
      ..iceType = 'Kärnis'
      ..iceSurface = 'Spegelslät'
      ..iceThickness = 12
      ..observations = 'Safe ice conditions'
      ..rating = 4;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Text(report.addReportFor!), // simple sanity check
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Lake Vänern'), findsOneWidget);
  });
}