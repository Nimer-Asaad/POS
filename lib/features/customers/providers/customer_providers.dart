import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../domain/customer_repository.dart';

/// Provider for customer repository
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.watch(dbProvider);
  return CustomerRepository(db);
});

/// Provider for customer search query
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for selected customer in customers page
final selectedCustomerIdProvider = StateProvider<String?>((ref) => null);

/// Provider for watching customers list with search
final customersProvider = StreamProvider.autoDispose<List<Customer>>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  final query = ref.watch(customerSearchQueryProvider);
  return repository.watchCustomers(query);
});

/// Provider for selected customer details
final selectedCustomerProvider = FutureProvider.autoDispose<Customer?>((
  ref,
) async {
  final customerId = ref.watch(selectedCustomerIdProvider);
  if (customerId == null) return null;

  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomerById(customerId);
});

// Customer statistics providers

/// Model for customer statistics
class CustomerStats {
  final int totalPurchasesCents;
  final int salesCount;
  final DateTime? lastPurchaseDate;

  CustomerStats({
    required this.totalPurchasesCents,
    required this.salesCount,
    this.lastPurchaseDate,
  });

  CustomerStats.empty()
    : totalPurchasesCents = 0,
      salesCount = 0,
      lastPurchaseDate = null;
}

/// Provider for customer statistics
final customerStatsProvider = FutureProvider.autoDispose
    .family<CustomerStats, String>((ref, customerId) async {
      final repository = ref.watch(customerRepositoryProvider);

      final results = await Future.wait([
        repository.getCustomerTotalPurchasesCents(customerId),
        repository.getCustomerSalesCount(customerId),
        repository.getCustomerLastPurchaseDate(customerId),
      ]);

      return CustomerStats(
        totalPurchasesCents: results[0] as int,
        salesCount: results[1] as int,
        lastPurchaseDate: results[2] as DateTime?,
      );
    });

/// Provider for customer sales history
final customerSalesProvider = FutureProvider.autoDispose
    .family<List<Sale>, String>((ref, customerId) {
      final repository = ref.watch(customerRepositoryProvider);
      return repository.getRecentSalesForCustomer(customerId, limit: 50);
    });

class CustomerHistoryEntry {
  final String id;
  final DateTime createdAt;
  final String type; // sale | return
  final int amountCents;
  final String? paymentType;
  final String? referenceId;

  const CustomerHistoryEntry({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.amountCents,
    this.paymentType,
    this.referenceId,
  });
}

final customerHistoryProvider = FutureProvider.autoDispose
    .family<List<CustomerHistoryEntry>, String>((ref, customerId) async {
      final repository = ref.watch(customerRepositoryProvider);
      final results = await Future.wait([
        repository.getRecentSalesForCustomer(customerId, limit: 50),
        repository.getRecentPaymentsForCustomer(customerId, limit: 50),
      ]);

      final sales = results[0] as List<Sale>;
      final payments = results[1] as List<Payment>;

      final history = <CustomerHistoryEntry>[];

      for (final sale in sales) {
        history.add(
          CustomerHistoryEntry(
            id: sale.id,
            createdAt: sale.createdAt,
            type: 'sale',
            amountCents: sale.total,
            paymentType: sale.paymentType,
            referenceId: sale.id,
          ),
        );
      }

      for (final payment in payments) {
        final note = payment.note ?? '';
        if (payment.direction == 'pay' && note.startsWith('Return:')) {
          final refId = note.replaceFirst('Return:', '').trim();
          history.add(
            CustomerHistoryEntry(
              id: payment.id,
              createdAt: payment.createdAt,
              type: 'return',
              amountCents: payment.amount,
              paymentType: 'Return',
              referenceId: refId.isEmpty ? null : refId,
            ),
          );
        }
      }

      history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return history;
    });

/// Provider for customer repair history
final customerRepairsProvider = FutureProvider.autoDispose
    .family<List<Repair>, String>((ref, customerId) {
      final repository = ref.watch(customerRepositoryProvider);
      return repository.getRecentRepairsForCustomer(customerId, limit: 20);
    });

/// Provider for customer payment history
final customerPaymentsProvider = FutureProvider.autoDispose
    .family<List<Payment>, String>((ref, customerId) {
      final repository = ref.watch(customerRepositoryProvider);
      return repository.getRecentPaymentsForCustomer(customerId, limit: 20);
    });
