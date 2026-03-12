import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';

final dashboardDateProvider = Provider<DateTime>((ref) {
  return DateTime.now();
});

final todaySalesProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(dbProvider);
  final now = ref.watch(dashboardDateProvider);
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  
  final summary = await db.getSalesSummary(startOfDay, endOfDay);
  return summary.totalAmount;
});

final todayProfitProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(dbProvider);
  final now = ref.watch(dashboardDateProvider);
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  
  final summary = await db.getProfitSummary(startOfDay, endOfDay);
  return summary.approximateProfit;
});

final openRepairsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(dbProvider);
  // Invalidate this provider when repairs table changes? 
  // For now simple Fetch. Realtime updates might need Stream.
  return db.getOpenRepairsCount();
});

final lowStockThresholdProvider = StateProvider<int>((ref) => 5);

final lowStockItemsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final db = ref.watch(dbProvider);
  final threshold = ref.watch(lowStockThresholdProvider);
  return db.getLowStockProducts(threshold);
});

final overdueRepairsProvider = FutureProvider.autoDispose<List<Repair>>((ref) async {
  final db = ref.watch(dbProvider);
  final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
  return db.getOverdueRepairs(threeDaysAgo);
});

final recentSalesProvider = FutureProvider.autoDispose<List<Sale>>((ref) async {
  final db = ref.watch(dbProvider);
  return db.getRecentSales(limit: 10);
});

final recentRepairsProvider = FutureProvider.autoDispose<List<Repair>>((ref) async {
  final db = ref.watch(dbProvider);
  return db.getRecentRepairs(limit: 10);
});
