import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/db_provider.dart';
import '../../../data/db/app_database.dart';
import '../../../core/enums/transaction_status.dart';
import '../domain/transaction_history_model.dart';

/// Provider for fetching all transactions for a specific date range
final transactionsHistoryProvider = FutureProvider.autoDispose.family<
    TransactionsSummary, TransactionDateRange>(
  (ref, range) async {
    final db = ref.watch(dbProvider);

    // Fetch all transactions
    final transactionsData = await db.getAllTransactions(
      range.start,
      range.end,
    );

    // Convert to UnifiedTransaction objects
    final transactions = transactionsData.map((data) {
      return UnifiedTransaction(
        id: data['id'] as String,
        createdAt: data['createdAt'] as DateTime,
        type: _parseTransactionType(data['type'] as String),
        amountCents: data['amountCents'] as int,
        profitCents: data['profitCents'] as int,
        customerName: data['customerName'] as String?,
        description: data['description'] as String?,
        status: TransactionStatusExtension.fromDbString(data['status'] as String? ?? 'normal'),
        reversedAt: data['reversedAt'] as DateTime?,
      );
    }).toList();

    // Create summary
    return TransactionsSummary.fromTransactions(
      range.start,
      transactions,
    );
  },
);

/// Provider for detailed profit breakdown
final detailedProfitProvider = FutureProvider.autoDispose.family<
    DetailedProfitBreakdown, TransactionDateRange>(
  (ref, range) async {
    final db = ref.watch(dbProvider);
    return db.getDetailedProfitBreakdown(range.start, range.end);
  },
);

/// Helper to parse transaction type from string
TransactionType _parseTransactionType(String type) {
  switch (type) {
    case 'sale':
      return TransactionType.sale;
    case 'repair':
      return TransactionType.repair;
    case 'telelink':
      return TransactionType.telelink;
    case 'electricity':
      return TransactionType.electricity;
    case 'programTopup':
      return TransactionType.programTopup;
    case 'service':
      return TransactionType.service;
    case 'farahnet':
      return TransactionType.farahnet;
    case 'wallet':
      return TransactionType.wallet;
    case 'purchase':
      return TransactionType.purchase;
    default:
      return TransactionType.service;
  }
}

/// Model for date time range
class TransactionDateRange {
  final DateTime start;
  final DateTime end;

  TransactionDateRange({required this.start, required this.end});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDateRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
