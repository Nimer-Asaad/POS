import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';

final salesDateFilterProvider = StateProvider<DateTime?>((ref) => null);
final purchaseInvoicesDateFilterProvider = StateProvider<DateTime?>(
  (ref) => null,
);

/// Provider for all sales invoices
final salesInvoicesProvider =
    FutureProvider.autoDispose<List<SaleWithCustomer>>((ref) async {
      final db = ref.watch(dbProvider);
      final selectedDate = ref.watch(salesDateFilterProvider);
      var invoices = await db.getAllSalesWithCustomer(limit: 100);

      if (selectedDate != null) {
        final start = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        final end = start.add(const Duration(days: 1));
        invoices = invoices
            .where(
              (item) =>
                  !item.sale.createdAt.isBefore(start) &&
                  item.sale.createdAt.isBefore(end),
            )
            .toList();
      }

      return invoices;
    });

/// Provider for sales summary
final salesSummaryProvider = FutureProvider.autoDispose<SalesSummaryBasic>((
  ref,
) async {
  final db = ref.watch(dbProvider);
  return db.getSalesSummaryBasic();
});

/// Provider for sale details with items
final saleDetailsProvider = FutureProvider.autoDispose
    .family<SaleWithItems?, String>((ref, saleId) async {
      final db = ref.watch(dbProvider);
      return db.getSaleWithItems(saleId);
    });

/// Provider for purchase invoices
final purchaseInvoicesProvider =
    FutureProvider.autoDispose<List<PurchaseInvoice>>((ref) async {
      final db = ref.watch(dbProvider);
      final selectedDate = ref.watch(purchaseInvoicesDateFilterProvider);
      var invoices = await db.getAllPurchaseInvoices(limit: 100);

      if (selectedDate != null) {
        final start = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        final end = start.add(const Duration(days: 1));
        invoices = invoices
            .where(
              (item) =>
                  !item.createdAt.isBefore(start) &&
                  item.createdAt.isBefore(end),
            )
            .toList();
      }

      return invoices;
    });

/// Provider for purchase invoice details
final purchaseInvoiceDetailsProvider = FutureProvider.autoDispose
    .family<PurchaseInvoiceWithItems?, String>((ref, invoiceId) async {
      final db = ref.watch(dbProvider);
      return db.getPurchaseInvoiceWithItems(invoiceId);
    });
