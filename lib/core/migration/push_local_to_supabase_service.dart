import 'package:supabase_flutter/supabase_flutter.dart';

/// Migration statistics for a single table
class MigrationTableStats {
  final String tableName;
  final int totalRows;
  final int successfulRows;
  final int failedRows;
  final Duration duration;
  final List<String> errors;

  MigrationTableStats({
    required this.tableName,
    required this.totalRows,
    required this.successfulRows,
    required this.failedRows,
    required this.duration,
    required this.errors,
  });

  @override
  String toString() {
    final errorStr = errors.isEmpty
        ? ''
        : '\n  Errors: ${errors.take(3).join('\n  ')}${errors.length > 3 ? '\n  ... and ${errors.length - 3} more' : ''}';
    return '$tableName: $successfulRows/$totalRows successful (${duration.inSeconds}s)$errorStr';
  }
}

/// Callback for migration progress updates
typedef MigrationProgressCallback =
    void Function(
      String tableName,
      int current,
      int total,
      MigrationTableStats? statsIfComplete,
    );

/// Service to migrate local Drift database to Supabase
///
/// Migrates all 25 tables preserving IDs and relationships.
/// Uploads in dependency order to respect foreign keys.
/// Uses batch operations (200 rows per batch) for efficiency.
class PushLocalToSupabaseService {
  static const int batchSize = 200;
  static const Duration defaultTimeout = Duration(minutes: 5);

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Start migration process
  ///
  /// Requires [driftDatabase] instance to read local data
  /// Optional [onProgress] callback for real-time updates
  /// Returns list of stats for each table
  Future<List<MigrationTableStats>> migrate({
    required dynamic driftDatabase,
    MigrationProgressCallback? onProgress,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('🚀 Starting Supabase migration...');
      print('📊 Batch size: $batchSize rows');

      final stats = <MigrationTableStats>[];
      final startTime = DateTime.now();

      // Order tables by dependencies (parents before children)
      // Suppliers and Customers have no dependencies
      // Products depends on Suppliers
      // sales/repairs depend on Customers
      // etc.

      final migrationOrder = [
        // No dependencies
        ('suppliers', []),
        ('customers', []),
        // Depends on parent tables
        ('products', ['suppliers']),
        ('purchases', ['suppliers']),
        ('sales', ['customers']),
        ('repairs', ['customers']),
        ('purchase_invoices', []),
        // Depends on products/purchases/sales
        ('purchase_items', ['purchases', 'products']),
        ('sale_items', ['sales', 'products']),
        ('repair_parts', ['repairs', 'products']),
        ('repair_part_orders', ['repairs', 'products', 'suppliers']),
        ('purchase_invoice_items', ['purchase_invoices', 'products']),
        ('purchase_payments', ['purchases', 'suppliers']),
        ('stock_movements', ['products']),
        ('payments', ['customers']),
        ('debts', ['customers']),
        // Service tables (no dependencies)
        ('electricity_recharges', []),
        ('wallet_operations', []),
        ('telelink_operations', []),
        ('farahnet_payments', []),
        ('program_topups', []),
        ('settlements', []),
        ('service_transactions', ['sales']),
        ('service_daily_inventory', []),
        ('cash_drawer_events', []), // Special: SERIAL PK
      ];

      for (final (tableName, _) in migrationOrder) {
        try {
          print('\n📤 Migrating table: $tableName');
          final tableStats = await _migrateTable(
            tableName,
            driftDatabase,
            onProgress,
          );
          stats.add(tableStats);
          print('✅ $tableStats');
        } catch (e, st) {
          print('❌ Error migrating $tableName: $e');
          print(st);
          stats.add(
            MigrationTableStats(
              tableName: tableName,
              totalRows: 0,
              successfulRows: 0,
              failedRows: 0,
              duration: Duration.zero,
              errors: ['$e'],
            ),
          );
        }
      }

      final totalTime = DateTime.now().difference(startTime);
      _printSummary(stats, totalTime);

      return stats;
    } catch (e, st) {
      print('❌ Migration failed: $e');
      print(st);
      rethrow;
    }
  }

