import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superpos/core/config/navigation_config.dart';
import 'package:superpos/core/widgets/app_navigation_drawer.dart';
import 'package:superpos/features/pos/data/in_memory_product_repository.dart';
import 'package:superpos/features/pos/presentation/widgets/product_grid.dart';
import 'package:superpos/features/pos/presentation/providers/cart_provider.dart';
import 'package:superpos/features/pos/presentation/pages/cart_page.dart';
import 'package:superpos/shared/models/product.dart';
import 'package:superpos/shared/models/category.dart';

/// POS Home page: product catalog with search and quick add to cart.
class PosHomePage extends StatefulWidget {
  const PosHomePage({Key? key}) : super(key: key);

  @override
  State<PosHomePage> createState() => _PosHomePageState();
}

class _PosHomePageState extends State<PosHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  String? _selectedCategory;
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasNextPage = false;
  static const _pageSize = 12;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearch);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    _currentPage = 1;
    _products.clear();
    _loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasNextPage) {
      _loadProducts(isLoadMore: true);
    }
  }

  Future<void> _loadProducts({bool isLoadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repo = context.read<InMemoryProductRepository>();
      final result = repo.searchPaginated(
        _searchController.text,
        categoryId: _selectedCategory,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        if (isLoadMore) {
          _products.addAll(result.items);
        } else {
          _products = result.items;
        }
        _hasNextPage = result.hasNextPage;
        if (_hasNextPage) {
          _currentPage++;
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      // Only show drawer in mobile/tablet mode
      drawer: isLargeScreen
          ? null
          : AppNavigationDrawer(
              items: NavigationConfig.items,
              currentRoute: '/pos',
              isPinned: false,
            ),
      // Configure AppBar based on screen size
      appBar: isLargeScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              toolbarHeight: 64,
              leadingWidth: 65,
              leading: Builder(
                builder: (context) => Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                      size: 28,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(left: isLargeScreen ? 20 : 0),
                child: const Row(
                  children: [
                    Text(
                      'SuperPOS',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      ' AI',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                      onPressed: () {
                        // TODO: Show notifications in Phase 7
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '3', // TODO: Connect to actual notifications count
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    final showUserInfo =
                        MediaQuery.of(context).size.width > 640;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          if (showUserInfo) ...[
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'admin@superpos.com',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLargeScreen)
            AppNavigationDrawer(
              items: NavigationConfig.items,
              currentRoute: '/pos',
              isPinned: true,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLargeScreen)
                  Container(
                    height: 64,
                    color: Colors.white,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 24),
                          child: Row(
                            children: [
                              Text(
                                'SuperPOS',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                ' AI',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black87,
                                size: 24,
                              ),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const CartPage(),
                                  ),
                                );
                              },
                            ),
                            if (cart.totalItems > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${cart.totalItems}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.black87,
                                size: 24,
                              ),
                              onPressed: () {
                                // TODO: Show notifications in Phase 7
                              },
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Text(
                                  '3', // TODO: Connect to actual notifications count
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            final showUserInfo =
                                MediaQuery.of(context).size.width > 640;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (showUserInfo) ...[
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Admin User',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'admin@superpos.com',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    left: isLargeScreen ? 24.0 : 8.0,
                    right: isLargeScreen ? 24.0 : 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search products by name or barcode...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24.0 : 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = null;
                            _currentPage = 1;
                            _products.clear();
                            _loadProducts();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...Categories.allCategories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: _selectedCategory == category.id,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected
                                    ? category.id
                                    : null;
                                _currentPage = 1;
                                _products.clear();
                                _loadProducts();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isLargeScreen ? 24.0 : 8.0,
                        ),
                        child: ProductGrid(
                          products: _products,
                          scrollController: _scrollController,
                          onAddToCart: (product) {
                            cart.add(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                        ),
                      ),
                      if (_isLoading && _products.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: Colors.black12,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      if (_isLoading && _products.isEmpty)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
