import 'package:superpos/shared/models/product.dart';
import 'package:uuid/uuid.dart';

// Very small in-memory product repository for Phase 1.
class InMemoryProductRepository {
  final _uuid = const Uuid();

  // Sample product list. In a later phase this will be replaced by DB access.
  final List<Product> _products = [];

  InMemoryProductRepository() {
    // Create some demo products
    _products.addAll([
      Product(
        id: _uuid.v4(),
        name: 'Maize Flour 2kg',
        price: 120.0,
        barcode: '111111',
        stock: 50,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Cooking Oil 1L',
        price: 250.0,
        barcode: '222222',
        stock: 30,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Rice 5kg',
        price: 640.0,
        barcode: '333333',
        stock: 20,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Sugar 1kg',
        price: 110.0,
        barcode: '444444',
        stock: 40,
      ),
    ]);
  }

  // Return all products
  List<Product> getAll() => List.unmodifiable(_products);

  // Simple text search (by name or barcode)
  List<Product> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAll();
    return _products
        .where((p) => p.name.toLowerCase().contains(q) || p.barcode.contains(q))
        .toList();
  }

  Product? findById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Decrease stock when an item is sold (simple, no concurrency handling)
  void decreaseStock(String id, int qty) {
    if (qty <= 0) return; // or throw ArgumentError('qty must be positive');
    final p = findById(id);
    if (p != null) {
      final newStock = (p.stock - qty).clamp(0, 1 << 30).toInt();
      p.stock = newStock;
    }
  }
}
