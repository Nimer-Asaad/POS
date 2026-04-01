import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/transaction_status.dart';
import '../../../core/formatting/money.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_empty_state.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../domain/transaction_history_model.dart';
import '../providers/transaction_history_provider.dart';

enum ProviderOpsFilter { telelink, platform, farahnet, fawry, normalSales }

class ProviderOperationsScreen extends ConsumerStatefulWidget {
  const ProviderOperationsScreen({super.key});

  @override
  ConsumerState<ProviderOperationsScreen> createState() =>
      _ProviderOperationsScreenState();
}

class _ProviderOperationsScreenState
    extends ConsumerState<ProviderOperationsScreen> {
  DateTime _selectedDate = DateTime.now();
  ProviderOpsFilter _selectedFilter = ProviderOpsFilter.telelink;

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  String _lang(String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  String _filterLabel(ProviderOpsFilter filter) {
    switch (filter) {
      case ProviderOpsFilter.telelink:
        return _lang('تيلي لينك', 'TeleLink');
      case ProviderOpsFilter.platform:
        return _lang('المنصة', 'Platform');
      case ProviderOpsFilter.farahnet:
        return _lang('فرح نت', 'FarahNet');
      case ProviderOpsFilter.fawry:
        return _lang('فوري', 'Fawry');
      case ProviderOpsFilter.normalSales:
        return _lang('مبيعات عادية', 'Normal Sales');
    }
  }

  IconData _filterIcon(ProviderOpsFilter filter) {
    switch (filter) {
      case ProviderOpsFilter.telelink:
        return Icons.phone_android;
      case ProviderOpsFilter.platform:
        return Icons.language;
      case ProviderOpsFilter.farahnet:
        return Icons.wifi;
      case ProviderOpsFilter.fawry:
        return Icons.flash_on;
      case ProviderOpsFilter.normalSales:
        return Icons.receipt_long;
    }
  }

  String _normalizeProviderName(String raw) {
    final normalized = raw.trim().toLowerCase();
    switch (normalized) {
      case 'تيلي لينك':
      case 'tele link':
        return 'telelink';
      case 'المنصه':
      case 'المنصة':
        return 'platform';
      case 'فرح نت':
        return 'farahnet';
      default:
        return normalized;
    }
  }

  List<String> _descriptionSegments(String? description) {
    if (description == null || description.trim().isEmpty) {
      return const [];
    }

    // New records use `•`, older ones may still use ` - `.
    final hasBullet = description.contains('•');
    final rawParts = hasBullet
        ? description.split('•')
        : description.split(' - ');

    return rawParts
        .map(_normalizeProviderName)
        .where((part) => part.isNotEmpty)
        .toList();
  }

  bool _serviceHasProvider(UnifiedTransaction tx, String providerKey) {
    final provider = _normalizeProviderName(providerKey);
    final description = tx.description;
    if (description == null || description.trim().isEmpty) return false;

    final segments = _descriptionSegments(description);
    if (segments.contains(provider)) return true;

    // Fallback for free-form descriptions.
    return _normalizeProviderName(description).contains(provider);
  }

  bool _matchesSelectedFilter(UnifiedTransaction tx) {
    switch (_selectedFilter) {
      case ProviderOpsFilter.telelink:
        return tx.type == TransactionType.telelink ||
            (tx.type == TransactionType.service &&
                _serviceHasProvider(tx, 'telelink'));
      case ProviderOpsFilter.platform:
        return tx.type == TransactionType.service &&
            _serviceHasProvider(tx, 'platform');
      case ProviderOpsFilter.farahnet:
        return tx.type == TransactionType.farahnet ||
            (tx.type == TransactionType.service &&
                _serviceHasProvider(tx, 'farahnet'));
      case ProviderOpsFilter.fawry:
        return tx.type == TransactionType.service &&
            _serviceHasProvider(tx, 'fawry');
      case ProviderOpsFilter.normalSales:
        return tx.type == TransactionType.sale;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _shiftDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final range = TransactionDateRange(
      start: _startOfDay(_selectedDate),
      end: _endOfDay(_selectedDate),
    );
    final transactionsAsync = ref.watch(transactionsHistoryProvider(range));
    final dateText = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final canGoNext = !_isToday(_selectedDate);

    return GradientScaffold(
      appBar: AppTopBar(
        title: _lang('عمليات المزودات', 'Providers Operations'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ProviderOpsFilter.values.map((filter) {
                            final selected = filter == _selectedFilter;
                            return Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: AppSpacing.sm,
                              ),
                              child: ChoiceChip(
                                selected: selected,
                                label: Text(_filterLabel(filter)),
                                avatar: Icon(
                                  _filterIcon(filter),
                                  size: 18,
                                  color: selected
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                ),
                                selectedColor: AppColors.blue600,
                                labelStyle: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.w700,
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          IconButton(
                            tooltip: _lang('اليوم السابق', 'Previous day'),
                            onPressed: () => _shiftDate(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          AppCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: InkWell(
                              onTap: _pickDate,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    dateText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: _lang('اليوم التالي', 'Next day'),
                            onPressed: canGoNext ? () => _shiftDate(1) : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          OutlinedButton(
                            onPressed: _isToday(_selectedDate)
                                ? null
                                : () {
                                    setState(() {
                                      _selectedDate = DateTime.now();
                                    });
                                  },
                            child: Text(_lang('اليوم', 'Today')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: transactionsAsync.when(
                    data: (summary) {
                      final filtered = summary.transactions
                          .where((tx) => tx.status == TransactionStatus.normal)
                          .where(_matchesSelectedFilter)
                          .toList();

                      if (filtered.isEmpty) {
                        return AppEmptyState(
                          message: _lang(
                            'لا توجد عمليات',
                            'No operations found',
                          ),
                          subtitle: _lang(
                            'ما في حركات بهذا اليوم لهذا النوع.',
                            'No records for this date and selected type.',
                          ),
                          icon: Icons.inbox_outlined,
                        );
                      }

                      final total = filtered.fold<int>(
                        0,
                        (sum, tx) => sum + tx.amountCents,
                      );

                      return Column(
                        children: [
                          AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Icon(
                                  _filterIcon(_selectedFilter),
                                  color: AppColors.blue600,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  _filterLabel(_selectedFilter),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const Spacer(),
                                Text(
                                  '${_lang('المجموع', 'Total')}: ${formatMoneyCents(total)}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blue600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final tx = filtered[index];

                                return AppCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: tx.color.withValues(
                                        alpha: 0.15,
                                      ),
                                      child: Icon(tx.icon, color: tx.color),
                                    ),
                                    title: Text(
                                      tx.customerName?.trim().isNotEmpty == true
                                          ? tx.customerName!
                                          : _lang('بدون اسم', 'No Name'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat(
                                            'yyyy-MM-dd HH:mm',
                                          ).format(tx.createdAt),
                                        ),
                                        if ((tx.description ?? '')
                                            .trim()
                                            .isNotEmpty)
                                          Text(
                                            tx.description!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                    trailing: Text(
                                      formatMoneyCents(tx.amountCents),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.blue600,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => AppErrorState(
                      message: _lang(
                        'فشل تحميل العمليات',
                        'Failed to load operations',
                      ),
                      details: error.toString(),
                      stackTrace: stack,
                      onRetry: () =>
                          ref.invalidate(transactionsHistoryProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