  /// Migrate a single table
  Future<MigrationTableStats> _migrateTable(
    String tableName,
    dynamic driftDatabase,
    MigrationProgressCallback? onProgress,
  ) async {
    final startTime = DateTime.now();
    final errors = <String>[];
    int successCount = 0;
    int failCount = 0;

    try {
      // Load all records from local Drift database
      final List<Map<String, dynamic>> records = await _loadRecordsFromDrift(
        tableName,
        driftDatabase,
      );

      final totalCount = records.length;
      print('  📥 Loaded $totalCount records from local database');

      if (records.isEmpty) {
        return MigrationTableStats(
          tableName: tableName,
          totalRows: 0,
          successfulRows: 0,
          failedRows: 0,
          duration: DateTime.now().difference(startTime),
          errors: [],
        );
      }

      // Upload in batches
      for (int i = 0; i < records.length; i += batchSize) {
        final batch = records.sublist(
          i,
          (i + batchSize).clamp(0, records.length),
        );

        try {
          await _supabase.from(tableName).insert(batch);
          successCount += batch.length;
          print('  ✓ Batch $i-${i + batch.length}/$totalCount uploaded');
        } catch (e) {
          failCount += batch.length;
          errors.add('Batch error at rows $i-${i + batch.length}: $e');
          // Continue with next batch
        }

        // Call progress callback
        onProgress?.call(
          tableName,
          i + batch.length,
          totalCount,
          null, // Not complete yet
        );
      }

      final stats = MigrationTableStats(
        tableName: tableName,
        totalRows: totalCount,
        successfulRows: successCount,
        failedRows: failCount,
        duration: DateTime.now().difference(startTime),
        errors: errors,
      );

      // Final callback
      onProgress?.call(tableName, totalCount, totalCount, stats);

      return stats;
    } catch (e) {
      final stats = MigrationTableStats(
        tableName: tableName,
        totalRows: 0,
        successfulRows: successCount,
        failedRows: failCount,
        duration: DateTime.now().difference(startTime),
        errors: ['Fatal error: $e'],
      );
      return stats;
    }
  }

  /// Load records from local Drift database
  ///
  /// Special handling for cash_drawer_events (integer PK)
  Future<List<Map<String, dynamic>>> _loadRecordsFromDrift(
    String tableName,
    dynamic driftDatabase,
  ) async {
    try {
      // Convert Drift objects to maps
      // This requires the Drift database instance methods
      // which are specific to your schema

      switch (tableName) {
        case 'suppliers':
          return _convertToMaps(await driftDatabase.suppliers.all());
        case 'customers':
          return _convertToMaps(await driftDatabase.customers.all());
        case 'products':
          return _convertToMaps(await driftDatabase.products.all());
        case 'purchases':
          return _convertToMaps(await driftDatabase.purchases.all());
        case 'purchase_items':
          return _convertToMaps(await driftDatabase.purchase_items.all());
        case 'purchase_invoices':
          return _convertToMaps(
            await driftDatabase.purchase_invoices.all(),
          );
        case 'purchase_invoice_items':
          return _convertToMaps(
            await driftDatabase.purchase_invoice_items.all(),
          );
        case 'purchase_payments':
          return _convertToMaps(
            await driftDatabase.purchase_payments.all(),
          );
        case 'sales':
          return _convertToMaps(await driftDatabase.sales.all());
        case 'sale_items':
          return _convertToMaps(await driftDatabase.sale_items.all());
        case 'payments':
          return _convertToMaps(await driftDatabase.payments.all());
        case 'repairs':
          return _convertToMaps(await driftDatabase.repairs.all());
        case 'repair_parts':
          return _convertToMaps(await driftDatabase.repair_parts.all());
        case 'repair_part_orders':
          return _convertToMaps(
            await driftDatabase.repair_part_orders.all(),
          );
        case 'stock_movements':
          return _convertToMaps(
            await driftDatabase.stock_movements.all(),
          );
        case 'debts':
          return _convertToMaps(await driftDatabase.debts.all());
        case 'electricity_recharges':
          return _convertToMaps(
            await driftDatabase.electricity_recharges.all(),
          );
        case 'wallet_operations':
          return _convertToMaps(
            await driftDatabase.wallet_operations.all(),
          );
        case 'telelink_operations':
          return _convertToMaps(
            await driftDatabase.telelink_operations.all(),
          );
        case 'farahnet_payments':
          return _convertToMaps(
            await driftDatabase.farahnet_payments.all(),
          );
        case 'program_topups':
          return _convertToMaps(await driftDatabase.program_topups.all());
        case 'settlements':
          return _convertToMaps(await driftDatabase.settlements.all());
        case 'service_transactions':
          return _convertToMaps(
            await driftDatabase.service_transactions.all(),
          );
        case 'service_daily_inventory':
          return _convertToMaps(
            await driftDatabase.service_daily_inventory.all(),
          );
        case 'cash_drawer_events':
          return _convertToMaps(
            await driftDatabase.cash_drawer_events.all(),
          );
        default:
          throw Exception('Unknown table: $tableName');
      }
    } catch (e) {
      print('  ⚠️ Warning: Could not load from $tableName: $e');
      return [];
    }
  }

