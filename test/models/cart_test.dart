import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Sandwich footlongSandwich;
    late Sandwich sixInchSandwich;

    setUp(() {
      cart = Cart();
      footlongSandwich = Sandwich(
        id: 'veggieDelight',
        name: 'Veggie Delight',
        description: '',
        available: true,
        breadType: BreadType.white,
        size: SandwichSize.footlong,
        image: 'assets/images/veggieDelight_footlong.png',
      );
      sixInchSandwich = Sandwich(
        id: 'tunaMelt',
        name: 'Tuna Melt',
        description: '',
        available: true,
        breadType: BreadType.wheat,
        size: SandwichSize.sixInch,
        image: 'assets/images/tunaMelt_six_inch.png',
      );
    });

    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });

    test('can add different types of sandwiches', () {
      cart.addToCart(sandwich: footlongSandwich, quantity: 1);
      cart.addToCart(sandwich: sixInchSandwich, quantity: 2);

      expect(cart.items.length, 2);
      expect(cart.items[0].sandwich.size, SandwichSize.footlong);
      expect(cart.items[0].quantity, 1);
      expect(cart.items[1].sandwich.size, SandwichSize.sixInch);
      expect(cart.items[1].quantity, 2);
      expect(cart.totalItems, 3);
    });

    test('can add sandwiches with notes', () {
      cart.addToCart(
        sandwich: footlongSandwich,
        quantity: 1,
        note: 'No onions',
      );

      expect(cart.items[0].note, 'No onions');
    });

    test('throws error when adding invalid quantity', () {
      expect(
        () => cart.addToCart(sandwich: footlongSandwich, quantity: 0),
        throwsArgumentError,
      );
      expect(
        () => cart.addToCart(sandwich: footlongSandwich, quantity: -1),
        throwsArgumentError,
      );
    });

    test('can remove items by index', () {
      cart.addToCart(sandwich: footlongSandwich, quantity: 1);
      cart.addToCart(sandwich: sixInchSandwich, quantity: 2);

      cart.removeFromCart(0);
      expect(cart.items.length, 1);
      expect(cart.items[0].sandwich.size, SandwichSize.sixInch);
    });

    test('throws error when removing with invalid index', () {
      cart.addToCart(sandwich: footlongSandwich, quantity: 1);

      expect(() => cart.removeFromCart(-1), throwsArgumentError);
      expect(() => cart.removeFromCart(1), throwsArgumentError);
    });

    test('can clear all items', () {
      cart.addToCart(sandwich: footlongSandwich, quantity: 1);
      cart.addToCart(sandwich: sixInchSandwich, quantity: 2);

      cart.clear();
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
    });
  });
}
