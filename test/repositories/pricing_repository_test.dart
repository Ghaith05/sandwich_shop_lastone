import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repo = PricingRepository();

    test('returns 0.0 for zero quantity', () {
      expect(repo.calculateTotalPrice(quantity: 0, isFootlong: true), 0.0);
      expect(repo.calculateTotalPrice(quantity: 0, isFootlong: false), 0.0);
    });

    test('calculates price for six-inch sandwiches', () {
      expect(repo.calculateTotalPrice(quantity: 2, isFootlong: false), 14.0);
      expect(repo.calculateTotalPrice(quantity: 3, isFootlong: false), 21.0);
    });

    test('calculates price for footlong sandwiches', () {
      expect(repo.calculateTotalPrice(quantity: 1, isFootlong: true), 11.0);
      expect(repo.calculateTotalPrice(quantity: 4, isFootlong: true), 44.0);
    });

    test('calculates price for mixed sizes (should use isFootlong param)', () {
      expect(repo.calculateTotalPrice(quantity: 1, isFootlong: false), 7.0);
      expect(repo.calculateTotalPrice(quantity: 1, isFootlong: true), 11.0);
    });
  });
}
