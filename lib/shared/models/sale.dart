import 'package:superpos/shared/models/cart_item.dart';
import 'package:superpos/shared/models/customer.dart';

class Sale {
  final String id;
  final DateTime timestamp;
  final List<CartItem> items;
  final Customer? customer;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String? discountCode;
  final SaleStatus status;

  const Sale({
    required this.id,
    required this.timestamp,
    required this.items,
    this.customer,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    this.discountCode,
    this.status = SaleStatus.completed,
  });

  Sale copyWith({
    String? id,
    DateTime? timestamp,
    List<CartItem>? items,
    Customer? customer,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    String? discountCode,
    SaleStatus? status,
  }) {
    return Sale(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      items: items ?? this.items,
      customer: customer ?? this.customer,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      discountCode: discountCode ?? this.discountCode,
      status: status ?? this.status,
    );
  }
}

enum SaleStatus { inProgress, held, completed, cancelled }
