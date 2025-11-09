import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('constructors and properties work', () {
      final veggieFootlong = Sandwich(
        id: 'veggieDelight',
        name: 'Veggie Delight',
        description: 'A tasty veggie sandwich',
        available: true,
        breadType: BreadType.white,
        size: SandwichSize.footlong,
        image: 'assets/images/veggieDelight_footlong.png',
      );

      final veggieSixInch = Sandwich(
        id: 'veggieDelight',
        name: 'Veggie Delight',
        description: 'A tasty veggie sandwich',
        available: true,
        breadType: BreadType.white,
        size: SandwichSize.sixInch,
        image: 'assets/images/veggieDelight_six_inch.png',
      );

      expect(veggieFootlong.name, 'Veggie Delight');
      expect(veggieFootlong.size, SandwichSize.footlong);
      expect(veggieSixInch.size, SandwichSize.sixInch);
      expect(veggieFootlong.image, 'assets/images/veggieDelight_footlong.png');
      expect(veggieSixInch.image, 'assets/images/veggieDelight_six_inch.png');
      expect(veggieFootlong.breadType, BreadType.white);
    });
  });
}
