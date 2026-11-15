import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mvu_platform/dto/absenz.dart';
import 'package:mvu_platform/widget/absenz_card.dart';

Absenz absenz({String interna = '', bool infoOnly = false}) => Absenz(
  7,
  42,
  'Probe',
  'Mittwoch, 19:30',
  interna,
  AbsenzState.unknown,
  'komme später',
  'Probe MVU',
  'Zentrum Urdorf',
  DateTime(2026, 11, 18, 19, 30),
  DateTime(2026, 11, 18, 22),
  infoOnly,
);

Future<void> pumpCard(WidgetTester tester, Absenz absenz) => tester.pumpWidget(MaterialApp(home: Scaffold(body: AbsenzCard(absenz))));

// Tapping the status buttons or editing the remark triggers a backend call
// (Firebase Auth + http), so these tests only cover rendering.
void main() {
  testWidgets('shows title, subtitle, status buttons and remark', (tester) async {
    await pumpCard(tester, absenz());

    expect(find.text('Probe'), findsOneWidget);
    expect(find.text('Mittwoch, 19:30'), findsOneWidget);
    expect(find.text('anwesend'), findsOneWidget);
    expect(find.text('abwesend'), findsOneWidget);
    expect(find.text('inaktiv'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'komme später'), findsOneWidget);
  });

  testWidgets('hides status buttons and remark for info-only events', (tester) async {
    await pumpCard(tester, absenz(infoOnly: true));

    expect(find.text('Probe'), findsOneWidget);
    expect(find.text('anwesend'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shows expandable details only when interna is set', (tester) async {
    await pumpCard(tester, absenz());
    expect(find.text('Details'), findsNothing);

    await pumpCard(tester, absenz(interna: 'Register Holz'));
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Register Holz'), findsNothing);

    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();
    expect(find.text('Register Holz'), findsOneWidget);
  });
}
