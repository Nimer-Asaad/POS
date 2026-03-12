import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Service to clear all data from Supabase database
/// Preserves table structure, only deletes data
class ClearSupabaseData {
  final SupabaseClient _supabase;

  ClearSupabaseData({SupabaseClient? supabase})
    : _supabase = supabase ?? SupabaseConfig.client;

  /// Clear all data from Supabase in correct order (respecting FK constraints)
  Future<Map<String, dynamic>> clearAllData({
    Function(String tableName)? onTableCleared,
  }) async {
    if (!SupabaseConfig.isInitialized) {
      throw Exception('Supabase not initialized');
    }

    final stats = <String, int>{};
    final errors = <String, String>{};

    print('🗑️  Starting Supabase data clearing...');

    try {
      // ========================================================================
      // CHILD TABLES (with FK dependencies) - Delete first
      // ========================================================================

      await _clearTable('repair_parts', stats, errors, onTableCleared);
      await _clearTable('repair_part_orders', stats, errors, onTableCleared);
      await _clearTable('sale_items', stats, errors, onTableCleared);
      await _clearTable('purchase_items', stats, errors, onTableCleared);
      await _clearTable(
        'purchase_invoice_items',
        stats,
        errors,
        onTableCleared,
      );
      await _clearTable('purchase_payments', stats, errors, onTableCleared);
      await _clearTable('service_transactions', stats, errors, onTableCleared);
      await _clearTable('stock_movements', stats, errors, onTableCleared);
      await _clearTable('debts', stats, errors, onTableCleared);
      await _clearTable('payments', stats, errors, onTableCleared);

      // ========================================================================
      // PARENT TABLES (referenced by others)
      // ========================================================================

      await _clearTable('repairs', stats, errors, onTableCleared);
      await _clearTable('sales', stats, errors, onTableCleared);
      await _clearTable('purchases', stats, errors, onTableCleared);
      await _clearTable('purchase_invoices', stats, errors, onTableCleared);
      await _clearTable('products', stats, errors, onTableCleared);
      await _clearTable('customers', stats, errors, onTableCleared);
      await _clearTable('suppliers', stats, errors, onTableCleared);

      // ========================================================================
      // STANDALONE TABLES (no FK dependencies)
      // ========================================================================

      await _clearTable('electricity_recharges', stats, errors, onTableCleared);
      await _clearTable('wallet_operations', stats, errors, onTableCleared);
      await _clearTable('telelink_operations', stats, errors, onTableCleared);
      await _clearTable('farahnet_payments', stats, errors, onTableCleared);
      await _clearTable('program_topups', stats, errors, onTableCleared);
      await _clearTable('settlements', stats, errors, onTableCleared);
      await _clearTable(
        'service_daily_inventory',
        stats,
        errors,
        onTableCleared,
      );
      await _clearTable('cash_drawer_events', stats, errors, onTableCleared);

      print('✅ All Supabase data cleared successfully!');

      return {
        'success': true,
        'stats': stats,
        'errors': errors,
        'totalTablesCleared': stats.length,
        'totalRowsDeleted': stats.values.fold<int>(
          0,
          (sum, count) => sum + count,
        ),
      };
    } catch (e, stackTrace) {
      print('❌ Error clearing Supabase data: $e');
      print('Stack trace: $stackTrace');

      return {
        'success': false,
        'error': e.toString(),
        'stats': stats,
        'errors': errors,
      };
    }
  }

  /// Clear a single table and track stats
  Future<void> _clearTable(
    String tableName,
    Map<String, int> stats,
    Map<String, String> errors,
    Function(String)? onTableCleared,
  ) async {
    try {
      print('   Clearing $tableName...');

      // Get count before deletion
      final countResponse = await _supabase
          .from(tableName)
          .select('id')
          .count();
      final beforeCount = countResponse.count;

      // Delete all rows
      await _supabase.from(tableName).delete().neq('id', '__impossible__');

      // Verify deletion
      final afterCountResponse = await _supabase
          .from(tableName)
          .select('id')
          .count();
      final afterCount = afterCountResponse.count;

      stats[tableName] = beforeCount;

      print('   ✅ Cleared $tableName: $beforeCount rows deleted');

      if (afterCount > 0) {
        errors[tableName] = 'Warning: $afterCount rows remaining after delete';
        print('   ⚠️  Warning: $afterCount rows still exist in $tableName');
      }

      onTableCleared?.call(tableName);
    } catch (e) {
      errors[tableName] = e.toString();
      print('   ❌ Failed to clear $tableName: $e');
      // Continue with other tables even if one fails
    }
  }

  /// Clear only local cache data (for testing)
  Future<Map<String, dynamic>> clearLocalOnly() async {
    // This would be implemented in the local database clearer
    throw UnimplementedError('Use LocalDataClearer for local clearing');
  }

  /// Verify all tables are empty
  Future<Map<String, int>> verifyDataCleared() async {
    final counts = <String, int>{};

    final tables = [
      'suppliers',
      'products',
      'customers',
      'purchases',
      'purchase_items',
      'sales',
      'sale_items',
      'repairs',
      'repair_parts',
      'debts',
      'payments',
      'stock_movements',
      'electricity_recharges',
      'wallet_operations',
      'telelink_operations',
      'farahnet_payments',
      'program_topups',
      'settlements',
      'service_transactions',
      'service_daily_inventory',
      'cash_drawer_events',
      'repair_part_orders',
      'purchase_invoices',
      'purchase_invoice_items',
      'purchase_payments',
    ];

    for (final table in tables) {
      try {
        final response = await _supabase.from(table).select('id').count();
        counts[table] = response.count;
      } catch (e) {
        counts[table] = -1; // Error indicator
        print('Error counting $table: $e');
      }
    }

    return counts;
  }
}