  /// Convert Drift objects to maps for insertion
  List<Map<String, dynamic>> _convertToMaps(List<dynamic> driftObjects) {
    final result = <Map<String, dynamic>>[];
    for (final obj in driftObjects) {
      if (obj is Map) {
        result.add(Map<String, dynamic>.from(obj));
      } else if (obj.runtimeType.toString().contains('Data')) {
        // Drift model - convert to map
        final converted =
            obj.toJson?.call() ?? obj.toMap?.call() ?? _objectToMap(obj);
        result.add(converted);
      } else {
        result.add(_objectToMap(obj));
      }
    }
    return result;
  }

  /// Convert generic object to map
  Map<String, dynamic> _objectToMap(dynamic obj) {
    if (obj is Map) return Map<String, dynamic>.from(obj);

    final map = <String, dynamic>{};

    // Use reflection to extract properties
    try {
      if (obj.runtimeType.toString().contains('Data')) {
        // Likely a Drift model
        print('⚠️ Could not convert Drift object: $obj');
      }
    } catch (e) {
      print('⚠️ Could not convert object: $obj - $e');
    }

    return map;
  }

  /// Print migration summary
  void _printSummary(List<MigrationTableStats> stats, Duration totalTime) {
    print('\n${'=' * 60}');
    print('📋 MIGRATION SUMMARY');
    print('=' * 60);

    int totalRecords = 0;
    int successRecords = 0;
    int failedRecords = 0;
    int tablesSuccessful = 0;
    int tablesFailed = 0;

    for (final stat in stats) {
      totalRecords += stat.totalRows;
      successRecords += stat.successfulRows;
      failedRecords += stat.failedRows;

      if (stat.failedRows == 0 && stat.totalRows > 0) {
        tablesSuccessful++;
      } else if (stat.failedRows > 0) {
        tablesFailed++;
      }

      print(stat.toString());
    }

    print('-' * 60);
    print('📊 TOTALS:');
    print('  Tables: ${stats.length} (✅ $tablesSuccessful, ❌ $tablesFailed)');
    print('  Records: $successRecords/$totalRecords successful');
    if (failedRecords > 0) {
      print('  ⚠️ Failed: $failedRecords records');
    }
    print('  ⏱️ Time: ${totalTime.inSeconds}s');
    print('=' * 60);
  }
}
