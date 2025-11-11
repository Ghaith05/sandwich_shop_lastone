class SavedOrder {
  final int id;
  final String orderId;
  final double totalAmount;
  final int itemCount;
  final DateTime orderDate;

  SavedOrder({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.itemCount,
    required this.orderDate,
  });

  Map<String, Object?> toMap() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'orderDate': orderDate.millisecondsSinceEpoch,
    };
  }

  SavedOrder.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        orderId = map['orderId'] as String,
        totalAmount = map['totalAmount'] as double,
        itemCount = map['itemCount'] as int,
        orderDate =
            DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int);
}