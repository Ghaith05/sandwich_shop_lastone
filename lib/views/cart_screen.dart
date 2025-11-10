import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  void _showEditItemSheet(Sandwich sandwich) {
    bool isFootlong = sandwich.isFootlong;
    BreadType bread = sandwich.breadType;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Edit ${sandwich.name}', style: heading2),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Six-inch', style: normalText),
                    Switch(
                      value: isFootlong,
                      onChanged: (v) => setModalState(() => isFootlong = v),
                    ),
                    const Text('Footlong', style: normalText),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownMenu<BreadType>(
                  textStyle: normalText,
                  initialSelection: bread,
                  onSelected: (BreadType? b) {
                    if (b != null) setModalState(() => bread = b);
                  },
                  dropdownMenuEntries: BreadType.values
                      .map((bt) => DropdownMenuEntry<BreadType>(
                          value: bt, label: bt.name))
                      .toList(),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final Sandwich updated = Sandwich(
                      type: sandwich.type,
                      isFootlong: isFootlong,
                      breadType: bread,
                    );
                    setState(() {
                      widget.cart.replaceItem(sandwich, updated);
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${sandwich.name} updated')),
                    );
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Thumbnail
                        SizedBox(
                          height: 56,
                          width: 56,
                          child: Image.asset(entry.key.image,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.image_not_supported)),
                        ),
                        const SizedBox(width: 12),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key.name, style: heading2),
                              Text(
                                  '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                                  style: normalText),
                              const SizedBox(height: 6),
                              Text(
                                  'Qty: ${entry.value} - £${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                                  style: normalText),
                            ],
                          ),
                        ),
                        // Actions
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => _showEditItemSheet(entry.key),
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit item',
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.cart
                                      .remove(entry.key, quantity: 99999);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('${entry.key.name} removed')),
                                );
                              },
                              icon: const Icon(Icons.delete),
                              tooltip: 'Remove item',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                style: heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
