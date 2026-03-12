import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_store/data/db/daos/electricity_recharge_dao.dart';
import 'package:pos_store/data/db/daos/wallet_operations_dao.dart';
import 'package:pos_store/data/db/daos/telelink_operations_dao.dart';
import 'package:pos_store/data/db/daos/farahnet_payments_dao.dart';
import 'package:pos_store/data/db/daos/program_topups_dao.dart';
import 'package:pos_store/data/db/daos/settlements_dao.dart';
import 'package:pos_store/providers/db_provider.dart';
import 'package:pos_store/data/db/app_database.dart';

// ==================== DAO PROVIDERS ====================
// NOTE: DAO providers are NOT autoDispose - they should live for app lifetime
// Only disposable data providers use autoDispose

final electricityRechargeDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return ElectricityRechargeDao(db);
});

final walletOperationsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return WalletOperationsDao(db);
});

final telelinkOperationsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return TelelinkOperationsDao(db);
});

final farahnetPaymentsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return FarahnetPaymentsDao(db);
});

final programTopupsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return ProgramTopupsDao(db);
});

final settlementsDaoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return SettlementsDao(db);
});

// ==================== ELECTRICITY RECHARGES ====================

final electricityRechargesProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(electricityRechargeDaoProvider);
  return dao.watchAllRecharges();
});

final electricityRechargesForDateProvider = StreamProvider.autoDispose
    .family<List<ElectricityRecharge>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(electricityRechargeDaoProvider);
      return dao.watchRechargesForDate(date);
    });

final electricityRechargesDailyTotalProvider = FutureProvider.autoDispose
    .family<int, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(electricityRechargeDaoProvider);
      return dao.getTotalForDate(date);
    });

// ==================== WALLET OPERATIONS ====================

final walletOperationsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(walletOperationsDaoProvider);
  return dao.watchAllOperations();
});

final walletOperationsForDateProvider = StreamProvider.autoDispose
    .family<List<WalletOperation>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(walletOperationsDaoProvider);
      return dao.watchOperationsForDate(date);
    });

final walletOperationsDailyTotalProvider = FutureProvider.autoDispose
    .family<int, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(walletOperationsDaoProvider);
      return dao.getTotalForDate(date);
    });

// ==================== TELELINK OPERATIONS ====================

final telelinkOperationsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(telelinkOperationsDaoProvider);
  return dao.watchAllOperations();
});

final telelinkOperationsForDateProvider = StreamProvider.autoDispose
    .family<List<TelelinkOperation>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(telelinkOperationsDaoProvider);
      return dao.watchOperationsForDate(date);
    });

final telelinkOperationsDailyTotalProvider = FutureProvider.autoDispose
    .family<int, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(telelinkOperationsDaoProvider);
      return dao.getTotalForDate(date);
    });

// ==================== FARAHNET PAYMENTS ====================

final farahnetPaymentsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(farahnetPaymentsDaoProvider);
  return dao.watchAllPayments();
});

final farahnetPaymentsForDateProvider = StreamProvider.autoDispose
    .family<List<FarahnetPayment>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(farahnetPaymentsDaoProvider);
      return dao.watchPaymentsForDate(date);
    });

final farahnetPaymentsDailyTotalsProvider = FutureProvider.autoDispose
    .family<Map<String, int>, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(farahnetPaymentsDaoProvider);
      return dao.getTotalsForDate(date);
    });

// ==================== PROGRAM TOPUPS ====================

final programTopupsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(programTopupsDaoProvider);
  return dao.watchAllTopups();
});

final programTopupsForDateProvider = StreamProvider.autoDispose
    .family<List<ProgramTopup>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(programTopupsDaoProvider);
      return dao.watchTopupsForDate(date);
    });

final programTopupsByProgramProvider = StreamProvider.autoDispose
    .family<List<ProgramTopup>, String>((ref, String program) {
      final dao = ref.watch(programTopupsDaoProvider);
      return dao.watchTopupsByProgram(program);
    });

final programTopupsDailyTotalProvider = FutureProvider.autoDispose
    .family<int, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(programTopupsDaoProvider);
      return dao.getTotalForDate(date);
    });

// ==================== SETTLEMENTS ====================

final settlementsProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(settlementsDaoProvider);
  return dao.watchAllSettlements();
});

final settlementsForDateProvider = StreamProvider.autoDispose
    .family<List<Settlement>, DateTime>((ref, DateTime date) {
      final dao = ref.watch(settlementsDaoProvider);
      return dao.watchSettlementsForDate(date);
    });

final settlementsByProgramProvider = StreamProvider.autoDispose
    .family<List<Settlement>, String>((ref, String program) {
      final dao = ref.watch(settlementsDaoProvider);
      return dao.watchSettlementsByProgram(program);
    });

final settlementsDailyTotalProvider = FutureProvider.autoDispose
    .family<int, DateTime>((ref, DateTime date) async {
      final dao = ref.watch(settlementsDaoProvider);
      return dao.getTotalForDate(date);
    });

