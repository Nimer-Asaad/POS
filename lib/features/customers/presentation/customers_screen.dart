import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../design/app_colors.dart';
import '../providers/customer_providers.dart';
import 'add_customer_dialog.dart';
import 'widgets/customer_stats_cards.dart';
import 'widgets/customer_sales_history_table.dart';
import 'package:pos_store/l10n/app_localizations.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddCustomerDialog() async {
    final customerId = await showDialog<String>(
      context: context,
      builder: (context) => AddCustomerDialog(onCustomerAdded: (id) {}),
    );

    if (customerId != null) {
      ref.read(selectedCustomerIdProvider.notifier).state = customerId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final selectedCustomerId = ref.watch(selectedCustomerIdProvider);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: AppTopBar(title: l10n.customers),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Customer List
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: l10n.search,
                                  filled: true,
                                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  ref
                                          .read(
                                            customerSearchQueryProvider
                                                .notifier,
                                          )
                                          .state =
                                      value;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            GradientButton(
                              label: l10n.addCustomer,
                              icon: Icons.person_add,
                              onPressed: _showAddCustomerDialog,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: customersAsync.when(
                            data: (customers) {
                              if (customers.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد زبائن'),
                                );
                              }

                              return ListView.separated(
                                itemCount: customers.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final customer = customers[index];
                                  final isSelected =
                                      selectedCustomerId == customer.id;

                                  return ListTile(
                                    selected: isSelected,
                                    selectedTileColor: AppColors.blue600
                                        .withOpacity(0.05),
                                    leading: CircleAvatar(
                                      backgroundColor: isSelected
                                          ? AppColors.blue600
                                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: Text(
                                        customer.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      customer.name,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    subtitle: Text(customer.phone ?? '-'),
                                    onTap: () {
                                      ref
                                          .read(
                                            selectedCustomerIdProvider.notifier,
                                          )
                                          .state = customer
                                          .id;
                                    },
                                  );
                                },
                              );
                            },
                            error: (error, stack) => AppErrorState(
                              message: 'Failed to load customers',
                              details: error.toString(),
                              stackTrace: stack,
                              onRetry: () => ref.invalidate(customersProvider),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Right: Customer Details
                Expanded(
                  flex: 4,
                  child: AppCard(
                    child: customersAsync.when(
                      data: (customers) {
                        Customer? selectedCustomer;
                        if (selectedCustomerId != null) {
                          for (final c in customers) {
                            if (c.id == selectedCustomerId) {
                              selectedCustomer = c;
                              break;
                            }
                          }
                        }

                        if (selectedCustomer == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 64,
                                  color: Theme.of(context).disabledColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.selectCustomer,
                                  style: TextStyle(color: Theme.of(context).hintColor),
                                ),
                              ],
                            ),
                          );
                        }

                        final customer = selectedCustomer;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Customer Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.phone ?? '-',
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Statistics Cards
                            CustomerStatsCards(customerId: customer.id),
                            const SizedBox(height: 24),

                            // Section Title
                            Row(
                              children: [
                                const Icon(
                                  Icons.history,
                                  size: 20,
                                  color: AppColors.blue600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'سجل المبيعات / Sales History',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Sales History Table
                            Expanded(
                              child: CustomerSalesHistoryTable(
                                customerId: customer.id,
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, stack) => AppErrorState(
                        message: 'Failed to load customer details',
                        details: error.toString(),
                        stackTrace: stack,
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
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
