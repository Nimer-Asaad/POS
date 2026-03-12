import 'package:flutter/material.dart';
import '../../../core/enums/transaction_status.dart';

/// Unified transaction model representing all system activities
class UnifiedTransaction {
  final String id;
  final DateTime createdAt;
  final TransactionType type;
  final int amountCents; // Total amount in cents/fils
  final int profitCents; // Profit in cents/fils
  final String? customerName;
  final String? description;
  final Map<String, dynamic>? metadata;
  final TransactionStatus status; // normal or reversed
  final DateTime? reversedAt; // When transaction was reversed

  UnifiedTransaction({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.amountCents,
    required this.profitCents,
    this.customerName,
    this.description,
    this.metadata,
    this.status = TransactionStatus.normal,
    this.reversedAt,
  });

  /// Check if transaction is reversed
  bool get isReversed => status == TransactionStatus.reversed;

  /// Get icon for transaction type
  IconData get icon {
    switch (type) {
      case TransactionType.sale:
        return Icons.shopping_cart;
      case TransactionType.repair:
        return Icons.build;
      case TransactionType.telelink:
        return Icons.phone_android;
      case TransactionType.electricity:
        return Icons.flash_on;
      case TransactionType.programTopup:
        return Icons.add_card;
      case TransactionType.service:
        return Icons.apps;
      case TransactionType.farahnet:
        return Icons.wifi;
      case TransactionType.wallet:
        return Icons.account_balance_wallet;
      case TransactionType.purchase:
        return Icons.shopping_bag;
    }
  }

  /// Get color for transaction type
  Color get color {
    switch (type) {
      case TransactionType.sale:
        return Colors.green;
      case TransactionType.repair:
        return Colors.orange;
      case TransactionType.telelink:
        return Colors.blue;
      case TransactionType.electricity:
        return Colors.amber;
      case TransactionType.programTopup:
        return Colors.purple;
      case TransactionType.service:
        return Colors.teal;
      case TransactionType.farahnet:
        return Colors.indigo;
      case TransactionType.wallet:
        return Colors.pink;
      case TransactionType.purchase:
        return Colors.red;
    }
  }

  /// Get Arabic label
  String get labelAr {
    switch (type) {
      case TransactionType.sale:
        return 'مبيعة';
      case TransactionType.repair:
        return 'صيانة';
      case TransactionType.telelink:
        return 'تيلي لينك';
      case TransactionType.electricity:
        return 'كهرباء';
      case TransactionType.programTopup:
        return 'شحن برنامج';
      case TransactionType.service:
        return 'خدمة';
      case TransactionType.farahnet:
        return 'فرح نت';
      case TransactionType.wallet:
        return 'محفظة';
      case TransactionType.purchase:
        return 'مشتريات';
    }
  }

  /// Get English label
  String get labelEn {
    switch (type) {
      case TransactionType.sale:
        return 'Sale';
      case TransactionType.repair:
        return 'Repair';
      case TransactionType.telelink:
        return 'TeleLink';
      case TransactionType.electricity:
        return 'Electricity';
      case TransactionType.programTopup:
        return 'Program Topup';
      case TransactionType.service:
        return 'Service';
      case TransactionType.farahnet:
        return 'Farahnet';
      case TransactionType.wallet:
        return 'Wallet';
      case TransactionType.purchase:
        return 'Purchase';
    }
  }
}

enum TransactionType {
  sale,
  repair,
  telelink,
  electricity,
  programTopup,
  service,
  farahnet,
  wallet,
  purchase,
}

/// Summary of all transactions for a specific date
class TransactionsSummary {
  final DateTime date;
  final List<UnifiedTransaction> transactions;
  final int totalRevenueCents;
  final int totalProfitCents;
  final Map<TransactionType, int> countByType;

  TransactionsSummary({
    required this.date,
    required this.transactions,
    required this.totalRevenueCents,
    required this.totalProfitCents,
    required this.countByType,
  });

  factory TransactionsSummary.fromTransactions(
    DateTime date,
    List<UnifiedTransaction> transactions,
  ) {
    var totalRevenue = 0;
    var totalProfit = 0;
    final countByType = <TransactionType, int>{};

    // Only include normal (non-reversed) transactions in calculations
    for (final tx in transactions) {
      if (tx.status == TransactionStatus.normal) {
        totalRevenue += tx.amountCents;
        totalProfit += tx.profitCents;
        countByType[tx.type] = (countByType[tx.type] ?? 0) + 1;
      }
    }

    return TransactionsSummary(
      date: date,
      transactions: transactions,
      totalRevenueCents: totalRevenue,
      totalProfitCents: totalProfit,
      countByType: countByType,
    );
  }
}
