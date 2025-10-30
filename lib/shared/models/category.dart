class Category {
  final String id;
  final String name;
  final String? icon;

  const Category({required this.id, required this.name, this.icon});
}

// Predefined categories
class Categories {
  static const all = Category(id: 'all', name: 'All');
  static const freshProduce = Category(
    id: 'fresh-produce',
    name: 'Fresh Produce',
  );
  static const bakery = Category(id: 'bakery', name: 'Bakery');
  static const dairyEggs = Category(id: 'dairy-eggs', name: 'Dairy & Eggs');
  static const meatSeafood = Category(
    id: 'meat-seafood',
    name: 'Meat & Seafood',
  );
  static const pantry = Category(id: 'pantry', name: 'Pantry');
  static const beverages = Category(id: 'beverages', name: 'Beverages');

  static const List<Category> allCategories = [
    freshProduce,
    bakery,
    dairyEggs,
    meatSeafood,
    pantry,
    beverages,
  ];
}
