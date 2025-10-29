import 'package:superpos/shared/models/product.dart';

// Represents an item in the shopping cart.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}
