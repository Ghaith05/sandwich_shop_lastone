import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A reusable modal widget for editing a cart item. This is a self-contained
/// widget that exposes `onSave` and `onCancel` callbacks. It is not yet wired
/// into `CartScreen`; we'll integrate it in a later subtask.
class CartEditModal extends StatefulWidget {
  final Sandwich sandwich;
  final int quantity;
  final void Function(Sandwich updated, int quantity) onSave;
  final VoidCallback onCancel;

  const CartEditModal({
    Key? key,
    required this.sandwich,
    required this.quantity,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<CartEditModal> createState() => _CartEditModalState();
}

class _CartEditModalState extends State<CartEditModal> {
  late bool isFootlong;
  late BreadType breadType;
  late int qty;

  @override
  void initState() {
    super.initState();
    isFootlong = widget.sandwich.isFootlong;
    breadType = widget.sandwich.breadType;
    qty = widget.quantity;
  }

  double get _previewPrice {
    final pr = PricingRepository();
    return pr.calculatePrice(quantity: qty, isFootlong: isFootlong);
  }

  void _inc() => setState(() => qty++);
  void _dec() {
    setState(() {
      if (qty > 0) qty--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Edit ${widget.sandwich.name}', style: heading2),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Text('Six-inch', style: normalText)),
              Switch(
                value: isFootlong,
                onChanged: (v) => setState(() => isFootlong = v),
              ),
              const Expanded(child: Text('Footlong', style: normalText)),
            ],
          ),
          const SizedBox(height: 8),
          DropdownMenu<BreadType>(
            initialSelection: breadType,
            textStyle: normalText,
            onSelected: (BreadType? b) {
              if (b != null) setState(() => breadType = b);
            },
            dropdownMenuEntries: BreadType.values
                .map((bt) =>
                    DropdownMenuEntry<BreadType>(value: bt, label: bt.name))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: _dec, icon: const Icon(Icons.remove)),
              Text('$qty', style: heading2),
              IconButton(onPressed: _inc, icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Qty: $qty - £${_previewPrice.toStringAsFixed(2)}',
              style: normalText, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final updated = Sandwich(
                type: widget.sandwich.type,
                isFootlong: isFootlong,
                breadType: breadType,
              );
              widget.onSave(updated, qty);
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: widget.onCancel, child: const Text('Cancel')),
        ],
      ),
    );
  }
}
