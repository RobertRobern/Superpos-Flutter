// Simple Product model used across features. Keep it small for Phase 1.
class Product {
  final String id;
  final String name;
  final double price;
  final String barcode;
  int stock; // mutable for Phase 2 inventory features

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.barcode,
    required this.stock,
  });

  // Helpful toString for debugging and receipts
  @override
  String toString() => '$name (x$stock) - ${price.toStringAsFixed(2)}';
}
