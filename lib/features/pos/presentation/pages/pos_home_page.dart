import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superpos/core/config/navigation_config.dart';
import 'package:superpos/core/widgets/app_navigation_drawer.dart';
import 'package:superpos/features/pos/data/in_memory_product_repository.dart';
import 'package:superpos/features/pos/presentation/widgets/product_tile.dart';
import 'package:superpos/features/pos/presentation/providers/cart_provider.dart';
import 'package:superpos/features/pos/presentation/pages/cart_page.dart';
import 'package:superpos/shared/models/product.dart';

/// POS Home page: product catalog with search and quick add to cart.
class PosHomePage extends StatefulWidget {
  const PosHomePage({Key? key}) : super(key: key);

  @override
  State<PosHomePage> createState() => _PosHomePageState();
}

class _PosHomePageState extends State<PosHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    final repo = context.read<InMemoryProductRepository>();
    _products = repo.getAll();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final repo = context.read<InMemoryProductRepository>();
    setState(() => _products = repo.search(_searchController.text));
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
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartPage()),
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
                IconButton(
                  icon: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    // TODO: Show user profile in Phase 4
                  },
                ),
                const SizedBox(width: 8),
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
                        IconButton(
                          icon: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // TODO: Show user profile in Phase 4
                          },
                        ),
                        const SizedBox(width: 8),
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search products by name or barcode',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isLargeScreen ? 24.0 : 8.0,
                      right: isLargeScreen ? 24.0 : 8.0,
                    ),
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, i) {
                        final p = _products[i];
                        return ProductTile(
                          product: p,
                          onAdd: (product) {
                            cart.add(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                        );
                      },
                    ),
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
