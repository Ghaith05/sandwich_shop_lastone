import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('add to cart updates cart and resets quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Add 2 sandwiches
      final addButton = find.widgetWithText(ElevatedButton, 'Add');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
      await tester.tap(addButton);
      await tester.pump();
      expect(find.text('2 white footlong sandwich(es): 🥪🥪'), findsOneWidget);
      // Add to cart
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pump();
      // Quantity should reset
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      // Cart badge should show 2
      expect(find.text('2'), findsOneWidget);
    });
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final addButton = find.widgetWithText(ElevatedButton, 'Add');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final addButton = find.widgetWithText(ElevatedButton, 'Add');
      final removeButton = find.widgetWithText(ElevatedButton, 'Remove');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.ensureVisible(removeButton);
      await tester.tap(removeButton);
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final addButton = find.widgetWithText(ElevatedButton, 'Add');
      await tester.ensureVisible(addButton);
      for (int i = 0; i < 10; i++) {
        await tester.tap(addButton);
        await tester.pump();
      }
      expect(find.text('5 white footlong sandwich(es): 🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changing sandwich type updates image and label',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Initial: footlong
      final switchFinders = find.byType(Switch);
      expect(switchFinders, findsNWidgets(2));
      // Tap footlong/six-inch switch
      await tester.tap(switchFinders.at(0));
      await tester.pumpAndSettle();
      expect(find.textContaining('six-inch sandwich'), findsOneWidget);
      // Tap again to return to footlong
      await tester.tap(switchFinders.at(0));
      await tester.pumpAndSettle();
      expect(find.textContaining('footlong sandwich'), findsOneWidget);
    });
    testWidgets('changing bread type updates label',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
    });
    testWidgets('note field updates and resets after add to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'No onions');
      await tester.pump();
      expect(find.text('Note: No onions'), findsOneWidget);
      // Add 1 sandwich
      final addButton = find.widgetWithText(ElevatedButton, 'Add');
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pump();
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pump();
      // Note should reset
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });
    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(
          find.textContaining('wholemeal footlong sandwich'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('3 white footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('2 wheat six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        orderNote: 'Lots of lettuce',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('1 wholemeal footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });

  group('OrderScreen - Sandwich Type Switch', () {
    testWidgets('toggles footlong/six-inch switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // There are two Switch widgets: [0] is footlong/six-inch, [1] is toasted/untoasted
      final switchFinders = find.byType(Switch);
      expect(switchFinders, findsNWidgets(2));

      // Initial state: footlong
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);

      // Tap the first Switch (footlong/six-inch)
      await tester.tap(switchFinders.at(0));
      await tester.pumpAndSettle();
      expect(find.text('0 white six-inch sandwich(es): '), findsOneWidget);

      // Tap again to return to footlong
      await tester.tap(switchFinders.at(0));
      await tester.pumpAndSettle();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('toggles toasted/untoasted switch (debug)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // There are two Switch widgets: [0] is footlong/six-inch, [1] is toasted/untoasted
      final switchFinders = find.byType(Switch);
      expect(switchFinders, findsNWidgets(2));

      // No direct text output for toasted/untoasted, so we debug by toggling and checking widget state
      // Tap the second Switch (toasted/untoasted)
      await tester.tap(switchFinders.at(1));
      await tester.pumpAndSettle();
      // No visible text changes, but you could add debug output or check widget state if exposed
      // For now, just ensure the switch can be toggled without error
      expect(switchFinders, findsNWidgets(2));

      // Tap again to return
      await tester.tap(switchFinders.at(1));
      await tester.pumpAndSettle();
      expect(switchFinders, findsNWidgets(2));
    });
  });
}

// Helper tests removed; keep file focused on widget tests above.
