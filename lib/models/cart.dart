import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  Cart();
  final Map<Sandwich, int> _items = {};

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }

  void replaceItem(Sandwich sandwich, Sandwich updated) {}

  void removeCompletely(Sandwich sandwichA) {}

  Map<String, dynamic> toJson() {
    return {
      'items': _items.entries.map((entry) {
        return {
          'sandwich': entry.key.toJson(),
          'quantity': entry.value,
        };
      }).toList(),
    };
  }

  static Cart fromJson(Map<String, dynamic> json) {
    final cart = Cart();
    final items = json['items'] as List<dynamic>? ?? [];
    for (final item in items) {
      final sandwichMap = item['sandwich'] as Map<String, dynamic>;
      final quantity = (item['quantity'] as int?) ?? 0;
      final sandwich = Sandwich.fromJson(sandwichMap);
      if (quantity > 0) {
        cart._items[sandwich] = quantity;
      }
    }
    return cart;
  }
}