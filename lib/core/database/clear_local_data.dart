import '../../data/db/app_database.dart';

/// Clears all data from local SQLite database
/// Keeps table structure intact, only deletes data
class LocalDataClearer {
  final AppDatabase db;

  LocalDataClearer(this.db);

  /// Clear all data from all tables in correct order (respecting FK constraints)
  Future<void> clearAllData() async {
    print('🗑️  Starting local database data clearing...');

    try {
      await db.transaction(() async {
        // ========================================================================
        // CHILD TABLES (with FK dependencies) - Delete first
        // ========================================================================

        print('   Clearing repair_parts...');
        await db.delete(db.repairParts).go();

        print('   Clearing repair_part_orders...');
        await db.delete(db.repairPartOrders).go();

        print('   Clearing sale_items...');
        await db.delete(db.saleItems).go();

        print('   Clearing purchase_items...');
        await db.delete(db.purchaseItems).go();

        print('   Clearing purchase_invoice_items...');
        await db.delete(db.purchaseInvoiceItems).go();

        print('   Clearing purchase_payments...');
        await db.delete(db.purchasePayments).go();

        print('   Clearing service_transactions...');
        await db.delete(db.serviceTransactions).go();

        print('   Clearing stock_movements...');
        await db.delete(db.stockMovements).go();

        print('   Clearing debts...');
        await db.delete(db.debts).go();

        print('   Clearing payments...');
        await db.delete(db.payments).go();

        // ========================================================================
        // PARENT TABLES (referenced by others)
        // ========================================================================

        print('   Clearing repairs...');
        await db.delete(db.repairs).go();

        print('   Clearing sales...');
        await db.delete(db.sales).go();

        print('   Clearing purchases...');
        await db.delete(db.purchases).go();

        print('   Clearing purchase_invoices...');
        await db.delete(db.purchaseInvoices).go();

        print('   Clearing products...');
        await db.delete(db.products).go();

        print('   Clearing customers...');
        await db.delete(db.customers).go();

        print('   Clearing suppliers...');
        await db.delete(db.suppliers).go();

        // ========================================================================
        // STANDALONE TABLES (no FK dependencies)
        // ========================================================================

        print('   Clearing electricity_recharges...');
        await db.delete(db.electricityRecharges).go();

        print('   Clearing wallet_operations...');
        await db.delete(db.walletOperations).go();

        print('   Clearing telelink_operations...');
        await db.delete(db.telelinkOperations).go();

        print('   Clearing farahnet_payments...');
        await db.delete(db.farahnetPayments).go();

        print('   Clearing program_topups...');
        await db.delete(db.programTopups).go();

        print('   Clearing settlements...');
        await db.delete(db.settlements).go();

        print('   Clearing service_daily_inventory...');
        await db.delete(db.serviceDailyInventory).go();

        print('   Clearing cash_drawer_events...');
        await db.delete(db.cashDrawerEvents).go();

        print('✅ All local data cleared successfully!');
      });
    } catch (e, stackTrace) {
      print('❌ Error clearing local data: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Verify all tables are empty
  Future<Map<String, int>> verifyDataCleared() async {
    final counts = <String, int>{};

    counts['suppliers'] = await db
        .select(db.suppliers)
        .get()
        .then((rows) => rows.length);
    counts['products'] = await db
        .select(db.products)
        .get()
        .then((rows) => rows.length);
    counts['customers'] = await db
        .select(db.customers)
        .get()
        .then((rows) => rows.length);
    counts['purchases'] = await db
        .select(db.purchases)
        .get()
        .then((rows) => rows.length);
    counts['sales'] = await db
        .select(db.sales)
        .get()
        .then((rows) => rows.length);
    counts['repairs'] = await db
        .select(db.repairs)
        .get()
        .then((rows) => rows.length);
    counts['debts'] = await db
        .select(db.debts)
        .get()
        .then((rows) => rows.length);
    counts['payments'] = await db
        .select(db.payments)
        .get()
        .then((rows) => rows.length);
    counts['stock_movements'] = await db
        .select(db.stockMovements)
        .get()
        .then((rows) => rows.length);

    return counts;
  }
}
