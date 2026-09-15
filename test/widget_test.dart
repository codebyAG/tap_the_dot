// Smoke test: the app boots to the home screen and shows the entry point
// for starting a game.

import 'package:flutter_test/flutter_test.dart';

import 'package:tap_the_dot/app/app.dart';

void main() {
  testWidgets('Home screen shows Start Game button', (WidgetTester tester) async {
    await tester.pumpWidget(const TapTheDotApp());
    await tester.pump();

    expect(find.text('TAP THE DOT'), findsOneWidget);
    expect(find.text('START GAME'), findsOneWidget);
  });
}
