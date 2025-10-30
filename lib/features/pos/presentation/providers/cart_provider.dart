import 'package:flutter/foundation.dart';
import 'package:superpos/shared/models/cart_item.dart';
import 'package:superpos/shared/models/product.dart';
import 'package:superpos/shared/models/customer.dart';
import 'package:superpos/shared/models/sale.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  // key: product id
  final Map<String, CartItem> _items = {};
  Customer? _selectedCustomer;
  double? _manualDiscount;
  String? _discountCode;
  SaleStatus _status = SaleStatus.inProgress;

  static const double taxRate = 0.16; // 16% VAT

  List<CartItem> get items => _items.values.toList(growable: false);
  Customer? get selectedCustomer => _selectedCustomer;
  SaleStatus get status => _status;

  int get totalItems => _items.values.fold(0, (s, i) => s + i.quantity);

  double get subtotal => _items.values.fold(0.0, (s, i) => s + i.subtotal);

  double get discount {
    double totalDiscount = _manualDiscount ?? 0;
    if (_selectedCustomer != null) {
      totalDiscount +=
          subtotal * _selectedCustomer!.type.discountPercentage / 100;
    }
    return totalDiscount;
  }

  double get tax => (subtotal - discount) * taxRate;

  double get total => subtotal - discount + tax;

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
    _selectedCustomer = null;
    _manualDiscount = null;
    _discountCode = null;
    _status = SaleStatus.inProgress;
    notifyListeners();
  }

  void selectCustomer(Customer? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void applyDiscount(double amount) {
    _manualDiscount = amount;
    notifyListeners();
  }

  void applyDiscountCode(String code) {
    _discountCode = code;
    // TODO: Implement discount code logic in Phase 2
    notifyListeners();
  }

  void holdSale() {
    if (_status == SaleStatus.inProgress) {
      _status = SaleStatus.held;
      notifyListeners();
    }
  }

  void resumeSale() {
    if (_status == SaleStatus.held) {
      _status = SaleStatus.inProgress;
      notifyListeners();
    }
  }

  // Completes the sale and returns a Sale object
  Sale checkout() {
    final sale = Sale(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      items: items,
      customer: _selectedCustomer,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      discountCode: _discountCode,
      status: SaleStatus.completed,
    );

    // Clear cart after successful checkout
    clear();

    return sale;
  }
}
