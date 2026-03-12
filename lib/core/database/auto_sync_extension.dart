import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../data/db/app_database.dart';
import '../sync/auto_sync_service.dart';

/// Extension on AppDatabase to add auto-sync capabilities
/// Wraps database operations with automatic Supabase synchronization
extension AutoSyncExtension on AppDatabase {
  /// Auto-sync service instance
  /// Should be set after database initialization
  static AutoSyncService? _syncService;

  /// Initialize auto-sync for this database
  static void initializeAutoSync(AppDatabase db) {
    _syncService = AutoSyncService(database: db);
    print('✅ Auto-sync initialized for database');
  }

  /// Get the auto-sync service
  AutoSyncService? get autoSync => _syncService;

  /// Check if auto-sync is available
  bool get isAutoSyncAvailable => _syncService?.isAvailable ?? false;

  /// Add product with auto-sync
  Future<int> addProductWithSync(ProductsCompanion product) async {
    final result = await into(products).insert(product);

    // Sync to Supabase
    if (_syncService != null) {
      final inserted = await (select(
        products,
      )..where((p) => p.id.equals(product.id.value))).getSingle();
      await _syncService!.syncProduct(inserted);
    }

    return result;
  }

  /// Update product with auto-sync
  Future<bool> updateProductWithSync(Product product) async {
    final result = await update(products).replace(product);

    // Sync to Supabase
    if (_syncService != null && result) {
      await _syncService!.syncProduct(product);
    }

    return result;
  }

  /// Delete product with auto-sync
  Future<int> deleteProductWithSync(String productId) async {
    int result = 0;
    
    await transaction(() async {
      // Delete all repair parts referencing this product
      await (delete(repairParts)
            ..where((rp) => rp.productId.equals(productId)))
          .go();

      // Delete all purchase items referencing this product
      await (delete(purchaseItems)
            ..where((pi) => pi.productId.equals(productId)))
          .go();

      // Delete all sale items referencing this product
      await (delete(saleItems)
            ..where((si) => si.productId.equals(productId)))
          .go();

      // Delete the product itself
      result = await (delete(products)
            ..where((p) => p.id.equals(productId)))
          .go();
    });

    // TODO: Re-enable Supabase sync in future
    // Sync deletion to Supabase
    // if (_syncService != null && result > 0) {
    //   await _syncService!.syncDelete('products', productId);
    // }

    return result;
  }

  /// Add customer with auto-sync
  Future<int> addCustomerWithSync(CustomersCompanion customer) async {
    final result = await into(customers).insert(customer);

    // Sync to Supabase
    if (_syncService != null) {
      final inserted = await (select(
        customers,
      )..where((c) => c.id.equals(customer.id.value))).getSingle();
      await _syncService!.syncCustomer(inserted);
    }

    return result;
  }

  /// Update customer with auto-sync
  Future<bool> updateCustomerWithSync(Customer customer) async {
    final result = await update(customers).replace(customer);

    // Sync to Supabase
    if (_syncService != null && result) {
      await _syncService!.syncCustomer(customer);
    }

    return result;
  }

  /// Add sale with auto-sync (including items)
  Future<String> addSaleWithSync({
    required String customerId,
    required int total,
    required int discount,
    required int paid,
    required String paymentType,
    required List<Map<String, dynamic>> items,
  }) async {
    String? saleId;

    await transaction(() async {
      // Create sale
      final saleCompanion = SalesCompanion.insert(
        id: const Uuid().v4(),
        customerId: drift.Value(customerId),
        total: total,
        discount: discount,
        paid: paid,
        paymentType: paymentType,
        createdAt: DateTime.now(),
      );
      saleId = await into(sales).insert(saleCompanion) as String;

      // Create sale items
      for (final itemMap in items) {
        final qty = itemMap['quantity'] as int;
        final unitPrice = itemMap['price'] as int;
        final saleItemCompanion = SaleItemsCompanion.insert(
          id: const Uuid().v4(),
          saleId: saleId!,
          productId: itemMap['productId'] as String,
          qty: qty,
          unitPrice: unitPrice,
          lineTotal: qty * unitPrice,
        );
        await into(saleItems).insert(saleItemCompanion);
      }
    });

    // Sync to Supabase
    if (_syncService != null && saleId != null) {
      final sale = await (select(
        sales,
      )..where((s) => s.id.equals(saleId!))).getSingle();
      final addedSaleItems = await (select(
        saleItems,
      )..where((si) => si.saleId.equals(saleId!))).get();
      await _syncService!.syncSale(sale, addedSaleItems);
    }

    return saleId!;
  }

  /// Add repair with auto-sync (including parts)
  Future<String> addRepairWithSync(
    RepairsCompanion repair,
    List<RepairPartsCompanion> parts,
  ) async {
    String? repairId;

    await transaction(() async {
      repairId = await into(repairs).insert(repair) as String;

      for (final part in parts) {
        await into(
          repairParts,
        ).insert(part.copyWith(repairId: drift.Value(repairId!)));
      }
    });

    // Sync to Supabase
    if (_syncService != null && repairId != null) {
      final addedRepair = await (select(
        repairs,
      )..where((r) => r.id.equals(repairId!))).getSingle();
      final addedParts = await (select(
        repairParts,
      )..where((rp) => rp.repairId.equals(repairId!))).get();
      await _syncService!.syncRepair(addedRepair, addedParts);
    }

    return repairId!;
  }

  /// Update repair with auto-sync
  Future<bool> updateRepairWithSync(
    Repair repair,
    List<RepairPart> parts,
  ) async {
    final result = await update(repairs).replace(repair);

    // Sync to Supabase
    if (_syncService != null && result) {
      await _syncService!.syncRepair(repair, parts);
    }

    return result;
  }

  /// Add supplier with auto-sync
  Future<int> addSupplierWithSync(SuppliersCompanion supplier) async {
    final result = await into(suppliers).insert(supplier);

    // Sync to Supabase
    if (_syncService != null) {
      final inserted = await (select(
        suppliers,
      )..where((s) => s.id.equals(supplier.id.value))).getSingle();
      await _syncService!.syncSupplier(inserted);
    }

    return result;
  }

  /// Add payment with auto-sync
  Future<int> addPaymentWithSync(PaymentsCompanion payment) async {
    final result = await into(payments).insert(payment);

    // Sync to Supabase
    if (_syncService != null) {
      final inserted = await (select(
        payments,
      )..where((p) => p.id.equals(payment.id.value))).getSingle();
      await _syncService!.syncPayment(inserted);
    }

    return result;
  }

  /// Add debt with auto-sync
  Future<int> addDebtWithSync(DebtsCompanion debt) async {
    final result = await into(debts).insert(debt);

    // Sync to Supabase
    if (_syncService != null) {
      final inserted = await (select(
        debts,
      )..where((d) => d.id.equals(debt.id.value))).getSingle();
      await _syncService!.syncDebt(inserted);
    }

    return result;
  }

  /// Update debt with auto-sync
  Future<bool> updateDebtWithSync(Debt debt) async {
    final result = await update(debts).replace(debt);

    // Sync to Supabase
    if (_syncService != null && result) {
      await _syncService!.syncDebt(debt);
    }

    return result;
  }
}
