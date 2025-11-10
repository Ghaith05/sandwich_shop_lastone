import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

void main() {
  group('CheckoutScreen', () {
    testWidgets('displays order summary, items and total',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich s2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.add(s1, quantity: 2);
      cart.add(s2, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

      expect(find.text('Order Summary'), findsOneWidget);
      // item rows
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('1x Chicken Teriyaki'), findsOneWidget);

      // prices should be shown for each line and total displayed
      expect(find.text('£${(11.0 * 2).toStringAsFixed(2)}'), findsOneWidget);
      // chicken six-inch price 7.0
      expect(find.text('£${(7.0 * 1).toStringAsFixed(2)}'), findsOneWidget);

      final total = cart.totalPrice;
      expect(find.text('£${total.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('tapping Confirm Payment processes and returns confirmation',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(s1, quantity: 1);

      final Completer completer = Completer<dynamic>();

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                child: const Text('open'),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CheckoutScreen(cart: cart)),
                  );
                  completer.complete(result);
                },
              ),
            ),
          );
        }),
      ));

      // open checkout
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // tap confirm
      expect(find.text('Confirm Payment'), findsOneWidget);
      await tester.tap(find.text('Confirm Payment'));

      // After tapping, the processing indicator should appear
      await tester.pump(); // rebuild after setState
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);

      // advance time to allow the fake payment delay to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // the navigator should have popped with a confirmation map
      final result = await completer.future;
      expect(result, isA<Map>());
      expect(result.containsKey('orderId'), isTrue);
      expect(result['totalAmount'], equals(cart.totalPrice));
      expect(result['itemCount'], equals(cart.countOfItems));
      expect(result['estimatedTime'], equals('15-20 minutes'));
    });
  });
}
