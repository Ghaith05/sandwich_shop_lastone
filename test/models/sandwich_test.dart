import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns correct string for each type', () {
      expect(
        Sandwich(
                type: SandwichType.veggieDelight,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Veggie Delight',
      );
      expect(
        Sandwich(
                type: SandwichType.chickenTeriyaki,
                isFootlong: false,
                breadType: BreadType.wheat)
            .name,
        'Chicken Teriyaki',
      );
      expect(
        Sandwich(
                type: SandwichType.tunaMelt,
                isFootlong: true,
                breadType: BreadType.wholemeal)
            .name,
        'Tuna Melt',
      );
      expect(
        Sandwich(
                type: SandwichType.meatballMarinara,
                isFootlong: false,
                breadType: BreadType.white)
            .name,
        'Meatball Marinara',
      );
    });

    test('image getter returns correct path for footlong and six-inch', () {
      final veggieFootlong = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final veggieSixInch = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(veggieFootlong.image, 'assets/images/veggieDelight_footlong.png');
      expect(veggieSixInch.image, 'assets/images/veggieDelight_six_inch.png');
    });

    test('breadType is set correctly', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      expect(sandwich.breadType, BreadType.wholemeal);
    });
  });
}
