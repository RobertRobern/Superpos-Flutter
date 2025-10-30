import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superpos/features/pos/data/in_memory_product_repository.dart';
import 'package:superpos/features/pos/presentation/providers/cart_provider.dart';
import 'package:superpos/features/pos/presentation/pages/pos_home_page.dart';

void main() {
  // Create simple in-memory repositories (Phase 1). These can later be
  // replaced by database-backed implementations without touching presentation.
  final productRepository = InMemoryProductRepository();

  // Provide repositories and providers to the app using Provider package.
  runApp(
    MultiProvider(
      providers: [
        Provider<InMemoryProductRepository>.value(value: productRepository),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rovent SuperPOS - Phase 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Home is the POS feature entry point.
      home: const PosHomePage(),
    );
  }
}
