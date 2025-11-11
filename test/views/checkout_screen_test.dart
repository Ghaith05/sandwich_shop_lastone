import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Widget appWithCart(Cart cart, Widget home) {
  return ChangeNotifierProvider.value(
      value: cart, child: MaterialApp(home: home));
}

void main() {
  setUpAll(() {
    // Initialize ffi for testing SQLite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Clean database before each test
    await DatabaseService.resetDatabase();
  });

  tearDown(() async {
    // Clean up after each test
    await DatabaseService.resetDatabase();
  });

  group('CheckoutScreen', () {
    testWidgets('displays order summary with empty cart',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      await tester.pumpWidget(appWithCart(emptyCart, const CheckoutScreen()));

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsOneWidget);
    });

    testWidgets('displays order summary with single item',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('2'), findsWidgets);
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('displays order summary with multiple items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('4'), findsWidgets);
      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('shows confirm payment button initially',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Processing payment...'), findsNothing);
    });

    testWidgets('shows processing state when payment is initiated',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      final Finder confirmButtonFinder = find.text('Confirm Payment');
      await tester.tap(confirmButtonFinder);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsNothing);

      await tester.pumpAndSettle();
    });

    testWidgets('calculates item prices correctly for footlong sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich footlongSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(footlongSandwich, quantity: 1);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.textContaining('£11.00'), findsWidgets);
    });

    testWidgets('calculates item prices correctly for six-inch sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sixInchSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sixInchSandwich, quantity: 1);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.textContaining('£7.00'), findsWidgets);
    });

    testWidgets('displays correct total for mixed sandwich sizes',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich footlongSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sixInchSandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(footlongSandwich, quantity: 1);
      cart.add(sixInchSandwich, quantity: 2);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('2x Chicken Teriyaki'), findsOneWidget);
      expect(find.textContaining('£25.00'), findsWidgets);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      final Cart cart = Cart();
      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('payment method text is displayed correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      final Finder paymentMethodFinder =
          find.text('Payment Method: Card ending in 1234');
      expect(paymentMethodFinder, findsOneWidget);

      final Text paymentMethodText = tester.widget<Text>(paymentMethodFinder);
      expect(paymentMethodText.textAlign, equals(TextAlign.center));
    });

    testWidgets('order summary items are properly aligned',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      final Finder rowFinders = find.byType(Row);
      expect(rowFinders, findsWidgets);

      final List<Row> rows = tester.widgetList<Row>(rowFinders).toList();
      final Row itemRow = rows.firstWhere(
        (row) => row.mainAxisAlignment == MainAxisAlignment.spaceBetween,
      );
      expect(itemRow.mainAxisAlignment, equals(MainAxisAlignment.spaceBetween));
    });

    testWidgets('displays divider between items and total',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('shows correct quantity and name format',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 3);

      await tester.pumpWidget(appWithCart(cart, const CheckoutScreen()));

      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('saves order to database when payment is confirmed',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ChangeNotifierProvider.value(
            value: cart,
            child: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      ));

      // Navigate to checkout
      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();

      // Verify we're on checkout screen
      expect(find.text('Checkout'), findsOneWidget);

      // Tap confirm payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      // Verify order was saved to database
      final DatabaseService databaseService = DatabaseService();
      final orders = await databaseService.getOrders();

      expect(orders.length, equals(1));
      expect(orders[0].itemCount, equals(2));
      expect(
          orders[0].totalAmount, equals(22.0)); // 2 footlong veggie @ £11 each
      expect(orders[0].orderId, startsWith('ORD'));
    });

    testWidgets('generates unique order IDs for different payments',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      // First payment
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ChangeNotifierProvider.value(
            value: cart,
            child: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      // Second payment
      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      // Verify both orders have unique IDs
      final DatabaseService databaseService = DatabaseService();
      final orders = await databaseService.getOrders();

      expect(orders.length, equals(2));
      expect(orders[0].orderId, isNot(equals(orders[1].orderId)));
    });

    testWidgets('saves correct order details to database',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 2);

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ChangeNotifierProvider.value(
            value: cart,
            child: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      final DatabaseService databaseService = DatabaseService();
      final orders = await databaseService.getOrders();

      expect(orders.length, equals(1));
      expect(orders[0].itemCount, equals(3)); // 1 + 2 items
      expect(orders[0].totalAmount, equals(25.0)); // £11 + (2 * £7)
      expect(orders[0].orderDate.isBefore(DateTime.now()), isTrue);
      expect(
          orders[0]
              .orderDate
              .isAfter(DateTime.now().subtract(const Duration(minutes: 1))),
          isTrue);
    });
  });
}
