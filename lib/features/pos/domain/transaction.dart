import 'package:superpos/shared/models/cart_item.dart';

// Simple Transaction record for Phase 1. Keeps items, total and timestamp.
class PosTransaction {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime timestamp;

  PosTransaction({
    required this.id,
    required this.items,
    required this.total,
    required this.timestamp,
  });
}
