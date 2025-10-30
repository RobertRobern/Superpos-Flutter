import 'package:superpos/core/models/paged_result.dart';
import 'package:superpos/shared/models/product.dart';
import 'package:superpos/shared/models/category.dart';
import 'package:uuid/uuid.dart';

// Very small in-memory product repository for Phase 1.
class InMemoryProductRepository {
  final _uuid = const Uuid();

  // Sample product list. In a later phase this will be replaced by DB access.
  final List<Product> _products = [];

  InMemoryProductRepository() {
    // Create some demo products
    _products.addAll([
      // Dairy & Eggs
      Product(
        id: _uuid.v4(),
        name: 'Fresh Milk',
        price: 120.0,
        barcode: '111111',
        stock: 50,
        categoryId: Categories.dairyEggs.id,
        imageUrl: 'https://picsum.photos/seed/milk/200',
        unit: 'L',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Large Eggs',
        price: 180.0,
        barcode: '222222',
        stock: 100,
        categoryId: Categories.dairyEggs.id,
        imageUrl: 'https://picsum.photos/seed/eggs/200',
        unit: 'dozen',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Cheddar Cheese',
        price: 250.0,
        barcode: '333333',
        stock: 30,
        categoryId: Categories.dairyEggs.id,
        imageUrl: 'https://picsum.photos/seed/cheese/200',
        unit: 'kg',
      ),

      // Pantry Items
      Product(
        id: _uuid.v4(),
        name: 'Rice 5kg',
        price: 640.0,
        barcode: '444444',
        stock: 20,
        categoryId: Categories.pantry.id,
        imageUrl: 'https://picsum.photos/seed/rice/200',
        unit: 'kg',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Sugar 1kg',
        price: 110.0,
        barcode: '555555',
        stock: 40,
        categoryId: Categories.pantry.id,
        imageUrl: 'https://picsum.photos/seed/sugar/200',
        unit: 'kg',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Cooking Oil 2L',
        price: 450.0,
        barcode: '666666',
        stock: 25,
        categoryId: Categories.pantry.id,
        imageUrl: 'https://picsum.photos/seed/oil/200',
        unit: 'L',
      ),

      // Fresh Produce
      Product(
        id: _uuid.v4(),
        name: 'Tomatoes',
        price: 80.0,
        barcode: '777777',
        stock: 60,
        categoryId: Categories.freshProduce.id,
        imageUrl: 'https://picsum.photos/seed/tomatoes/200',
        unit: 'kg',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Potatoes',
        price: 120.0,
        barcode: '888888',
        stock: 45,
        categoryId: Categories.freshProduce.id,
        imageUrl: 'https://picsum.photos/seed/potatoes/200',
        unit: 'kg',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Bananas',
        price: 90.0,
        barcode: '999999',
        stock: 75,
        categoryId: Categories.freshProduce.id,
        imageUrl: 'https://picsum.photos/seed/bananas/200',
        unit: 'kg',
      ),

      // Bakery
      Product(
        id: _uuid.v4(),
        name: 'White Bread',
        price: 65.0,
        barcode: '101010',
        stock: 30,
        categoryId: Categories.bakery.id,
        imageUrl: 'https://picsum.photos/seed/bread/200',
        unit: 'loaf',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Chocolate Muffins',
        price: 150.0,
        barcode: '111112',
        stock: 24,
        categoryId: Categories.bakery.id,
        imageUrl: 'https://picsum.photos/seed/muffins/200',
        unit: 'pack',
      ),

      // Meat & Seafood
      Product(
        id: _uuid.v4(),
        name: 'Chicken Breast',
        price: 320.0,
        barcode: '121212',
        stock: 15,
        categoryId: Categories.meatSeafood.id,
        imageUrl: 'https://picsum.photos/seed/chicken/200',
        unit: 'kg',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Fresh Fish',
        price: 450.0,
        barcode: '131313',
        stock: 10,
        categoryId: Categories.meatSeafood.id,
        imageUrl: 'https://picsum.photos/seed/fish/200',
        unit: 'kg',
      ),

      // Beverages
      Product(
        id: _uuid.v4(),
        name: 'Orange Juice',
        price: 180.0,
        barcode: '141414',
        stock: 40,
        categoryId: Categories.beverages.id,
        imageUrl: 'https://picsum.photos/seed/juice/200',
        unit: 'L',
      ),
      Product(
        id: _uuid.v4(),
        name: 'Mineral Water',
        price: 45.0,
        barcode: '151515',
        stock: 100,
        categoryId: Categories.beverages.id,
        imageUrl: 'https://picsum.photos/seed/water/200',
        unit: 'L',
      ),
    ]);
  }

  // Return all products
  List<Product> getAll() => List.unmodifiable(_products);

  // Simple text search (by name or barcode)
  // Paginated search with optional category filter
  PagedResult<Product> searchPaginated(
    String query, {
    String? categoryId,
    int page = 1,
    int pageSize = 12,
  }) {
    final q = query.toLowerCase().trim();
    var filteredProducts = _products.where((p) {
      if (categoryId != null && p.categoryId != categoryId) {
        return false;
      }
      return q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.barcode.contains(q);
    }).toList();

    final totalItems = filteredProducts.length;
    final totalPages = (totalItems / pageSize).ceil();
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    filteredProducts = filteredProducts.sublist(
      startIndex,
      endIndex > totalItems ? totalItems : endIndex,
    );

    return PagedResult(
      items: filteredProducts,
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }

  // Simple text search (by name or barcode) - kept for backwards compatibility
  List<Product> search(String query) {
    return searchPaginated(query).items;
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
