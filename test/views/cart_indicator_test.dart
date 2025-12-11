import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

void main() {
  testWidgets('AppTopBar cart indicator updates when cart changes',
      (WidgetTester tester) async {
    final Cart cart = Cart();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: const MaterialApp(home: OrderScreen()),
      ),
    );

    await tester.pump();

    // Initially should display '0' in the cart indicator
    final Finder initialInIndicator = find.descendant(
      of: find.byType(CartIndicator),
      matching: find.text('0'),
    );
    expect(initialInIndicator, findsOneWidget);

    // Add a sandwich to the cart
    final Sandwich sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
    );

    cart.add(sandwich, quantity: 1);

    // Rebuild
    await tester.pump();

    // Now the CartIndicator should show '1'
    final Finder updatedInIndicator = find.descendant(
      of: find.byType(CartIndicator),
      matching: find.text('1'),
    );
    expect(updatedInIndicator, findsOneWidget);
  });
}
