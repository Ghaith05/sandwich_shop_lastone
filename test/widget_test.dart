import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

/// Verifies that the app's initial screen displays the correct static content.
///
/// This test checks the essential UI elements that should be visible
/// when the app starts. It looks for the app bar title and the counter text.
Future<void> _testAppDisplaysCorrectInitialContent(WidgetTester tester) async {
  // Build the App widget and trigger a frame to render it.
  await tester.pumpWidget(const App());

  // Verify that the app bar title is visible.
  expect(find.text('Sandwich Counter'), findsOneWidget);

  // Verify that the hardcoded sandwich text is visible.
  expect(find.text('5 Footlong sandwich(es): 🥪🥪🥪🥪🥪'), findsOneWidget);
}

/// The main entry point for running all widget tests.
void main() {
  // A group for tests that check the basic appearance of the app.
  group('App smoke tests', () {
    // Defines a single test case for the initial content.
    testWidgets('App shows correct title and initial counter',
        _testAppDisplaysCorrectInitialContent);
  });
}