// ==================== DAILY RECONCILIATION ====================

class DailyReconciliation {
  final DateTime date;
  final int openingBalance;
  final int electricityRecharges;
  final int walletOperations;
  final int telelinkOperations;
  final int farahnetAmount;
  final int farahnetProfit;
  final int walletTopups;
  final int telelinkTopups;
  final int walletSettlements;
  final int telelinkSettlements;
  final int closingBalance;

  DailyReconciliation({
    required this.date,
    required this.openingBalance,
    required this.electricityRecharges,
    required this.walletOperations,
    required this.telelinkOperations,
    required this.farahnetAmount,
    required this.farahnetProfit,
    required this.walletTopups,
    required this.telelinkTopups,
    required this.walletSettlements,
    required this.telelinkSettlements,
    required this.closingBalance,
  });
}

/// Simpler daily reconciliation provider that avoids circular dependencies
final dailyReconciliationProvider = FutureProvider.autoDispose
    .family<DailyReconciliation, DateTime>((ref, DateTime date) async {
      // Use read() to avoid circular dependencies with settlementsDaoProvider
      final elecDao = ref.read(electricityRechargeDaoProvider);
      final walletDao = ref.read(walletOperationsDaoProvider);
      final telelinkDao = ref.read(telelinkOperationsDaoProvider);
      final farahnetDao = ref.read(farahnetPaymentsDaoProvider);
      final topupsDao = ref.read(programTopupsDaoProvider);
      final settlementsDao = ref.read(settlementsDaoProvider);

      // Get all data concurrently
      final results = await Future.wait([
        elecDao.getTotalForDate(date),
        walletDao.getTotalForDate(date),
        telelinkDao.getTotalForDate(date),
        farahnetDao.getTotalsForDate(date),
        topupsDao.getTotalForDate(date),
        settlementsDao.getTotalByProgram('Wallet'),
        settlementsDao.getTotalByProgram('TeleLink'),
      ]);

      final electricityTotal = results[0] as int;
      final walletTotal = results[1] as int;
      final telelinkTotal = results[2] as int;
      final farahnetData = results[3] as Map<String, int>;
      final topupsTotal = results[4] as int;
      final walletSettlements = results[5] as int? ?? 0;
      final telelinkSettlements = results[6] as int? ?? 0;

      // Calculate closing balance
      const openingBalance = 0;
      final totalAmountValue = farahnetData['totalAmount'] ?? 0;
      final allCashReceived =
          electricityTotal + walletTotal + telelinkTotal + totalAmountValue;
      final closingBalance =
          openingBalance +
          allCashReceived -
          walletSettlements -
          telelinkSettlements;

      return DailyReconciliation(
        date: date,
        openingBalance: openingBalance,
        electricityRecharges: electricityTotal,
        walletOperations: walletTotal,
        telelinkOperations: telelinkTotal,
        farahnetAmount: farahnetData['totalAmount'] ?? 0,
        farahnetProfit: farahnetData['totalProfit'] ?? 0,
        walletTopups: topupsTotal,
        telelinkTopups: topupsTotal,
        walletSettlements: walletSettlements,
        telelinkSettlements: telelinkSettlements,
        closingBalance: closingBalance,
      );
    });

// ==================== ADD OPERATION PROVIDERS ====================

final addElectricityRechargeProvider = FutureProvider.autoDispose.family((
  ref,
  ({
    String customerName,
    String? subscriptionNumber,
    int amount,
    String type,
    String? notes,
  })
  params,
) async {
  final dao = ref.watch(electricityRechargeDaoProvider);
  return dao.addRecharge(
    customerName: params.customerName,
    subscriptionNumber: params.subscriptionNumber,
    amount: params.amount,
    operatedAt: DateTime.now(),
    operationType: params.type,
    notes: params.notes,
  );
});

final addWalletOperationProvider = FutureProvider.autoDispose.family((
  ref,
  ({String customerName, int amount, String? notes}) params,
) async {
  final dao = ref.watch(walletOperationsDaoProvider);
  return dao.addOperation(
    customerName: params.customerName,
    amount: params.amount,
    operatedAt: DateTime.now(),
    notes: params.notes,
  );
});

final addTelelinkOperationProvider = FutureProvider.autoDispose.family((
  ref,
  ({String customerName, int amount, String operationType, String? notes})
  params,
) async {
  final dao = ref.watch(telelinkOperationsDaoProvider);
  return dao.addOperation(
    customerName: params.customerName,
    amount: params.amount,
    operationType: params.operationType,
    operatedAt: DateTime.now(),
    notes: params.notes,
  );
});

final addFarahnetPaymentProvider = FutureProvider.autoDispose.family((
  ref,
  ({String customerName, int amountPaid, String? notes}) params,
) async {
  final dao = ref.watch(farahnetPaymentsDaoProvider);
  return dao.addPayment(
    customerName: params.customerName,
    amountPaid: params.amountPaid,
    operatedAt: DateTime.now(),
    notes: params.notes,
  );
});
