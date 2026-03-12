import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/formatting/money.dart';
import '../../../../design/app_colors.dart';
import '../../../../core/ui/widgets/app_error_state.dart';
import '../../providers/customer_providers.dart';

/// Widget displaying customer statistics cards
class CustomerStatsCards extends ConsumerWidget {
  final String customerId;

  const CustomerStatsCards({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(customerStatsProvider(customerId));

    return statsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'إجمالي المشتريات',
                subtitle: 'Total Purchases',
                value: formatMoneyCents(stats.totalPurchasesCents),
                icon: Icons.shopping_cart,
                color: AppColors.blue600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'عدد الفواتير',
                subtitle: 'Invoice Count',
                value: '${stats.salesCount}',
                icon: Icons.receipt_long,
                color: AppColors.green600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'آخر شراء',
                subtitle: 'Last Purchase',
                value: stats.lastPurchaseDate != null
                    ? DateFormat('yyyy-MM-dd').format(stats.lastPurchaseDate!)
                    : '-',
                icon: Icons.calendar_today,
                color: AppColors.purple600,
              ),
            ),
          ],
        );
      },
      error: (error, stack) => AppErrorState(
        message: 'Failed to load customer statistics',
        details: error.toString(),
        stackTrace: stack,
        onRetry: () => ref.invalidate(customerStatsProvider(customerId)),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
