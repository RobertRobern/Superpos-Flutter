import 'package:flutter/material.dart';
import 'package:superpos/shared/models/product.dart';

typedef AddCallback = void Function(Product p);

// Small reusable product tile used in product lists.
class ProductTile extends StatelessWidget {
  final Product product;
  final AddCallback onAdd;

  const ProductTile({Key? key, required this.product, required this.onAdd})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Placeholder for image/thumbnail
            Container(width: 56, height: 56, color: Colors.grey.shade200),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('KSh ${product.price.toStringAsFixed(2)}'),
                  Text('Stock: ${product.stock}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: product.stock > 0 ? () => onAdd(product) : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
