import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';

// Date filter for purchases
final purchaseDateFilterProvider = StateProvider<DateTime?>((ref) => null);

// Generate sequential invoice number based on date and purchases on that date
String _generateSequentialInvoiceNumber(
  List<PurchaseOrPayment> purchases,
  PurchaseOrPayment purchase,
) {
  // Get all purchases for the same date
  final purchaseDateStart =
      DateTime(purchase.createdAt.year, purchase.createdAt.month, purchase.createdAt.day);
  final purchaseDateEnd =
      purchaseDateStart.add(const Duration(days: 1));

  final sameDayPurchases = purchases
      .where((p) =>
          p.type == 'purchase' &&
          p.createdAt.isAfter(purchaseDateStart) &&
          p.createdAt.isBefore(purchaseDateEnd))
      .toList();

  // Sort by creation time
  sameDayPurchases.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  // Find sequence number
  final index = sameDayPurchases.indexWhere((p) => p.id == purchase.id);
  final sequence = index + 1;

  // Format: YYYY-MM-DD-###
  final dateStr =
      '${purchase.createdAt.year}-${purchase.createdAt.month.toString().padLeft(2, '0')}-${purchase.createdAt.day.toString().padLeft(2, '0')}';
  return '$dateStr-${sequence.toString().padLeft(3, '0')}';
}

final suppliersSearchQueryProvider = StateProvider<String>((ref) => '');

final suppliersProvider = FutureProvider.autoDispose<List<Supplier>>((
  ref,
) async {
  final db = ref.watch(dbProvider);
  final query = ref.watch(suppliersSearchQueryProvider);

  if (query.isEmpty) {
    return db.getAllSuppliers(limit: 100);
  }
  return db.searchSuppliers(query);
});

final purchasesProvider = FutureProvider.autoDispose<List<Purchase>>((
  ref,
) async {
  final db = ref.watch(dbProvider);
  return db.getAllPurchases(limit: 100);
});

// Combined purchases and payments provider with date filtering and sequential numbering
final purchasesAndPaymentsProvider =
    FutureProvider.autoDispose<List<PurchaseOrPayment>>((ref) async {
      final db = ref.watch(dbProvider);
      final dateFilter = ref.watch(purchaseDateFilterProvider);
      
      var result = await db.getAllPurchasesAndPayments(limit: 100);

      // Filter by date if selected
      if (dateFilter != null) {
        final filterStart =
            DateTime(dateFilter.year, dateFilter.month, dateFilter.day);
        final filterEnd = filterStart.add(const Duration(days: 1));

        result = result
            .where((item) =>
                item.createdAt.isAfter(filterStart) &&
                item.createdAt.isBefore(filterEnd))
            .toList();
      }

      // Generate sequential invoice numbers for purchases
      return result.map((item) {
        if (item.type == 'purchase') {
          final sequentialNumber = _generateSequentialInvoiceNumber(result, item);
          return PurchaseOrPayment(
            id: item.id,
            type: item.type,
            supplierId: item.supplierId,
            supplierName: item.supplierName,
            invoiceNumber: sequentialNumber,
            total: item.total,
            paid: item.paid,
            description: item.description,
            createdAt: item.createdAt,
          );
        }
        return item;
      }).toList();
    });

final purchaseDetailsProvider = FutureProvider.autoDispose
    .family<PurchaseWithItems?, String>((ref, purchaseId) async {
      final db = ref.watch(dbProvider);
      return db.getPurchaseWithItems(purchaseId);
    });
// Get all purchases from a specific supplier
final supplierPurchasesProvider = FutureProvider.autoDispose
    .family<List<PurchaseWithItems>, String>((ref, supplierId) async {
      final db = ref.watch(dbProvider);
      return db.getPurchasesBySupplier(supplierId);
    });

// Get all purchases and payments from a specific supplier (combined)
final supplierPurchasesAndPaymentsProvider = FutureProvider.autoDispose
    .family<List<PurchaseOrPayment>, String>((ref, supplierId) async {
      final db = ref.watch(dbProvider);
      return db.getPurchasesAndPaymentsBySupplier(supplierId);
    });

// Get supplier summary (total purchases, balance, etc.)
final supplierSummaryProvider = FutureProvider.autoDispose
    .family<SupplierSummary?, String>((ref, supplierId) async {
      final db = ref.watch(dbProvider);
      return db.getSupplierSummary(supplierId);
    });

// Get all payments for a specific purchase
final purchasePaymentsProvider = FutureProvider.autoDispose
    .family<List<PurchasePaymentRecord>, String>((ref, purchaseId) async {
      final db = ref.watch(dbProvider);
      return db.getPaymentsByPurchase(purchaseId);
    });

// Get all payments for a specific supplier
final supplierPaymentsProvider = FutureProvider.autoDispose
    .family<List<PurchasePaymentRecord>, String>((ref, supplierId) async {
      final db = ref.watch(dbProvider);
      return db.getPaymentsBySupplier(supplierId);
    });

// Get total payments by supplier
final supplierTotalPaymentsProvider = FutureProvider.autoDispose
    .family<int, String>((ref, supplierId) async {
      final db = ref.watch(dbProvider);
      return db.getTotalPaymentsBySupplier(supplierId);
    });

// When a new payment is added, invalidate related providers
final addPurchasePaymentProvider = FutureProvider.autoDispose
    .family<
      String,
      (String purchaseId, String supplierId, int amount, String?)
    >((ref, params) async {
      final db = ref.watch(dbProvider);
      final (purchaseId, supplierId, amount, description) = params;

      final paymentId = await db.recordPurchasePayment(
        purchaseId: purchaseId,
        supplierId: supplierId,
        amount: amount,
        description: description,
      );

      // Invalidate related providers
      ref.invalidate(purchasePaymentsProvider(purchaseId));
      ref.invalidate(supplierPaymentsProvider(supplierId));
      ref.invalidate(supplierTotalPaymentsProvider(supplierId));
      ref.invalidate(supplierSummaryProvider(supplierId));
      ref.invalidate(purchaseDetailsProvider(purchaseId));

      return paymentId;
    });
