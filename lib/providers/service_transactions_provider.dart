import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_store/data/db/daos/service_transactions_dao.dart';
import 'package:pos_store/data/db/daos/cash_drawer_dao.dart';
import 'package:pos_store/providers/db_provider.dart';
import 'package:pos_store/features/repairs/presentation/debts_screen.dart'
    show debtsGroupedProvider;

// ==================== DAO PROVIDERS ====================

final serviceTransactionsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return ServiceTransactionsDao(db);
});

final cashDrawerDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return CashDrawerDao(db);
});

// ==================== STREAM PROVIDERS ====================

final todayServiceTransactionsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(serviceTransactionsDaoProvider);
  return dao.watchTodayTransactions(limit: 10);
});

final allServiceTransactionsProvider = StreamProvider((ref) {
  final dao = ref.watch(serviceTransactionsDaoProvider);
  return dao.watchAllTransactions();
});

final todayServiceTotalsByProviderProvider = StreamProvider.autoDispose((ref) {
  // Not implemented in current DAO - returns empty stream
  return Stream.empty();
});

// Removed: todayServiceTransactionsByDateRangeProvider (not implemented in DAO)

// ==================== FUTURE PROVIDERS ====================

final todayWebsitesTotalProvider = FutureProvider.autoDispose((ref) async {
  final dao = ref.watch(serviceTransactionsDaoProvider);
  return dao.getTodayTotalByCategory('websites');
});

final todayPalPayTotalProvider = FutureProvider.autoDispose((ref) async {
  final dao = ref.watch(serviceTransactionsDaoProvider);
  return dao.getTodayTotalByCategory('palpay');
});

final todayGrandTotalProvider = FutureProvider.autoDispose((ref) async {
  final dao = ref.watch(serviceTransactionsDaoProvider);
  return dao.getTodayGrandTotal();
});

final todayDrawerOpenCountProvider = FutureProvider.autoDispose((ref) async {
  final dao = ref.watch(cashDrawerDaoProvider);
  return dao.getTodayOpenCount();
});

final todayDrawerOpenEventsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(cashDrawerDaoProvider);
  return dao.watchTodayOpenEvents();
});

// ==================== NOTIFIER FOR OPERATIONS ====================

class ServiceTransactionNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addServiceTransaction({
    required String category,
    required String provider,
    String? providerLabel,
    String? customerName,
    required int amountCents,
    int? profitCents,
    String? notes,
    String? saleId,
  }) async {
    final dao = ref.read(serviceTransactionsDaoProvider);
    try {
      await dao.insertTransaction(
        category: category,
        provider: provider,
        providerLabel: providerLabel,
        customerName: customerName,
        amountCents: amountCents,
        profitCents: profitCents,
        notes: notes,
        saleId: saleId,
      );
      // Invalidate relevant providers to refresh UI
      ref.invalidate(todayServiceTransactionsProvider);
      ref.invalidate(todayServiceTotalsByProviderProvider);
      ref.invalidate(todayWebsitesTotalProvider);
      ref.invalidate(todayPalPayTotalProvider);
      ref.invalidate(todayGrandTotalProvider);
      
      // Also invalidate debts provider if customer name is provided
      if (customerName != null && customerName.isNotEmpty) {
        ref.invalidate(debtsGroupedProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> openCashDrawer({String? notes}) async {
    final dao = ref.read(cashDrawerDaoProvider);
    try {
      await dao.insertOpenEvent(notes: notes);
      ref.invalidate(todayDrawerOpenCountProvider);
      ref.invalidate(todayDrawerOpenEventsProvider);
    } catch (e) {
      rethrow;
    }
  }
}

final serviceTransactionControllerProvider =
    NotifierProvider<ServiceTransactionNotifier, void>(
      () => ServiceTransactionNotifier(),
    );
