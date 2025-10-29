import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Row(
          children: [
            Text(
              'SuperPOS',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' AI',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
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
                  await Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CartPage()));
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
                      style: const TextStyle(color: Colors.white, fontSize: 10),
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Admin User',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.point_of_sale),
              title: const Text('POS'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to inventory in Phase 2
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to analytics in Phase 3
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customers'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to customers in Phase 4
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add settings page
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search products by name or barcode',
              ),
            ),
          ),
          Expanded(
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
        ],
      ),
      // Removed floating action button since we have cart in AppBar
    );
  }
}
