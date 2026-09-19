// Smoke test: the app boots through the splash screen to home and shows
// the entry point for starting a game.

import 'package:flutter_test/flutter_test.dart';

import 'package:tap_the_dot/app.dart';

void main() {
  testWidgets('Home screen shows Start Game button after splash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TapTheDotApp());
    await tester.pump();

    expect(find.text('TAP THE DOT'), findsOneWidget);

    // Splash auto-navigates to Home after ~1.6s.
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('TAP THE DOT'), findsOneWidget);
    expect(find.text('START GAME'), findsOneWidget);
  });
}
