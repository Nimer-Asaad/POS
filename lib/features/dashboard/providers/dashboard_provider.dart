import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/db_provider.dart';

/// Dashboard data model
class DashboardData {
  final int todayOrdersCount;
  final double todayOrdersAmount;
  final double todayOrdersProfit;
  final int todayRepairsCount;
  final double todayRepairsProfit;
  final double todaySideRevenueProfit;
  final double totalProfit;

  const DashboardData({
    required this.todayOrdersCount,
    required this.todayOrdersAmount,
    required this.todayOrdersProfit,
    required this.todayRepairsCount,
    required this.todayRepairsProfit,
    required this.todaySideRevenueProfit,
    required this.totalProfit,
  });

  // Factory for mock/demo data
  factory DashboardData.mock() {
    const salesProfit = 4230.75;
    const repairProfit = 3500.00;
    const sideRevenueProfit = 1250.00;
    return DashboardData(
      todayOrdersCount: 23,
      todayOrdersAmount: 15420.50,
      todayOrdersProfit: salesProfit,
      todayRepairsCount: 12,
      todayRepairsProfit: repairProfit,
      todaySideRevenueProfit: sideRevenueProfit,
      totalProfit: salesProfit + repairProfit + sideRevenueProfit,
    );
  }

  // Factory for empty/default state
  factory DashboardData.empty() {
    return const DashboardData(
      todayOrdersCount: 0,
      todayOrdersAmount: 0.0,
      todayOrdersProfit: 0.0,
      todayRepairsCount: 0,
      todayRepairsProfit: 0.0,
      todaySideRevenueProfit: 0.0,
      totalProfit: 0.0,
    );
  }
}

/// Provider for dashboard data
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final db = ref.watch(dbProvider);

  try {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    // Use the same aggregate queries as reports screen for consistent values.
    final salesSummary = await db.getSalesSummary(startOfDay, endOfDay);
    final profitSummary = await db.getProfitSummary(startOfDay, endOfDay);

    // Get today's repairs count and profit
    final todayRepairs = await db.getTodayRepairs();
    final todayRepairsCount = todayRepairs.length;

    // Calculate repair profit correctly (revenue after discount - parts cost)
    final todayRepairsProfitCents = await db.getTodayRepairsProfit();
    final todaySideRevenueProfitCents = await db.getSideRevenueProfit(
      startOfDay,
      endOfDay,
    );

    final todayOrdersCount = salesSummary.salesCount;
    final todayOrdersAmount = salesSummary.totalAmount.toDouble() / 100;
    final todayOrdersProfit = profitSummary.approximateProfit.toDouble() / 100;
    final todayRepairsProfit = todayRepairsProfitCents.toDouble() / 100;
    final todaySideRevenueProfit = todaySideRevenueProfitCents.toDouble() / 100;
    final totalProfit = todayOrdersProfit + todayRepairsProfit;

    return DashboardData(
      todayOrdersCount: todayOrdersCount,
      todayOrdersAmount: todayOrdersAmount,
      todayOrdersProfit: todayOrdersProfit,
      todayRepairsCount: todayRepairsCount,
      todayRepairsProfit: todayRepairsProfit,
      todaySideRevenueProfit: todaySideRevenueProfit,
      totalProfit: totalProfit,
    );
  } catch (e) {
    // Return empty state on error to avoid misleading values.
    return DashboardData.empty();
  }
});

/// Provider for refreshing dashboard data
final dashboardRefreshProvider = StateProvider<int>((ref) => 0);
