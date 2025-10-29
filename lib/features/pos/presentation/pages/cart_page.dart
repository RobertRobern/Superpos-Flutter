import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:superpos/features/pos/presentation/providers/cart_provider.dart';
import 'package:superpos/features/pos/data/in_memory_product_repository.dart';

/// Cart page shows cart items, allows quantity changes and checkout which
/// records a transaction and displays a simple receipt dialog.
class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final repo = context.read<InMemoryProductRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final it = cart.items[i];
                return ListTile(
                  title: Text(it.product.name),
                  subtitle: Text(
                    'KSh ${it.product.price.toStringAsFixed(2)} x ${it.quantity} = KSh ${it.subtotal.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            cart.updateQuantity(it.product.id, it.quantity - 1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('${it.quantity}'),
                      IconButton(
                        onPressed: () =>
                            cart.updateQuantity(it.product.id, it.quantity + 1),
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () => cart.remove(it.product.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: KSh ${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          // Snapshot items and total before checkout because checkout clears the cart
                          final soldItems = cart.items.map((it) => it).toList();
                          final totalBefore = soldItems.fold<double>(
                            0.0,
                            (s, it) => s + it.subtotal,
                          );

                          // Decrease stock on sold items (demo behaviour)
                          for (final it in soldItems) {
                            repo.decreaseStock(it.product.id, it.quantity);
                          }

                          final txId = cart.checkout();

                          // Show receipt dialog using the snapshot
                          final now = DateTime.now();
                          final df = DateFormat('yyyy-MM-dd HH:mm');
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Receipt'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transaction: $txId'),
                                    Text('Date: ${df.format(now)}'),
                                    const SizedBox(height: 8),
                                    ...soldItems.map(
                                      (it) => Text(
                                        '${it.product.name} x${it.quantity} - KSh ${it.subtotal.toStringAsFixed(2)}',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'TOTAL: KSh ${totalBefore.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                  child: const Text('Checkout & Print Receipt (demo)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
