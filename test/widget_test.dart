// Smoke test: the app boots through the splash screen (logo art, no
// literal title text) to home and shows the entry point for starting a
// game.

import 'package:flutter_test/flutter_test.dart';

import 'package:tap_the_dot/app.dart';

void main() {
  testWidgets('Home screen shows Start Game button after splash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TapTheDotApp());
    await tester.pump();

    // Splash auto-navigates to Home after ~1.6s. One pump elapses the
    // delay and fires the Future.delayed callback; a second pump builds
    // the resulting route change.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('START GAME'), findsOneWidget);
  });
}
