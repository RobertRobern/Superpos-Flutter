import 'package:flutter/foundation.dart';
import 'package:superpos/shared/models/cart_item.dart';
import 'package:superpos/shared/models/product.dart';
import 'package:superpos/features/pos/data/in_memory_transaction_repository.dart';

// CartProvider manages cart state for Phase 1. Uses ChangeNotifier so UI can react.
class CartProvider extends ChangeNotifier {
  final InMemoryTransactionRepository _transactionRepository;

  // key: product id
  final Map<String, CartItem> _items = {};

  CartProvider(this._transactionRepository);

  List<CartItem> get items => _items.values.toList(growable: false);

  int get totalItems => _items.values.fold(0, (s, i) => s + i.quantity);

  double get total => _items.values.fold(0.0, (s, i) => s + i.subtotal);

  void add(Product p, {int qty = 1}) {
    final existing = _items[p.id];
    if (existing != null) {
      existing.quantity += qty;
    } else {
      _items[p.id] = CartItem(product: p, quantity: qty);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int qty) {
    final it = _items[productId];
    if (it != null) {
      if (qty <= 0) {
        _items.remove(productId);
      } else {
        it.quantity = qty;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Checkout: record transaction via repository and clear cart. Returns the recorded transaction id.
  String checkout() {
    final tx = _transactionRepository.recordTransaction(items, total);
    clear();
    return tx.id;
  }
}
