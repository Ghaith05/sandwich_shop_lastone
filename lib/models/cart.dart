import 'package:sandwich_shop/models/sandwich.dart';

class CartItem {
  final Sandwich sandwich;
  final int quantity;
  final String? note;

  CartItem({
    required this.sandwich,
    required this.quantity,
    this.note,
  });
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart({
    required Sandwich sandwich,
    required int quantity,
    String? note,
  }) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }

    _items.add(CartItem(
      sandwich: sandwich,
      quantity: quantity,
      note: note,
    ));
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= _items.length) {
      throw ArgumentError('Invalid cart item index');
    }
    _items.removeAt(index);
  }

  void clear() {
    _items.clear();
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calculate total price for items in the cart.
  /// Footlong = £11, Six-inch = £7.
  double get totalPrice {
    const double sixInchPrice = 7.0;
    const double footlongPrice = 11.0;
    return _items.fold(0.0, (sum, item) {
      final pricePer = item.sandwich.isFootlong ? footlongPrice : sixInchPrice;
      return sum + pricePer * item.quantity;
    });
  }

  void add(Sandwich sandwich, {required int quantity}) {}
}
