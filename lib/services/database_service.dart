import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'sandwich_shop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            totalAmount REAL NOT NULL,
            itemCount INTEGER NOT NULL,
            orderDate INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(SavedOrder order) async {
    final Database db = await database;
    await db.insert('orders', order.toMap());
  }

  Future<List<SavedOrder>> getOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'orders',
      orderBy: 'orderDate DESC',
    );

    List<SavedOrder> orders = [];
    for (int i = 0; i < maps.length; i++) {
      orders.add(SavedOrder.fromMap(maps[i]));
    }
    return orders;
  }

  Future<void> deleteOrder(int id) async {
    final Database db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // For testing purposes - resets the database instance
  static Future<void> resetDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
