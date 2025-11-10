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

  /// Replace an existing sandwich key with an updated sandwich instance while
  /// preserving the quantity. If the original sandwich is not present, this
  /// becomes a no-op.
  void replaceItem(Sandwich oldSandwich, Sandwich newSandwich) {
    if (!_items.containsKey(oldSandwich)) return;
    final qty = _items.remove(oldSandwich)!;
    // If there is already an entry for newSandwich, merge quantities.
    if (_items.containsKey(newSandwich)) {
      _items[newSandwich] = _items[newSandwich]! + qty;
    } else {
      _items[newSandwich] = qty;
    }
  }

  /// Remove the sandwich entry completely (regardless of its current
  /// quantity). This is a convenience helper for explicit deletions.
  void removeCompletely(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  /// Serialize the cart to JSON. The structure is a list of entries where each
  /// entry contains the sandwich serialized and its quantity.
  Map<String, dynamic> toJson() {
    return {
      'items': _items.entries
          .map((e) => {
                'sandwich': e.key.toJson(),
                'quantity': e.value,
              })
          .toList(),
    };
  }

  /// Construct a Cart from JSON produced by [toJson]. Unknown or invalid
  /// entries are ignored.
  factory Cart.fromJson(Map<String, dynamic> json) {
    final Cart cart = Cart();
    final items = json['items'];
    if (items is List) {
      for (final dynamic entry in items) {
        if (entry is Map<String, dynamic>) {
          try {
            final sandwichMap = entry['sandwich'] as Map<String, dynamic>;
            final quantity = entry['quantity'] as int;
            final sandwich = Sandwich.fromJson(sandwichMap);
            cart.add(sandwich, quantity: quantity);
          } catch (_) {
            // Ignore malformed entries
          }
        }
      }
    }
    return cart;
  }
}
