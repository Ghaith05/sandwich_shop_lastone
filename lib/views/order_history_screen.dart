import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<SavedOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final List<SavedOrder> orders = await _databaseService.getOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    String output = '${date.day}/${date.month}/${date.year}';
    output += ' ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    return output;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          title: Text('Order History', style: AppStyles.heading1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          title: Text('Order History', style: AppStyles.heading1),
        ),
        body: Center(
          child: Text('No orders yet', style: AppStyles.heading2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: Text('Order History', style: AppStyles.heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final SavedOrder order = _orders[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.orderId, style: AppStyles.heading2),
                          Text('£${order.totalAmount.toStringAsFixed(2)}',
                              style: AppStyles.heading2),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order.itemCount} items',
                              style: AppStyles.normalText),
                          Text(_formatDate(order.orderDate),
                              style: AppStyles.normalText),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}