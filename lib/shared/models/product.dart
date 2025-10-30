// Product model with enhanced features for the POS system
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String unit;
  final String barcode;
  int stock;
  final String categoryId;

  bool get inStock => stock > 0;

  Product({
    required this.id,
    required this.name,
    this.imageUrl = 'assets/images/product_placeholder.png',
    required this.price,
    this.unit = 'piece',
    required this.barcode,
    required this.stock,
    required this.categoryId,
  });

  // Copy with method for immutability in state management
  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? unit,
    String? barcode,
    int? stock,
    String? categoryId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl:
          json['imageUrl'] as String? ??
          'assets/images/product_placeholder.png',
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'piece',
      barcode: json['barcode'] as String,
      stock: json['stock'] as int,
      categoryId: json['categoryId'] as String,
    );
  }

  // Method to convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'unit': unit,
      'barcode': barcode,
      'stock': stock,
      'categoryId': categoryId,
    };
  }

  // Helpful toString for debugging and receipts
  @override
  String toString() => '$name ($unit) - ${price.toStringAsFixed(2)}';
}
