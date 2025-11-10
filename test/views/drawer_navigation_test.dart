import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  testWidgets('Drawer opens and navigates to Cart and Profile',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    // Open drawer via AppBar menu
    final Finder menuFinder = find.byTooltip('Open navigation menu');
    expect(menuFinder, findsOneWidget);
    await tester.tap(menuFinder);
    await tester.pumpAndSettle();

    // Tap Cart in drawer
    final Finder cartTile = find.text('Cart');
    expect(cartTile, findsOneWidget);
    await tester.tap(cartTile);
    await tester.pumpAndSettle();

    // Should navigate to Cart screen
    expect(find.text('Cart View'), findsOneWidget);

    // Open drawer from Cart screen
    final Finder menuFinder2 = find.byTooltip('Open navigation menu');
    expect(menuFinder2, findsOneWidget);
    await tester.tap(menuFinder2);
    await tester.pumpAndSettle();

    // Tap Profile in drawer
    final Finder profileTile = find.text('Profile');
    expect(profileTile, findsOneWidget);
    await tester.tap(profileTile);
    await tester.pumpAndSettle();

    // Should navigate to Profile screen
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byKey(const Key('profile_name')), findsOneWidget);
  });
}
