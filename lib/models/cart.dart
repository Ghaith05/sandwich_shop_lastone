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
}
