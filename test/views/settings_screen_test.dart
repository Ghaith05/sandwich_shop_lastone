import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // start with default mocked prefs
    SharedPreferences.setMockInitialValues({});
    await AppStyles.loadFontSize();
  });

  testWidgets('SettingsScreen shows slider and current font size',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => Cart(),
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    // initial load shows Slider
    // Allow async initState work to complete
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsOneWidget);

    // Verify the current size text is shown
    expect(find.textContaining('Current size:'), findsOneWidget);

    // Save a new font size and rebuild the screen to simulate persistence
    await AppStyles.saveFontSize(20.0);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => Cart(),
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    // Allow async initState work to complete on the re-built screen
    await tester.pumpAndSettle();

    // Validate persistence and UI update (relaxed matcher)
    expect(AppStyles.baseFontSize, equals(20.0));
    expect(find.textContaining('20px'), findsOneWidget);
  });
}
