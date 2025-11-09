import 'package:flutter/material.dart';
import 'views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  int _quantity = 0;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  bool _isToasted = false;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_quantity < widget.maxQuantity) {
      return () {
        setState(() => _quantity++);
      };
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return () {
        setState(() => _quantity--);
      };
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  void _addToCart() {
    if (_quantity > 0) {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      _cart.addToCart(
        sandwich: sandwich,
        quantity: _quantity,
        note: _notesController.text.isEmpty ? null : _notesController.text,
      );

      debugPrint(
          'Added $_quantity ${_isFootlong ? "footlong" : "six-inch"} sandwich(es) to cart');

      setState(() {
        _quantity = 0;
        _notesController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Added $_quantity ${_isFootlong ? "footlong" : "six-inch"} sandwich(es) to cart'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getCurrentImagePath() {
    final sandwich = Sandwich(
      type: SandwichType.veggieDelight,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    double totalPrice = _cart.totalPrice;

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // TODO: Show cart details
                },
              ),
              if (_cart.totalItems > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cart.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                _getCurrentImagePath(),
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 80),
              ),
              const SizedBox(height: 16),
              OrderItemDisplay(
                quantity: _quantity,
                itemType: sandwichType,
                breadType: _selectedBreadType,
                orderNote: noteForDisplay,
              ),
              const SizedBox(height: 8),
              Text(
                'Total Price: £${totalPrice.toStringAsFixed(2)}',
                style: normalText,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: _onSandwichTypeChanged,
                  ),
                  const Text('footlong', style: normalText),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('untoasted', style: normalText),
                  Switch(
                    value: _isToasted,
                    onChanged: (value) {
                      setState(() => _isToasted = value);
                    },
                  ),
                  const Text('toasted', style: normalText),
                ],
              ),
              const SizedBox(height: 10),
              DropdownMenu<BreadType>(
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeSelected,
                dropdownMenuEntries: _buildDropdownEntries(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextField(
                  key: const Key('notes_textfield'),
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Add a note (e.g., no onions)',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _quantity > 0 ? () => _addToCart() : null,
                    icon: Icons.add_shopping_cart,
                    label: 'Add to Cart',
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      StyledButton(
                        onPressed: _getDecreaseCallback(),
                        icon: Icons.remove,
                        label: 'Remove',
                        backgroundColor: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_quantity',
                        style: normalText,
                      ),
                      const SizedBox(width: 8),
                      StyledButton(
                        onPressed: _getIncreaseCallback(),
                        icon: Icons.add,
                        label: 'Add',
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): ${'🥪' * quantity}';

    return Column(
      children: [
        Text(
          displayText,
          style: normalText,
        ),
        const SizedBox(height: 8),
        Text(
          'Note: $orderNote',
          style: normalText,
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Welcome to my shop!')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
