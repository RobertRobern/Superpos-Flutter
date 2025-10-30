import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superpos/features/pos/presentation/providers/cart_provider.dart';
import 'package:superpos/shared/models/customer.dart';
import 'package:superpos/shared/models/sale.dart';

class CartSection extends StatelessWidget {
  const CartSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.primaryColor.withOpacity(0.1),
            child: const Text(
              'Current Sale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Customer Selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => _selectCustomer(context),
              icon: const Icon(Icons.person_outline),
              label: Text(cart.selectedCustomer?.name ?? 'Select Customer'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),

          // Cart Items
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                          'KSh ${item.product.price} / ${item.product.unit}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: item.quantity > 1
                                  ? () => cart.updateQuantity(
                                      item.product.id,
                                      item.quantity - 1,
                                    )
                                  : null,
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => cart.updateQuantity(
                                item.product.id,
                                item.quantity + 1,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => cart.remove(item.product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          if (cart.items.isNotEmpty) ...[
            // AI Smart Offer
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Smart Offer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Add more items to unlock special offers!',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price Summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('KSh ${cart.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (cart.discount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount'),
                        Text(
                          '- KSh ${cart.discount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax (16%)'),
                      Text('KSh ${cart.tax.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'KSh ${cart.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => _showDiscountDialog(context),
                    child: const Text('Apply Discount'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: cart.status == SaleStatus.held
                              ? () => cart.resumeSale()
                              : () => cart.holdSale(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                          ),
                          child: Text(
                            cart.status == SaleStatus.held ? 'Resume' : 'Hold',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement checkout flow
                            final sale = cart.checkout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sale completed: ${sale.total.toStringAsFixed(2)}',
                                ),
                              ),
                            );
                          },
                          child: const Text('PAY'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => cart.clear(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _selectCustomer(BuildContext context) {
    // TODO: Implement customer selection in Phase 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Walk-in Customer'),
              onTap: () {
                context.read<CartProvider>().selectCustomer(null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Regular Customer'),
              subtitle: const Text('5% discount'),
              onTap: () {
                context.read<CartProvider>().selectCustomer(
                  const Customer(
                    id: 'demo',
                    name: 'John Doe',
                    type: CustomerType.loyal,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDiscountDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Discount'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Discount Amount (KSh)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              context.read<CartProvider>().applyDiscount(amount);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
