import 'package:superpos/features/pos/domain/transaction.dart';
import 'package:uuid/uuid.dart';

// Simple in-memory transaction repository. Persists during app lifetime.
class InMemoryTransactionRepository {
  final _uuid = const Uuid();
  final List<PosTransaction> _transactions = [];

  // Record a transaction and return it
  PosTransaction recordTransaction(List items, double total) {
    final tx = PosTransaction(
      id: _uuid.v4(),
      items: List.from(items),
      total: total,
      timestamp: DateTime.now(),
    );
    _transactions.add(tx);
    return tx;
  }

  List<PosTransaction> getAll() => List.unmodifiable(_transactions);
}
