import 'package:flutter/material.dart';
import 'package:superpos/features/pos/presentation/widgets/product_grid_item.dart';
import 'package:superpos/shared/models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart;
  final ScrollController? scrollController;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onAddToCart,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.75 : 0.70,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductGridItem(product: products[index], onAdd: onAddToCart),
    );
  }
}
