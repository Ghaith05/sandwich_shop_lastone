import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseService databaseService;

  setUpAll(() {
    // Initialize ffi for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    databaseService = DatabaseService();
  });

  tearDown(() async {
    // Clean up database after each test
    final db = await databaseService.database;
    await db.delete('orders'); // Clear all orders
    await DatabaseService.resetDatabase();
  });

  group('DatabaseService', () {
    test('initializes database successfully', () async {
      final db = await databaseService.database;
      expect(db.isOpen, isTrue);
    });

    test('creates orders table with correct schema', () async {
      final db = await databaseService.database;
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

      expect(tables.any((table) => table['name'] == 'orders'), isTrue);
    });

    test('insertOrder adds order to database', () async {
      final DateTime testDate = DateTime(2024, 11, 11, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD123456',
        totalAmount: 15.99,
        itemCount: 3,
        orderDate: testDate,
      );

      await databaseService.insertOrder(order);

      final orders = await databaseService.getOrders();
      expect(orders.length, equals(1));
      expect(orders[0].orderId, equals('ORD123456'));
      expect(orders[0].totalAmount, equals(15.99));
      expect(orders[0].itemCount, equals(3));
    });

    test('getOrders returns empty list when no orders exist', () async {
      final orders = await databaseService.getOrders();
      expect(orders, isEmpty);
    });

    test('getOrders returns all orders in descending order by date', () async {
      final DateTime date1 = DateTime(2024, 11, 10);
      final DateTime date2 = DateTime(2024, 11, 11);
      final DateTime date3 = DateTime(2024, 11, 12);

      final SavedOrder order1 = SavedOrder(
        id: 0,
        orderId: 'ORD001',
        totalAmount: 10.0,
        itemCount: 1,
        orderDate: date1,
      );

      final SavedOrder order2 = SavedOrder(
        id: 0,
        orderId: 'ORD002',
        totalAmount: 20.0,
        itemCount: 2,
        orderDate: date2,
      );

      final SavedOrder order3 = SavedOrder(
        id: 0,
        orderId: 'ORD003',
        totalAmount: 30.0,
        itemCount: 3,
        orderDate: date3,
      );

      await databaseService.insertOrder(order1);
      await databaseService.insertOrder(order2);
      await databaseService.insertOrder(order3);

      final orders = await databaseService.getOrders();

      expect(orders.length, equals(3));
      // Should be in descending order (newest first)
      expect(orders[0].orderId, equals('ORD003'));
      expect(orders[1].orderId, equals('ORD002'));
      expect(orders[2].orderId, equals('ORD001'));
    });

    test('deleteOrder removes order from database', () async {
      final DateTime testDate = DateTime(2024, 11, 11);
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD123456',
        totalAmount: 15.99,
        itemCount: 3,
        orderDate: testDate,
      );

      await databaseService.insertOrder(order);
      List<SavedOrder> orders = await databaseService.getOrders();
      expect(orders.length, equals(1));

      final int orderId = orders[0].id;
      await databaseService.deleteOrder(orderId);

      orders = await databaseService.getOrders();
      expect(orders, isEmpty);
    });

    test('deleteOrder only removes specified order', () async {
      final DateTime testDate = DateTime(2024, 11, 11);

      final SavedOrder order1 = SavedOrder(
        id: 0,
        orderId: 'ORD001',
        totalAmount: 10.0,
        itemCount: 1,
        orderDate: testDate,
      );

      final SavedOrder order2 = SavedOrder(
        id: 0,
        orderId: 'ORD002',
        totalAmount: 20.0,
        itemCount: 2,
        orderDate: testDate.add(const Duration(seconds: 1)),
      );

      await databaseService.insertOrder(order1);
      await databaseService.insertOrder(order2);

      List<SavedOrder> orders = await databaseService.getOrders();
      expect(orders.length, equals(2));

      // Delete first order (most recent - ORD002)
      await databaseService.deleteOrder(orders[0].id);

      orders = await databaseService.getOrders();
      expect(orders.length, equals(1));
      expect(orders[0].orderId, equals('ORD001'));
    });

    test('insertOrder handles multiple orders with same orderId', () async {
      final DateTime testDate = DateTime(2024, 11, 11);

      final SavedOrder order1 = SavedOrder(
        id: 0,
        orderId: 'ORD123',
        totalAmount: 10.0,
        itemCount: 1,
        orderDate: testDate,
      );

      final SavedOrder order2 = SavedOrder(
        id: 0,
        orderId: 'ORD123',
        totalAmount: 20.0,
        itemCount: 2,
        orderDate: testDate,
      );

      await databaseService.insertOrder(order1);
      await databaseService.insertOrder(order2);

      final orders = await databaseService.getOrders();
      expect(orders.length, equals(2));
    });

    test('database persists data across multiple accesses', () async {
      final DateTime testDate = DateTime(2024, 11, 11);
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD123456',
        totalAmount: 15.99,
        itemCount: 3,
        orderDate: testDate,
      );

      await databaseService.insertOrder(order);

      // Access database multiple times
      final orders1 = await databaseService.getOrders();
      final orders2 = await databaseService.getOrders();
      final orders3 = await databaseService.getOrders();

      expect(orders1.length, equals(1));
      expect(orders2.length, equals(1));
      expect(orders3.length, equals(1));

      expect(orders1[0].orderId, equals('ORD123456'));
      expect(orders2[0].orderId, equals('ORD123456'));
      expect(orders3[0].orderId, equals('ORD123456'));
    });

    test('handles decimal values correctly in database', () async {
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD123',
        totalAmount: 12.345,
        itemCount: 1,
        orderDate: DateTime.now(),
      );

      await databaseService.insertOrder(order);
      final orders = await databaseService.getOrders();

      expect(orders[0].totalAmount, equals(12.345));
    });

    test('handles zero values correctly', () async {
      final SavedOrder order = SavedOrder(
        id: 0,
        orderId: 'ORD000',
        totalAmount: 0.0,
        itemCount: 0,
        orderDate: DateTime.now(),
      );

      await databaseService.insertOrder(order);
      final orders = await databaseService.getOrders();

      expect(orders[0].totalAmount, equals(0.0));
      expect(orders[0].itemCount, equals(0));
    });

    test('auto-increments id for new orders', () async {
      final DateTime testDate = DateTime(2024, 11, 11);

      final SavedOrder order1 = SavedOrder(
        id: 0,
        orderId: 'ORD001',
        totalAmount: 10.0,
        itemCount: 1,
        orderDate: testDate,
      );

      final SavedOrder order2 = SavedOrder(
        id: 0,
        orderId: 'ORD002',
        totalAmount: 20.0,
        itemCount: 2,
        orderDate: testDate,
      );

      await databaseService.insertOrder(order1);
      await databaseService.insertOrder(order2);

      final orders = await databaseService.getOrders();

      expect(orders[0].id, isNot(equals(orders[1].id)));
      expect(orders[0].id, greaterThan(0));
      expect(orders[1].id, greaterThan(0));
    });
  });
}
