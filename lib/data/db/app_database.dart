import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables/customers.dart';
import 'tables/debts.dart';
import 'tables/payments.dart';
import 'tables/products.dart';
import 'tables/purchase_invoices.dart';
import 'tables/purchase_invoice_items.dart';
import 'tables/purchases.dart';
import 'tables/purchase_items.dart';
import 'tables/purchase_payments.dart';
import 'tables/repair_parts.dart';
import 'tables/repairs.dart';
import 'tables/sale_items.dart';
import 'tables/sales.dart';
import 'tables/stock_movements.dart';
import 'tables/suppliers.dart';
import 'tables/electricity_recharges.dart';
import 'tables/wallet_operations.dart';
import 'tables/telelink_operations.dart';
import 'tables/farahnet_payments.dart';
import 'tables/program_topups.dart';
import 'tables/settlements.dart';
import 'tables/repair_part_orders.dart';
import 'tables/service_transactions.dart';
import 'tables/cash_drawer_events.dart';
import 'tables/service_daily_inventory.dart';

part 'app_database.g.dart';

const _databaseFileName = 'pos_store.sqlite';

LazyDatabase _openConnection({String? databaseDirectoryPath}) {
  return LazyDatabase(() async {
    try {
      final directory =
          (databaseDirectoryPath != null &&
              databaseDirectoryPath.trim().isNotEmpty)
          ? Directory(databaseDirectoryPath)
          : await getApplicationDocumentsDirectory();
      // Ensure directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final dbPath = p.join(directory.path, _databaseFileName);
      final dbFile = File(dbPath);

      print('Database path: $dbPath');
      print('Database exists: ${await dbFile.exists()}');

      return NativeDatabase.createInBackground(dbFile);
    } catch (e, stack) {
      print('Error opening database: $e');
      print('Stack trace: $stack');

      // If it's a migration error, delete the old database and retry
      if (e.toString().contains('no such column') ||
          e.toString().contains('SQL logic error')) {
        try {
          final directory =
              (databaseDirectoryPath != null &&
                  databaseDirectoryPath.trim().isNotEmpty)
              ? Directory(databaseDirectoryPath)
              : await getApplicationDocumentsDirectory();
          final dbPath = p.join(directory.path, _databaseFileName);
          final dbFile = File(dbPath);
          if (await dbFile.exists()) {
            print('Deleting corrupted database and recreating...');
            await dbFile.delete();
          }
          // Retry opening
          return NativeDatabase.createInBackground(dbFile);
        } catch (retryError) {
          print('Error during database recovery: $retryError');
          rethrow;
        }
      }
      rethrow;
    }
  });
}

@DriftDatabase(
  tables: [
    Products,
    Customers,
    Payments,
    Sales,
    SaleItems,
    PurchaseInvoices,
    PurchaseInvoiceItems,
    Suppliers,
    Purchases,
    PurchaseItems,
    PurchasePayments,
    Repairs,
    RepairParts,
    StockMovements,
    Debts,
    ElectricityRecharges,
    WalletOperations,
    TelelinkOperations,
    FarahnetPayments,
    ProgramTopups,
    Settlements,
    RepairPartOrders,
    ServiceTransactions,
    CashDrawerEvents,
    ServiceDailyInventory,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({String? databaseDirectoryPath})
    : super(_openConnection(databaseDirectoryPath: databaseDirectoryPath));
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(purchaseInvoices);
          await m.createTable(purchaseInvoiceItems);
        }
        if (from < 3) {
          await m.addColumn(products, products.imagePath);
        }
        if (from < 4) {
          await m.createTable(suppliers);
          await m.createTable(purchases);
          await m.createTable(purchaseItems);
        }
        if (from < 5) {
          // Update repairs table with new columns
          await m.addColumn(repairs, repairs.customerName);
          await m.addColumn(repairs, repairs.customerPhone);
          await m.addColumn(repairs, repairs.finalCost);
          await m.addColumn(repairs, repairs.discount);
          await m.addColumn(repairs, repairs.paidAtReceive);
          await m.addColumn(repairs, repairs.paidAtDelivery);
          await m.addColumn(repairs, repairs.totalPaid);
          // Create debts table
          await m.createTable(debts);
        }
        if (from < 6) {
          // Version 6: Add supplier tracking and recharge/program features
          // Note: New installs will get all tables from schema.
          // Existing databases will get migrated here.
          // For now, we skip explicit migration - Drift will handle schema generation
        }
        if (from < 7) {
          // Version 7: Add unified service transactions and cash drawer events
          await m.createTable(serviceTransactions);
          await m.createTable(cashDrawerEvents);
        }
        if (from < 8) {
          // Version 8: Add supplier_id to products, remove pattern from repairs
          await m.addColumn(products, products.supplierId);
        }
        if (from < 9) {
          // Version 9: Add purchase payments tracking
          await m.createTable(purchasePayments);
        }
        if (from < 10) {
          // Version 10: Make purchaseId nullable in purchase_payments
          // Recreate table with nullable purchaseId
          await m.deleteTable('purchase_payments');
          await m.createTable(purchasePayments);
        }
        if (from < 11) {
          // Version 11: Add saleId to service_transactions for linking with POS sales
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.saleId as GeneratedColumn,
          );
        }
        if (from < 12) {
          // Version 12: Add profitCents to service_transactions and create service_daily_inventory
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.profitCents as GeneratedColumn,
          );
          await m.createTable(serviceDailyInventory);
        }
        if (from < 13) {
          // Version 13: Add enhanced profit tracking columns to service_transactions
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.serviceType as GeneratedColumn,
          );
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.providerCostCents as GeneratedColumn,
          );
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.profitBaseCents as GeneratedColumn,
          );
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.bonusProfitCents as GeneratedColumn,
          );
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.finalProfitCents as GeneratedColumn,
          );
          await m.addColumn(
            serviceTransactions,
            serviceTransactions.profitPercent as GeneratedColumn,
          );
        }
        if (from < 14) {
          // Version 14: Add transaction reversal support (status and reversedAt)
          // Note: Column additions handled in beforeOpen to avoid duplicate column errors
        }
      },
      beforeOpen: (details) async {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS supplier_requested_products (
            id TEXT PRIMARY KEY,
            supplier_id TEXT NOT NULL,
            product_name TEXT NOT NULL,
            requested_qty INTEGER NOT NULL DEFAULT 1,
            customer_note TEXT,
            status TEXT NOT NULL DEFAULT 'pending',
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_supplier_requested_products_supplier ON supplier_requested_products(supplier_id, status, created_at)',
        );
        await customStatement('''
          CREATE TABLE IF NOT EXISTS missing_products_notes (
            id TEXT PRIMARY KEY,
            item_name TEXT NOT NULL,
            requested_qty INTEGER NOT NULL DEFAULT 1,
            customer_note TEXT,
            status TEXT NOT NULL DEFAULT 'open',
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_missing_products_notes_status ON missing_products_notes(status, created_at)',
        );

        // Ensure missing columns exist for legacy databases.
        final supplierIdColumns = await customSelect(
          "SELECT name FROM pragma_table_info('products') WHERE name = 'supplier_id'",
        ).get();
        if (supplierIdColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE products ADD COLUMN supplier_id TEXT',
          );
        }

        // Ensure transaction reversal columns exist (version 14)
        final salesStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('sales') WHERE name = 'status'",
        ).get();
        if (salesStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE sales ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final salesReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('sales') WHERE name = 'reversed_at'",
        ).get();
        if (salesReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE sales ADD COLUMN reversed_at INTEGER',
          );
        }

        final repairsStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('repairs') WHERE name = 'transaction_status'",
        ).get();
        if (repairsStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE repairs ADD COLUMN transaction_status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final repairsReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('repairs') WHERE name = 'reversed_at'",
        ).get();
        if (repairsReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE repairs ADD COLUMN reversed_at INTEGER',
          );
        }

        final serviceTransactionsStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('service_transactions') WHERE name = 'status'",
        ).get();
        if (serviceTransactionsStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE service_transactions ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final serviceTransactionsReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('service_transactions') WHERE name = 'reversed_at'",
        ).get();
        if (serviceTransactionsReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE service_transactions ADD COLUMN reversed_at INTEGER',
          );
        }

        final telelinkStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('telelink_operations') WHERE name = 'status'",
        ).get();
        if (telelinkStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE telelink_operations ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final telelinkReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('telelink_operations') WHERE name = 'reversed_at'",
        ).get();
        if (telelinkReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE telelink_operations ADD COLUMN reversed_at INTEGER',
          );
        }

        final electricityStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('electricity_recharges') WHERE name = 'status'",
        ).get();
        if (electricityStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE electricity_recharges ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final electricityReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('electricity_recharges') WHERE name = 'reversed_at'",
        ).get();
        if (electricityReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE electricity_recharges ADD COLUMN reversed_at INTEGER',
          );
        }

        final programTopupsStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('program_topups') WHERE name = 'status'",
        ).get();
        if (programTopupsStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE program_topups ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final programTopupsReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('program_topups') WHERE name = 'reversed_at'",
        ).get();
        if (programTopupsReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE program_topups ADD COLUMN reversed_at INTEGER',
          );
        }

        final farahnetStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('farahnet_payments') WHERE name = 'status'",
        ).get();
        if (farahnetStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE farahnet_payments ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final farahnetReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('farahnet_payments') WHERE name = 'reversed_at'",
        ).get();
        if (farahnetReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE farahnet_payments ADD COLUMN reversed_at INTEGER',
          );
        }

        final walletStatusColumns = await customSelect(
          "SELECT name FROM pragma_table_info('wallet_operations') WHERE name = 'status'",
        ).get();
        if (walletStatusColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE wallet_operations ADD COLUMN status TEXT NOT NULL DEFAULT \'normal\'',
          );
        }

        final walletReversedAtColumns = await customSelect(
          "SELECT name FROM pragma_table_info('wallet_operations') WHERE name = 'reversed_at'",
        ).get();
        if (walletReversedAtColumns.isEmpty) {
          await customStatement(
            'ALTER TABLE wallet_operations ADD COLUMN reversed_at INTEGER',
          );
        }
      },
    );
  }

  Future<int> addProduct({
    required String id,
    required String name,
    String? barcode,
    required String category,
    required int sellPrice,
    required int costPrice,
    required int qty,
    required bool trackImei,
    String? imagePath,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();

    return transaction(() async {
      final result = await into(products).insert(
        ProductsCompanion.insert(
          id: id,
          name: name,
          barcode: Value(barcode),
          category: category,
          sellPrice: sellPrice,
          costPrice: costPrice,
          qty: qty,
          trackImei: trackImei,
          imagePath: Value(imagePath),
          createdAt: now,
        ),
      );

      await into(stockMovements).insert(
        StockMovementsCompanion.insert(
          id: const Uuid().v4(),
          productId: id,
          type: 'in',
          qtyDelta: qty,
          reason: 'initial',
          refId: const Value(null),
          createdAt: now,
        ),
      );

      return result;
    });
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    String? barcode,
    required String category,
    required int sellPrice,
    required int costPrice,
    required bool trackImei,
    String? imagePath,
  }) async {
    await (update(products)..where((tbl) => tbl.id.equals(id))).write(
      ProductsCompanion(
        name: Value(name),
        barcode: Value(barcode),
        category: Value(category),
        sellPrice: Value(sellPrice),
        costPrice: Value(costPrice),
        trackImei: Value(trackImei),
        imagePath: Value(imagePath),
      ),
    );
  }

  Future<void> adjustStock({
    required String productId,
    required int deltaQty,
    required String reason,
    DateTime? createdAt,
  }) async {
    if (deltaQty == 0) {
      return;
    }

    final now = createdAt ?? DateTime.now();

    await transaction(() async {
      final product = await (select(
        products,
      )..where((tbl) => tbl.id.equals(productId))).getSingleOrNull();

      if (product == null) {
        throw StateError('Product not found: $productId');
      }

      final newQty = product.qty + deltaQty;
      if (newQty < 0) {
        throw StateError('Stock cannot be negative');
      }

      await (update(products)..where((tbl) => tbl.id.equals(productId))).write(
        ProductsCompanion(qty: Value(newQty)),
      );

      await into(stockMovements).insert(
        StockMovementsCompanion.insert(
          id: const Uuid().v4(),
          productId: productId,
          type: deltaQty > 0 ? 'in' : 'out',
          qtyDelta: deltaQty,
          reason: reason,
          refId: const Value(null),
          createdAt: now,
        ),
      );
    });
  }

  Future<List<Product>> searchProducts(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return select(products).get();
    }

    final likeTerm = '%$trimmed%';
    return (select(products)..where(
          (tbl) =>
              tbl.name.like(likeTerm) |
              (tbl.barcode.isNotNull() & tbl.barcode.like(likeTerm)),
        ))
        .get();
  }

  /// Get total product count (for checking if database is empty)
  Future<int> getProductCount() async {
    final query = selectOnly(products)..addColumns([products.id.count()]);
    final result = await query.getSingle();
    return result.read(products.id.count()) ?? 0;
  }

  Future<void> createSaleWithItems({
    required String saleId,
    String? customerId,
    required int total,
    required int discount,
    required int paid,
    required String paymentType,
    required List<SaleItemInput> items,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();

    return transaction(() async {
      await into(sales).insert(
        SalesCompanion.insert(
          id: saleId,
          customerId: Value(customerId),
          total: total,
          discount: discount,
          paid: paid,
          paymentType: paymentType,
          createdAt: now,
        ),
      );

      for (final item in items) {
        await into(saleItems).insert(
          SaleItemsCompanion.insert(
            id: item.id,
            saleId: saleId,
            productId: item.productId,
            qty: item.qty,
            unitPrice: item.unitPrice,
            lineTotal: item.lineTotal,
          ),
        );
      }

      if (customerId != null) {
        final delta = total - paid;
        if (delta != 0) {
          final customer = await (select(
            customers,
          )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();
          if (customer != null) {
            await (update(
              customers,
            )..where((tbl) => tbl.id.equals(customerId))).write(
              CustomersCompanion(balance: Value(customer.balance + delta)),
            );

            // Create debt entry if remaining amount
            if (delta > 0) {
              await createDebtForCreditSale(
                saleId: saleId,
                customerId: customerId,
                customerName: customer.name,
                customerPhone: customer.phone,
                remaining: delta,
                note: 'Sale ${saleId.substring(0, 6)}',
              );
            }
          }
        }
      }
    });
  }

  Future<String> checkoutSale({
    required List<SaleCheckoutItem> items,
    String? customerId,
    required int discount,
    required int paid,
    required String paymentType,
    DateTime? createdAt,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('Cart is empty');
    }

    final now = createdAt ?? DateTime.now();
    final subtotal = items.fold<int>(
      0,
      (sum, item) => sum + (item.qty * item.unitPrice),
    );
    final total = subtotal - discount;
    final saleId = const Uuid().v4();
    final productIds = items.map((item) => item.productId).toList();

    final productRows = await (select(
      products,
    )..where((tbl) => tbl.id.isIn(productIds))).get();
    final productMap = {for (final product in productRows) product.id: product};

    for (final item in items) {
      if (!productMap.containsKey(item.productId)) {
        throw StateError('Product not found: ${item.productId}');
      }
    }

    await transaction(() async {
      await into(sales).insert(
        SalesCompanion.insert(
          id: saleId,
          customerId: Value(customerId),
          total: total,
          discount: discount,
          paid: paid,
          paymentType: paymentType,
          createdAt: now,
        ),
      );

      for (final item in items) {
        final product = productMap[item.productId]!;
        final lineTotal = item.qty * item.unitPrice;
        final saleItemId = const Uuid().v4();

        await into(saleItems).insert(
          SaleItemsCompanion.insert(
            id: saleItemId,
            saleId: saleId,
            productId: item.productId,
            qty: item.qty,
            unitPrice: item.unitPrice,
            lineTotal: lineTotal,
          ),
        );

        final newQty = product.qty - item.qty;
        await (update(products)..where((tbl) => tbl.id.equals(item.productId)))
            .write(ProductsCompanion(qty: Value(newQty)));

        await into(stockMovements).insert(
          StockMovementsCompanion.insert(
            id: const Uuid().v4(),
            productId: item.productId,
            type: 'out',
            qtyDelta: -item.qty,
            reason: 'sale',
            refId: Value(saleId),
            createdAt: now,
          ),
        );
      }

      if (customerId != null) {
        final delta = total - paid;
        if (delta != 0) {
          final customer = await (select(
            customers,
          )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();
          if (customer != null) {
            await (update(
              customers,
            )..where((tbl) => tbl.id.equals(customerId))).write(
              CustomersCompanion(balance: Value(customer.balance + delta)),
            );

            // Create debt entry if remaining amount
            if (delta > 0) {
              // Build items summary for note
              final itemNames = items
                  .map((item) {
                    final product = productMap[item.productId];
                    return '${product?.name ?? 'Unknown'} x${item.qty}';
                  })
                  .join(', ');

              await createDebtForCreditSale(
                saleId: saleId,
                customerId: customerId,
                customerName: customer.name,
                customerPhone: customer.phone,
                remaining: delta,
                note: itemNames,
              );
            }
          }
        }
      }
    });

    return saleId;
  }

  Future<List<Repair>> getRepairs({String? status}) {
    final query = select(repairs)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);

    if (status != null && status != 'All') {
      query.where((tbl) => tbl.status.equals(status));
    }

    return query.get();
  }

  Future<String> upsertCustomer({
    String? id,
    required String name,
    String? phone,
  }) async {
    final now = DateTime.now();
    final customerId = id ?? const Uuid().v4();

    await transaction(() async {
      final existing = await (select(
        customers,
      )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();

      if (existing == null) {
        await into(customers).insert(
          CustomersCompanion.insert(
            id: customerId,
            name: name,
            phone: Value(phone),
            balance: const Value(0),
            createdAt: now,
          ),
        );
      } else {
        await (update(customers)..where((tbl) => tbl.id.equals(customerId)))
            .write(CustomersCompanion(name: Value(name), phone: Value(phone)));
      }
    });

    return customerId;
  }

  Future<List<Customer>> searchCustomers(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return select(customers).get();
    }

    final likeTerm = '%$trimmed%';
    return (select(customers)..where(
          (tbl) =>
              tbl.name.like(likeTerm) |
              (tbl.phone.isNotNull() & tbl.phone.like(likeTerm)),
        ))
        .get();
  }

  Future<Customer?> getCustomerById(String customerId) {
    return (select(
      customers,
    )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();
  }

  Stream<List<Customer>> watchCustomers(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return (select(customers)..orderBy([
            (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
          ]))
          .watch();
    }

    final likeTerm = '%$trimmed%';
    return (select(customers)
          ..where(
            (tbl) =>
                tbl.name.like(likeTerm) |
                (tbl.phone.isNotNull() & tbl.phone.like(likeTerm)),
          )
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Future<void> recordPayment({
    required String customerId,
    required int amountCents,
    required String direction,
    String? note,
    DateTime? createdAt,
  }) async {
    if (amountCents <= 0) {
      throw ArgumentError('Amount must be positive');
    }

    final now = createdAt ?? DateTime.now();
    final delta = direction == 'receive' ? -amountCents : amountCents;

    await transaction(() async {
      final customer = await (select(
        customers,
      )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();

      if (customer == null) {
        throw StateError('Customer not found: $customerId');
      }

      await (update(customers)..where((tbl) => tbl.id.equals(customerId)))
          .write(CustomersCompanion(balance: Value(customer.balance + delta)));

      await into(payments).insert(
        PaymentsCompanion.insert(
          id: const Uuid().v4(),
          customerId: customerId,
          amount: amountCents,
          direction: direction,
          note: Value(note),
          createdAt: now,
        ),
      );
    });
  }

  Future<int> getCustomerSalesCount(String customerId) async {
    final result = await (select(
      sales,
    )..where((tbl) => tbl.customerId.equals(customerId))).get();
    return result.length;
  }

  Future<int> getCustomerTotalPurchasesCents(String customerId) async {
    final result = await (select(
      sales,
    )..where((tbl) => tbl.customerId.equals(customerId))).get();
    var total = 0;
    for (final sale in result) {
      total += sale.total;
    }
    return total;
  }

  Future<List<Sale>> getRecentSalesForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return (select(sales)
          ..where((tbl) => tbl.customerId.equals(customerId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<Repair>> getRecentRepairsForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return (select(repairs)
          ..where((tbl) => tbl.customerId.equals(customerId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<Payment>> getRecentPaymentsForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return (select(payments)
          ..where((tbl) => tbl.customerId.equals(customerId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<RepairPartWithProduct>> getRepairParts(String repairId) async {
    try {
      final query = select(repairParts).join([
        innerJoin(products, products.id.equalsExp(repairParts.productId)),
      ])..where(repairParts.repairId.equals(repairId));

      final rows = await query.get();
      return rows
          .map(
            (row) => RepairPartWithProduct(
              repairPart: row.readTable(repairParts),
              product: row.readTable(products),
            ),
          )
          .toList();
    } catch (e) {
      // If it's a migration/schema error, delete the database
      if (e.toString().contains('no such column') ||
          e.toString().contains('SQL logic error')) {
        try {
          print('Schema mismatch detected. Cleaning up database...');
          final directory = await getApplicationDocumentsDirectory();
          final dbPath = p.join(directory.path, 'pos_store.sqlite');
          final dbFile = File(dbPath);
          if (await dbFile.exists()) {
            await dbFile.delete();
            print('Database deleted. Please restart the app.');
          }
        } catch (cleanupError) {
          print('Error during cleanup: $cleanupError');
        }
      }
      rethrow;
    }
  }

  Future<SalesSummary> getSalesSummary(DateTime from, DateTime to) async {
    final rows =
        await (select(sales)..where(
              (tbl) =>
                  tbl.createdAt.isBetweenValues(from, to) &
                  tbl.status.equals('normal'),
            ))
            .get();

    var totalAmount = 0;
    var cashTotal = 0;
    var cardTotal = 0;
    var transferTotal = 0;
    var creditTotal = 0;

    for (final sale in rows) {
      totalAmount += sale.total;
      switch (sale.paymentType) {
        case 'Cash':
          cashTotal += sale.total;
          break;
        case 'Card':
          cardTotal += sale.total;
          break;
        case 'Transfer':
          transferTotal += sale.total;
          break;
        case 'Credit':
          creditTotal += sale.total;
          break;
        default:
          break;
      }
    }

    return SalesSummary(
      totalAmount: totalAmount,
      salesCount: rows.length,
      cashTotal: cashTotal,
      cardTotal: cardTotal,
      transferTotal: transferTotal,
      creditTotal: creditTotal,
    );
  }

  Future<ProfitSummary> getProfitSummary(DateTime from, DateTime to) async {
    final query =
        select(saleItems).join([
          innerJoin(sales, sales.id.equalsExp(saleItems.saleId)),
          innerJoin(products, products.id.equalsExp(saleItems.productId)),
        ])..where(
          sales.createdAt.isBetweenValues(from, to) &
              sales.status.equals('normal'),
        );

    final rows = await query.get();
    var productsProfit = 0;
    for (final row in rows) {
      final item = row.readTable(saleItems);
      final product = row.readTable(products);
      productsProfit += (item.unitPrice - product.costPrice) * item.qty;
    }

    // Subtract all discounts from the profit
    final salesList =
        await (select(sales)..where(
              (s) =>
                  s.createdAt.isBetweenValues(from, to) &
                  s.status.equals('normal'),
            ))
            .get();
    final totalDiscounts = salesList.fold<int>(
      0,
      (sum, sale) => sum + sale.discount,
    );
    productsProfit -= totalDiscounts;

    final serviceRows =
        await (select(serviceTransactions)..where(
              (tbl) =>
                  tbl.createdAt.isBetweenValues(from, to) &
                  tbl.status.equals('normal'),
            ))
            .get();
    final servicesProfit = serviceRows.fold<int>(
      0,
      (sum, tx) => sum + (tx.profitCents ?? 0),
    );

    final totalProfit = productsProfit + servicesProfit;

    return ProfitSummary(approximateProfit: totalProfit);
  }

  Future<List<ServiceDailyInventoryData>> getDailyInventory(DateTime date) {
    // Normalize to midnight
    final startOfDay = DateTime(date.year, date.month, date.day);
    return (select(
      serviceDailyInventory,
    )..where((tbl) => tbl.date.equals(startOfDay))).get();
  }

  Future<void> upsertDailyInventory({
    required DateTime date,
    required String provider,
    int? openingBalanceCents,
    int? closingBalanceCents,
    String? notes,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final id =
        '${startOfDay.millisecondsSinceEpoch}_$provider'; // Simple ID generation

    await transaction(() async {
      final existing = await (select(
        serviceDailyInventory,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

      if (existing == null) {
        await into(serviceDailyInventory).insert(
          ServiceDailyInventoryCompanion.insert(
            id: id,
            date: startOfDay,
            provider: provider,
            openingBalanceCents: Value(openingBalanceCents ?? 0),
            closingBalanceCents: Value(closingBalanceCents ?? 0),
            notes: Value(notes),
          ),
        );
      } else {
        await (update(
          serviceDailyInventory,
        )..where((tbl) => tbl.id.equals(id))).write(
          ServiceDailyInventoryCompanion(
            openingBalanceCents: openingBalanceCents != null
                ? Value(openingBalanceCents)
                : const Value.absent(),
            closingBalanceCents: closingBalanceCents != null
                ? Value(closingBalanceCents)
                : const Value.absent(),
            notes: notes != null ? Value(notes) : const Value.absent(),
          ),
        );
      }
    });
  }

  Future<List<ServiceTransaction>> getServiceTransactionsForDate(
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(serviceTransactions)
          ..where(
            (tbl) =>
                tbl.createdAt.isBetweenValues(startOfDay, endOfDay) &
                tbl.status.equals('normal'),
          )
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  Future<RepairStats> getRepairStats(
    DateTime from,
    DateTime to, {
    int overdueDays = 3,
  }) async {
    final rows = await (select(
      repairs,
    )..where((tbl) => tbl.createdAt.isBetweenValues(from, to))).get();

    final readyCount = rows.where((repair) => repair.status == 'Ready').length;
    final deliveredCount = rows
        .where((repair) => repair.status == 'Delivered')
        .length;
    final overdueThreshold = DateTime.now().subtract(
      Duration(days: overdueDays),
    );
    final overdueCount = rows
        .where(
          (repair) =>
              repair.status != 'Delivered' &&
              repair.createdAt.isBefore(overdueThreshold),
        )
        .length;

    return RepairStats(
      total: rows.length,
      readyCount: readyCount,
      deliveredCount: deliveredCount,
      overdueCount: overdueCount,
    );
  }

  Future<List<TopPartUsage>> getTopRepairParts(
    DateTime from,
    DateTime to, {
    int limit = 10,
  }) async {
    final query = select(repairParts).join([
      innerJoin(repairs, repairs.id.equalsExp(repairParts.repairId)),
      innerJoin(products, products.id.equalsExp(repairParts.productId)),
    ])..where(repairs.createdAt.isBetweenValues(from, to));

    final rows = await query.get();
    final totals = <String, TopPartUsage>{};

    for (final row in rows) {
      final part = row.readTable(repairParts);
      final product = row.readTable(products);
      final existing = totals[product.id];
      if (existing == null) {
        totals[product.id] = TopPartUsage(
          productId: product.id,
          productName: product.name,
          totalQty: part.qty,
        );
      } else {
        totals[product.id] = existing.copyWith(
          totalQty: existing.totalQty + part.qty,
        );
      }
    }

    final result = totals.values.toList()
      ..sort((a, b) => b.totalQty.compareTo(a.totalQty));

    if (result.length > limit) {
      return result.sublist(0, limit);
    }
    return result;
  }

  // Dashboard Queries

  Future<int> getOpenRepairsCount() async {
    final result =
        await (select(repairs)..where(
              (tbl) =>
                  tbl.status.isNotIn(['Delivered', 'Completed', 'Cancelled']),
            ))
            .get();
    return result.length;
  }

  Future<List<Product>> getLowStockProducts(int threshold) {
    return (select(products)
          ..where((tbl) => tbl.qty.isSmallerOrEqualValue(threshold))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.qty, mode: OrderingMode.asc),
          ])
          ..limit(5))
        .get();
  }

  Future<int> getLowStockCount(int threshold) async {
    final result = await (select(
      products,
    )..where((tbl) => tbl.qty.isSmallerOrEqualValue(threshold))).get();
    return result.length;
  }

  Future<int> getWithdrawnPartsCapital(DateTime from, DateTime to) async {
    final rows =
        await (select(stockMovements).join([
              innerJoin(
                products,
                products.id.equalsExp(stockMovements.productId),
              ),
            ])..where(
              stockMovements.type.equals('out') &
                  stockMovements.createdAt.isBetweenValues(from, to),
            ))
            .get();

    var totalCapital = 0;
    for (final row in rows) {
      final movement = row.readTable(stockMovements);
      final product = row.readTable(products);
      totalCapital += movement.qtyDelta.abs() * product.costPrice;
    }

    return totalCapital;
  }

  Future<List<Repair>> getOverdueRepairs(DateTime threshold) {
    return (select(repairs)
          ..where(
            (tbl) =>
                tbl.status.isNotIn(['Delivered', 'Completed', 'Cancelled']) &
                tbl.createdAt.isSmallerThanValue(threshold),
          )
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.asc),
          ])
          ..limit(5))
        .get();
  }

  Future<List<Sale>> getRecentSales({int limit = 10}) {
    return (select(sales)
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<Repair>> getRecentRepairs({int limit = 10}) {
    return (select(repairs)
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  Future<void> seedSampleData() async {
    final uuid = const Uuid();
    final now = DateTime.now();

    final samples = <ProductsCompanion>[
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'USB-C 25W Charger',
        barcode: const Value('CHG-25W'),
        category: 'Chargers',
        sellPrice: 1999,
        costPrice: 1100,
        qty: 40,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'USB-C 45W Charger',
        barcode: const Value('CHG-45W'),
        category: 'Chargers',
        sellPrice: 2999,
        costPrice: 1700,
        qty: 25,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'USB-C to USB-C Cable 1m',
        barcode: const Value('CBL-C2C-1M'),
        category: 'Cables',
        sellPrice: 999,
        costPrice: 450,
        qty: 60,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Lightning Cable 1m',
        barcode: const Value('CBL-LTN-1M'),
        category: 'Cables',
        sellPrice: 1299,
        costPrice: 600,
        qty: 55,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Micro-USB Cable 1m',
        barcode: const Value('CBL-MIC-1M'),
        category: 'Cables',
        sellPrice: 699,
        costPrice: 300,
        qty: 70,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Wireless Earbuds Basic',
        barcode: const Value('EAR-TWS-BASIC'),
        category: 'Earbuds',
        sellPrice: 2999,
        costPrice: 1800,
        qty: 35,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Wired Earbuds',
        barcode: const Value('EAR-WIRED'),
        category: 'Earbuds',
        sellPrice: 899,
        costPrice: 400,
        qty: 80,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Over-Ear Headphones',
        barcode: const Value('HD-OVER'),
        category: 'Headphones',
        sellPrice: 4999,
        costPrice: 3000,
        qty: 20,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Bluetooth On-Ear',
        barcode: const Value('HD-ON'),
        category: 'Headphones',
        sellPrice: 3799,
        costPrice: 2400,
        qty: 22,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'iPhone 11 Screen',
        barcode: const Value('SCR-IP11'),
        category: 'Screens',
        sellPrice: 8999,
        costPrice: 6500,
        qty: 12,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Galaxy S20 Screen',
        barcode: const Value('SCR-S20'),
        category: 'Screens',
        sellPrice: 9499,
        costPrice: 6800,
        qty: 10,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'USB-C Charging Port',
        barcode: const Value('PORT-USBC'),
        category: 'Charging Ports',
        sellPrice: 2499,
        costPrice: 1400,
        qty: 30,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Lightning Charging Port',
        barcode: const Value('PORT-LTN'),
        category: 'Charging Ports',
        sellPrice: 2699,
        costPrice: 1500,
        qty: 28,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'iPhone 13 Case',
        barcode: const Value('CASE-IP13'),
        category: 'Cases',
        sellPrice: 1599,
        costPrice: 700,
        qty: 45,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Galaxy S21 Case',
        barcode: const Value('CASE-S21'),
        category: 'Cases',
        sellPrice: 1499,
        costPrice: 650,
        qty: 40,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Universal TPU Case',
        barcode: const Value('CASE-TPU'),
        category: 'Cases',
        sellPrice: 999,
        costPrice: 400,
        qty: 75,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Screen Protector 2-Pack',
        barcode: const Value('ACC-SP-2P'),
        category: 'Accessories',
        sellPrice: 899,
        costPrice: 300,
        qty: 90,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'SIM Tray Tool',
        barcode: const Value('ACC-SIM'),
        category: 'Accessories',
        sellPrice: 299,
        costPrice: 50,
        qty: 100,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Car Vent Mount',
        barcode: const Value('ACC-CAR'),
        category: 'Accessories',
        sellPrice: 1299,
        costPrice: 500,
        qty: 32,
        trackImei: false,
        createdAt: now,
      ),
      ProductsCompanion.insert(
        id: uuid.v4(),
        name: 'Power Bank 10000mAh',
        barcode: const Value('ACC-PB10K'),
        category: 'Accessories',
        sellPrice: 3499,
        costPrice: 2200,
        qty: 18,
        trackImei: false,
        createdAt: now,
      ),
    ];

    await batch((batch) {
      batch.insertAll(products, samples);
    });
  }

  // Sales Invoice methods

  /// Get all sales with pagination
  Future<List<Sale>> getAllSales({int? limit, int? offset}) async {
    var query = select(sales)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Get all sales with customer info
  Future<List<SaleWithCustomer>> getAllSalesWithCustomer({int? limit}) async {
    final query =
        select(sales).join([
          leftOuterJoin(customers, customers.id.equalsExp(sales.customerId)),
        ])..orderBy([
          OrderingTerm(expression: sales.createdAt, mode: OrderingMode.desc),
        ]);

    if (limit != null) {
      query.limit(limit);
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => SaleWithCustomer(
            sale: row.readTable(sales),
            customer: row.readTableOrNull(customers),
          ),
        )
        .toList();
  }

  /// Get sale with items
  Future<SaleWithItems?> getSaleWithItems(String saleId) async {
    final sale = await (select(
      sales,
    )..where((tbl) => tbl.id.equals(saleId))).getSingleOrNull();

    if (sale == null) return null;

    final itemsQuery = select(saleItems).join([
      innerJoin(products, products.id.equalsExp(saleItems.productId)),
    ])..where(saleItems.saleId.equals(saleId));

    final rows = await itemsQuery.get();
    final items = rows.map((row) {
      return SaleItemWithProduct(
        saleItem: row.readTable(saleItems),
        product: row.readTable(products),
      );
    }).toList();

    return SaleWithItems(sale: sale, items: items);
  }

  /// Process a sale return (restock items and refund customer)
  Future<int> processSaleReturn({
    required String saleId,
    required List<SaleReturnItemInput> items,
  }) async {
    if (items.isEmpty) return 0;

    return transaction(() async {
      final sale = await (select(
        sales,
      )..where((tbl) => tbl.id.equals(saleId))).getSingleOrNull();
      if (sale == null) {
        throw StateError('Sale not found');
      }

      final saleItemsList = await (select(
        saleItems,
      )..where((tbl) => tbl.saleId.equals(saleId))).get();

      final returnedQtyByItem = <String, int>{};

      var refundTotal = 0;
      for (final item in items) {
        if (item.qty <= 0) continue;

        final saleItem = await (select(
          saleItems,
        )..where((tbl) => tbl.id.equals(item.saleItemId))).getSingleOrNull();

        if (saleItem == null || saleItem.saleId != saleId) {
          throw StateError('Sale item not found');
        }

        if (item.qty > saleItem.qty) {
          throw StateError('Return qty exceeds sold qty');
        }

        returnedQtyByItem[saleItem.id] =
            (returnedQtyByItem[saleItem.id] ?? 0) + item.qty;
        refundTotal += saleItem.unitPrice * item.qty;

        final product = await (select(
          products,
        )..where((tbl) => tbl.id.equals(saleItem.productId))).getSingleOrNull();

        if (product != null) {
          final newQty = product.qty + item.qty;
          await (update(products)
                ..where((tbl) => tbl.id.equals(saleItem.productId)))
              .write(ProductsCompanion(qty: Value(newQty)));

          await into(stockMovements).insert(
            StockMovementsCompanion.insert(
              id: const Uuid().v4(),
              productId: saleItem.productId,
              type: 'in',
              qtyDelta: item.qty,
              reason: 'sale_return',
              refId: Value(saleId),
              createdAt: DateTime.now(),
            ),
          );
        }
      }

      if (refundTotal > 0 && sale.customerId != null) {
        final customer = await (select(
          customers,
        )..where((tbl) => tbl.id.equals(sale.customerId!))).getSingleOrNull();
        if (customer != null) {
          await (update(
            customers,
          )..where((tbl) => tbl.id.equals(customer.id))).write(
            CustomersCompanion(balance: Value(customer.balance - refundTotal)),
          );

          await into(payments).insert(
            PaymentsCompanion.insert(
              id: const Uuid().v4(),
              customerId: customer.id,
              amount: refundTotal,
              direction: 'pay',
              note: Value('Return:${sale.id}'),
              createdAt: DateTime.now(),
            ),
          );
        }
      }

      final isFullReturn = saleItemsList.every((saleItem) {
        final returnedQty = returnedQtyByItem[saleItem.id] ?? 0;
        return returnedQty >= saleItem.qty;
      });

      if (isFullReturn) {
        await (delete(
          saleItems,
        )..where((tbl) => tbl.saleId.equals(saleId))).go();
        await (delete(sales)..where((tbl) => tbl.id.equals(saleId))).go();
        await (delete(debts)..where(
              (tbl) =>
                  tbl.sourceType.equals('sale') & tbl.sourceId.equals(saleId),
            ))
            .go();
      }

      return refundTotal;
    });
  }

  /// Get sales summary (count and total)
  Future<SalesSummaryBasic> getSalesSummaryBasic() async {
    final allSales = await select(sales).get();
    final count = allSales.length;
    final total = allSales.fold<int>(0, (sum, sale) => sum + sale.total);

    return SalesSummaryBasic(count: count, totalCents: total);
  }

  // Purchase Invoice methods

  /// Create a purchase invoice with items
  Future<String> createPurchaseInvoice({
    required String supplier,
    required List<PurchaseInvoiceItemInput> items,
    DateTime? createdAt,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('Purchase invoice must have at least one item');
    }

    final now = createdAt ?? DateTime.now();
    final invoiceId = const Uuid().v4();
    final total = items.fold<int>(0, (sum, item) => sum + item.lineTotal);

    await transaction(() async {
      final dayStart = DateTime(now.year, now.month, now.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final sameDayInvoices =
          await (select(purchaseInvoices)..where(
                (tbl) =>
                    tbl.createdAt.isBiggerOrEqualValue(dayStart) &
                    tbl.createdAt.isSmallerThanValue(dayEnd),
              ))
              .get();

      final datePrefix =
          '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      var nextSequence = 1;

      for (final existing in sameDayInvoices) {
        final number = existing.invoiceNumber;
        if (!number.startsWith('$datePrefix-')) {
          continue;
        }

        final suffix = number.substring('$datePrefix-'.length);
        final parsed = int.tryParse(suffix);
        if (parsed != null && parsed >= nextSequence) {
          nextSequence = parsed + 1;
        }
      }

      String generatedInvoiceNumber;
      do {
        generatedInvoiceNumber =
            '$datePrefix-${nextSequence.toString().padLeft(3, '0')}';
        nextSequence++;
      } while (sameDayInvoices.any(
        (row) => row.invoiceNumber == generatedInvoiceNumber,
      ));

      // Create invoice
      await into(purchaseInvoices).insert(
        PurchaseInvoicesCompanion.insert(
          id: invoiceId,
          invoiceNumber: generatedInvoiceNumber,
          supplier: supplier,
          total: total,
          createdAt: now,
        ),
      );

      // Create items and update stock
      for (final item in items) {
        final itemId = const Uuid().v4();

        await into(purchaseInvoiceItems).insert(
          PurchaseInvoiceItemsCompanion.insert(
            id: itemId,
            purchaseInvoiceId: invoiceId,
            productId: item.productId,
            qty: item.qty,
            purchasePrice: item.purchasePrice,
            salePrice: item.salePrice,
            lineTotal: item.lineTotal,
          ),
        );

        // Update product quantity
        final product = await (select(
          products,
        )..where((tbl) => tbl.id.equals(item.productId))).getSingleOrNull();

        if (product != null) {
          final newQty = product.qty + item.qty;
          await (update(
            products,
          )..where((tbl) => tbl.id.equals(item.productId))).write(
            ProductsCompanion(
              qty: Value(newQty),
              costPrice: Value(item.purchasePrice),
              sellPrice: Value(item.salePrice),
            ),
          );

          // Record stock movement
          await into(stockMovements).insert(
            StockMovementsCompanion.insert(
              id: const Uuid().v4(),
              productId: item.productId,
              type: 'in',
              qtyDelta: item.qty,
              reason: 'purchase',
              refId: Value(invoiceId),
              createdAt: now,
            ),
          );
        }
      }
    });

    return invoiceId;
  }

  /// Get all purchase invoices
  Future<List<PurchaseInvoice>> getAllPurchaseInvoices({
    int? limit,
    int? offset,
  }) async {
    var query = select(purchaseInvoices)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Get purchase invoice with items
  Future<PurchaseInvoiceWithItems?> getPurchaseInvoiceWithItems(
    String invoiceId,
  ) async {
    final invoice = await (select(
      purchaseInvoices,
    )..where((tbl) => tbl.id.equals(invoiceId))).getSingleOrNull();

    if (invoice == null) return null;

    final itemsQuery = select(purchaseInvoiceItems).join([
      innerJoin(
        products,
        products.id.equalsExp(purchaseInvoiceItems.productId),
      ),
    ])..where(purchaseInvoiceItems.purchaseInvoiceId.equals(invoiceId));

    final rows = await itemsQuery.get();
    final items = rows.map((row) {
      return PurchaseInvoiceItemWithProduct(
        item: row.readTable(purchaseInvoiceItems),
        product: row.readTable(products),
      );
    }).toList();

    return PurchaseInvoiceWithItems(invoice: invoice, items: items);
  }

  // Supplier methods

  Future<void> createSupplier({
    required String name,
    String? phone,
    String? address,
  }) async {
    await into(suppliers).insert(
      SuppliersCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        phone: Value(phone),
        address: Value(address),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateSupplier({
    required String id,
    required String name,
    String? phone,
    String? address,
  }) async {
    await (update(suppliers)..where((tbl) => tbl.id.equals(id))).write(
      SuppliersCompanion(
        name: Value(name),
        phone: Value(phone),
        address: Value(address),
      ),
    );
  }

  Future<bool> deleteSupplier(String id) async {
    try {
      await transaction(() async {
        await customStatement(
          'DELETE FROM supplier_requested_products WHERE supplier_id = ?',
          [id],
        );

        // Delete all purchases and their items for this supplier
        final supplierPurchases = await (select(
          purchases,
        )..where((tbl) => tbl.supplierId.equals(id))).get();

        for (final purchase in supplierPurchases) {
          // Delete purchase items
          await (delete(
            purchaseItems,
          )..where((tbl) => tbl.purchaseId.equals(purchase.id))).go();

          // Delete the purchase
          await (delete(
            purchases,
          )..where((tbl) => tbl.id.equals(purchase.id))).go();
        }

        // Delete the supplier
        await (delete(suppliers)..where((tbl) => tbl.id.equals(id))).go();
      });
      return true;
    } catch (e) {
      print('Error deleting supplier: $e');
      return false;
    }
  }

  Future<List<Supplier>> getAllSuppliers({int? limit, int? offset}) async {
    var query = select(suppliers)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset ?? 0);
    }

    return query.get();
  }

  Future<List<Supplier>> searchSuppliers(String query) async {
    if (query.isEmpty) {
      return getAllSuppliers();
    }

    final searchTerm = '%$query%';
    return (select(suppliers)
          ..where(
            (tbl) => tbl.name.like(searchTerm) | tbl.phone.like(searchTerm),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<Supplier?> getSupplierById(String id) async {
    return (select(
      suppliers,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<SupplierRequestedProduct>> getSupplierRequestedProducts(
    String supplierId, {
    String? status,
  }) async {
    var query = '''
      SELECT
        id,
        supplier_id,
        product_name,
        requested_qty,
        customer_note,
        status,
        created_at,
        updated_at
      FROM supplier_requested_products
      WHERE supplier_id = ?
    ''';

    final variables = <Variable<Object>>[Variable.withString(supplierId)];
    if (status != null && status.trim().isNotEmpty) {
      query += ' AND status = ?';
      variables.add(Variable.withString(status.trim()));
    }

    query += ' ORDER BY created_at DESC';

    final rows = await customSelect(query, variables: variables).get();

    return rows.map((row) {
      final data = row.data;
      return SupplierRequestedProduct(
        id: data['id'] as String,
        supplierId: data['supplier_id'] as String,
        productName: data['product_name'] as String,
        requestedQty: data['requested_qty'] as int? ?? 1,
        customerNote: data['customer_note'] as String?,
        status: data['status'] as String? ?? 'pending',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          data['created_at'] as int? ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          data['updated_at'] as int? ?? 0,
        ),
      );
    }).toList();
  }

  Future<String> createSupplierRequestedProduct({
    required String supplierId,
    required String productName,
    required int requestedQty,
    String? customerNote,
  }) async {
    final id = const Uuid().v4();
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    await customInsert(
      '''
        INSERT INTO supplier_requested_products(
          id,
          supplier_id,
          product_name,
          requested_qty,
          customer_note,
          status,
          created_at,
          updated_at
        ) VALUES (?, ?, ?, ?, ?, 'pending', ?, ?)
      ''',
      variables: [
        Variable.withString(id),
        Variable.withString(supplierId),
        Variable.withString(productName.trim()),
        Variable.withInt(requestedQty < 1 ? 1 : requestedQty),
        Variable.withString(customerNote?.trim() ?? ''),
        Variable.withInt(nowMs),
        Variable.withInt(nowMs),
      ],
      updates: {},
    );

    return id;
  }

  Future<void> updateSupplierRequestedProductStatus({
    required String id,
    required String status,
  }) async {
    await customStatement(
      '''
        UPDATE supplier_requested_products
        SET status = ?, updated_at = ?
        WHERE id = ?
      ''',
      [status, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> deleteSupplierRequestedProduct(String id) async {
    await customStatement(
      'DELETE FROM supplier_requested_products WHERE id = ?',
      [id],
    );
  }

  Future<List<MissingProductNote>> getMissingProductNotes({
    String? status,
  }) async {
    var query = '''
      SELECT
        id,
        item_name,
        requested_qty,
        customer_note,
        status,
        created_at,
        updated_at
      FROM missing_products_notes
    ''';

    final variables = <Variable<Object>>[];
    if (status != null && status.trim().isNotEmpty) {
      query += ' WHERE status = ?';
      variables.add(Variable.withString(status.trim()));
    }

    query += ' ORDER BY created_at DESC';

    final rows = await customSelect(query, variables: variables).get();
    return rows.map((row) {
      final data = row.data;
      return MissingProductNote(
        id: data['id'] as String,
        itemName: data['item_name'] as String,
        requestedQty: data['requested_qty'] as int? ?? 1,
        customerNote: data['customer_note'] as String?,
        status: data['status'] as String? ?? 'open',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          data['created_at'] as int? ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          data['updated_at'] as int? ?? 0,
        ),
      );
    }).toList();
  }

  Future<String> createMissingProductNote({
    required String itemName,
    required int requestedQty,
    String? customerNote,
  }) async {
    final id = const Uuid().v4();
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    await customInsert(
      '''
        INSERT INTO missing_products_notes(
          id,
          item_name,
          requested_qty,
          customer_note,
          status,
          created_at,
          updated_at
        ) VALUES (?, ?, ?, ?, 'open', ?, ?)
      ''',
      variables: [
        Variable.withString(id),
        Variable.withString(itemName.trim()),
        Variable.withInt(requestedQty < 1 ? 1 : requestedQty),
        Variable.withString(customerNote?.trim() ?? ''),
        Variable.withInt(nowMs),
        Variable.withInt(nowMs),
      ],
      updates: {},
    );

    return id;
  }

  Future<void> updateMissingProductNoteStatus({
    required String id,
    required String status,
  }) async {
    await customStatement(
      '''
        UPDATE missing_products_notes
        SET status = ?, updated_at = ?
        WHERE id = ?
      ''',
      [status, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> deleteMissingProductNote(String id) async {
    await customStatement('DELETE FROM missing_products_notes WHERE id = ?', [
      id,
    ]);
  }

  // Get all purchases from a specific supplier with their items
  Future<List<PurchaseWithItems>> getPurchasesBySupplier(
    String supplierId,
  ) async {
    try {
      final purchasesList =
          await (select(purchases)
                ..where((tbl) => tbl.supplierId.equals(supplierId))
                ..orderBy([
                  (tbl) => OrderingTerm(
                    expression: tbl.createdAt,
                    mode: OrderingMode.desc,
                  ),
                ]))
              .get();

      final result = <PurchaseWithItems>[];
      for (final purchase in purchasesList) {
        final items = await (select(
          purchaseItems,
        )..where((tbl) => tbl.purchaseId.equals(purchase.id))).get();

        final itemsWithProducts = <PurchaseItemWithProduct>[];
        for (final item in items) {
          final product = await (select(
            products,
          )..where((tbl) => tbl.id.equals(item.productId))).getSingleOrNull();
          if (product != null) {
            itemsWithProducts.add(
              PurchaseItemWithProduct(item: item, product: product),
            );
          }
        }

        result.add(
          PurchaseWithItems(purchase: purchase, items: itemsWithProducts),
        );
      }

      return result;
    } catch (e) {
      // If it's a migration/schema error, delete the database
      if (e.toString().contains('no such column') ||
          e.toString().contains('SQL logic error')) {
        try {
          print('Schema mismatch detected. Cleaning up database...');
          final directory = await getApplicationDocumentsDirectory();
          final dbPath = p.join(directory.path, 'pos_store.sqlite');
          final dbFile = File(dbPath);
          if (await dbFile.exists()) {
            await dbFile.delete();
            print('Database deleted. Please restart the app.');
          }
        } catch (cleanupError) {
          print('Error during cleanup: $cleanupError');
        }
      }
      rethrow;
    }
  }

  // Get supplier summary: total purchases, items, and balance
  Future<SupplierSummary?> getSupplierSummary(String supplierId) async {
    final supplier = await getSupplierById(supplierId);
    if (supplier == null) return null;

    final purchases = await (select(
      this.purchases,
    )..where((tbl) => tbl.supplierId.equals(supplierId))).get();

    int totalPurchased = 0;
    int totalPaid = 0;
    int totalItems = 0;

    for (final purchase in purchases) {
      totalPurchased += purchase.total;
      totalPaid += purchase.paid;

      final items = await (select(
        purchaseItems,
      )..where((tbl) => tbl.purchaseId.equals(purchase.id))).get();
      totalItems += items.length;
    }

    // Add general payments to totalPaid
    final generalPayments =
        await (select(purchasePayments)..where(
              (tbl) =>
                  tbl.supplierId.equals(supplierId) & tbl.purchaseId.isNull(),
            ))
            .get();

    for (final payment in generalPayments) {
      totalPaid += payment.amount;
    }

    return SupplierSummary(
      supplier: supplier,
      totalPurchased: totalPurchased,
      totalPaid: totalPaid,
      balance: totalPurchased - totalPaid,
      totalItems: totalItems,
      totalInvoices: purchases.length,
    );
  }

  // Purchase methods

  Future<String> createPurchase({
    required String? supplierId,
    required String? invoiceNumber,
    required List<PurchaseItemInput> items,
    required int paid,
    DateTime? createdAt,
  }) async {
    final now = createdAt ?? DateTime.now();
    final purchaseId = const Uuid().v4();
    int total = 0;

    return transaction(() async {
      // Calculate total
      for (final item in items) {
        total += item.lineTotal;
      }

      // Create purchase
      await into(purchases).insert(
        PurchasesCompanion.insert(
          id: purchaseId,
          supplierId: Value(supplierId),
          invoiceNumber: Value(invoiceNumber),
          total: total,
          paid: paid,
          createdAt: now,
        ),
      );

      // Create purchase items and update product quantities
      for (final item in items) {
        await into(purchaseItems).insert(
          PurchaseItemsCompanion.insert(
            id: const Uuid().v4(),
            purchaseId: purchaseId,
            productId: item.productId,
            qty: item.qty,
            unitCost: item.unitCost,
            lineTotal: item.lineTotal,
          ),
        );

        // Increase product quantity
        final product = await (select(
          products,
        )..where((tbl) => tbl.id.equals(item.productId))).getSingleOrNull();
        if (product != null) {
          await (update(
            products,
          )..where((tbl) => tbl.id.equals(item.productId))).write(
            ProductsCompanion(
              qty: Value(product.qty + item.qty),
              costPrice: Value(item.unitCost), // Update cost price to latest
            ),
          );
        }

        // Record stock movement
        await into(stockMovements).insert(
          StockMovementsCompanion.insert(
            id: const Uuid().v4(),
            productId: item.productId,
            type: 'in',
            qtyDelta: item.qty,
            reason: 'purchase',
            refId: Value(purchaseId),
            createdAt: now,
          ),
        );
      }

      return purchaseId;
    });
  }

  Future<List<Purchase>> getAllPurchases({int? limit, int? offset}) async {
    var query = select(purchases)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset ?? 0);
    }

    return query.get();
  }

  /// Get all purchases and general payments combined
  Future<List<PurchaseOrPayment>> getAllPurchasesAndPayments({
    int? limit,
  }) async {
    final result = <PurchaseOrPayment>[];

    // Get purchases
    final purchasesList = await getAllPurchases(limit: limit);
    for (final purchase in purchasesList) {
      Supplier? supplier;
      if (purchase.supplierId != null) {
        supplier = await getSupplierById(purchase.supplierId!);
      }

      result.add(
        PurchaseOrPayment(
          id: purchase.id,
          type: 'purchase',
          supplierId: purchase.supplierId,
          supplierName: supplier?.name,
          invoiceNumber: purchase.invoiceNumber,
          total: purchase.total,
          paid: purchase.paid,
          createdAt: purchase.createdAt,
        ),
      );
    }

    // Get general payments (where purchaseId is null)
    final paymentsList =
        await (select(purchasePayments)
              ..where((tbl) => tbl.purchaseId.isNull())
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final payment in paymentsList) {
      final supplier = await getSupplierById(payment.supplierId);

      result.add(
        PurchaseOrPayment(
          id: payment.id,
          type: 'payment',
          supplierId: payment.supplierId,
          supplierName: supplier?.name,
          total: payment.amount,
          paid: payment.amount, // Payment is always fully paid
          description: payment.description,
          createdAt: payment.createdAt,
        ),
      );
    }

    // Sort by date descending
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Apply limit if specified
    if (limit != null && result.length > limit) {
      return result.sublist(0, limit);
    }

    return result;
  }

  /// Get all purchases and general payments for a specific supplier
  Future<List<PurchaseOrPayment>> getPurchasesAndPaymentsBySupplier(
    String supplierId,
  ) async {
    final result = <PurchaseOrPayment>[];

    // Get purchases for this supplier
    final purchasesList =
        await (select(purchases)
              ..where((tbl) => tbl.supplierId.equals(supplierId))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    final supplier = await getSupplierById(supplierId);

    for (final purchase in purchasesList) {
      result.add(
        PurchaseOrPayment(
          id: purchase.id,
          type: 'purchase',
          supplierId: purchase.supplierId,
          supplierName: supplier?.name,
          invoiceNumber: purchase.invoiceNumber,
          total: purchase.total,
          paid: purchase.paid,
          createdAt: purchase.createdAt,
        ),
      );
    }

    // Get general payments (where purchaseId is null) for this supplier
    final paymentsList =
        await (select(purchasePayments)
              ..where(
                (tbl) =>
                    tbl.purchaseId.isNull() & tbl.supplierId.equals(supplierId),
              )
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final payment in paymentsList) {
      result.add(
        PurchaseOrPayment(
          id: payment.id,
          type: 'payment',
          supplierId: payment.supplierId,
          supplierName: supplier?.name,
          total: payment.amount,
          paid: payment.amount, // Payment is always fully paid
          description: payment.description,
          createdAt: payment.createdAt,
        ),
      );
    }

    // Sort by date descending
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }

  Future<PurchaseWithItems?> getPurchaseWithItems(String purchaseId) async {
    try {
      // Get purchase
      final purchase = await (select(
        purchases,
      )..where((tbl) => tbl.id.equals(purchaseId))).getSingleOrNull();
      if (purchase == null) return null;

      // Get items separately without join to avoid schema issues
      final items = await (select(
        purchaseItems,
      )..where((tbl) => tbl.purchaseId.equals(purchaseId))).get();

      final itemsWithProducts = <PurchaseItemWithProduct>[];
      for (final item in items) {
        final product = await (select(
          products,
        )..where((tbl) => tbl.id.equals(item.productId))).getSingleOrNull();
        if (product != null) {
          itemsWithProducts.add(
            PurchaseItemWithProduct(item: item, product: product),
          );
        }
      }

      // Get supplier if exists
      final supplier = purchase.supplierId != null
          ? await getSupplierById(purchase.supplierId!)
          : null;

      return PurchaseWithItems(
        purchase: purchase,
        items: itemsWithProducts,
        supplier: supplier,
      );
    } catch (e) {
      print('Error getting purchase details: $e');
      rethrow;
    }
  }

  Future<void> updatePurchasePaid({
    required String purchaseId,
    required int paid,
  }) async {
    await (update(purchases)..where((tbl) => tbl.id.equals(purchaseId))).write(
      PurchasesCompanion(paid: Value(paid)),
    );
  }

  Future<void> clearAllData() {
    return transaction(() async {
      // Clear service-related tables first
      await delete(serviceDailyInventory).go();
      await delete(serviceTransactions).go();
      await delete(cashDrawerEvents).go();

      // Clear settlement and payment tables
      await delete(settlements).go();
      await delete(purchasePayments).go();
      await delete(repairPartOrders).go();

      // Clear recharge and wallet tables
      await delete(programTopups).go();
      await delete(farahnetPayments).go();
      await delete(telelinkOperations).go();
      await delete(walletOperations).go();
      await delete(electricityRecharges).go();

      // Clear main sales and repair data
      await delete(saleItems).go();
      await delete(sales).go();
      await delete(repairParts).go();
      await delete(repairs).go();
      await delete(stockMovements).go();
      await delete(payments).go();
      await delete(debts).go();
      await delete(customers).go();

      // Clear product and purchase data
      await delete(purchaseInvoiceItems).go();
      await delete(purchaseInvoices).go();
      await delete(purchaseItems).go();
      await delete(purchases).go();
      await delete(products).go();

      // Clear suppliers last (other tables might reference it)
      await delete(suppliers).go();
    });
  }

  // ===== PURCHASE PAYMENTS METHODS =====

  /// Record a payment for a purchase or supplier (general payment)
  Future<String> recordPurchasePayment({
    String? purchaseId, // Nullable for general supplier payments
    required String supplierId,
    required int amount,
    String? description,
    DateTime? paymentDate,
  }) async {
    final paymentId = const Uuid().v4();
    final now = DateTime.now();

    return transaction(() async {
      // Create payment record
      await into(purchasePayments).insert(
        PurchasePaymentsCompanion.insert(
          id: paymentId,
          purchaseId: Value(purchaseId),
          supplierId: supplierId,
          amount: amount,
          description: Value(description),
          paymentDate: paymentDate ?? now,
          createdAt: now,
        ),
      );

      // Update purchase paid amount if purchaseId is provided
      if (purchaseId != null) {
        final purchase = await (select(
          purchases,
        )..where((tbl) => tbl.id.equals(purchaseId))).getSingleOrNull();
        if (purchase != null) {
          await (update(purchases)..where((tbl) => tbl.id.equals(purchaseId)))
              .write(PurchasesCompanion(paid: Value(purchase.paid + amount)));
        }
      }

      return paymentId;
    });
  }

  /// Get all payments for a purchase
  Future<List<PurchasePaymentRecord>> getPaymentsByPurchase(
    String purchaseId,
  ) async {
    try {
      final payments =
          await (select(purchasePayments)
                ..where((tbl) => tbl.purchaseId.equals(purchaseId))
                ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
              .get();

      return payments
          .map(
            (p) => PurchasePaymentRecord(
              id: p.id,
              purchaseId: p.purchaseId,
              supplierId: p.supplierId,
              amount: p.amount,
              description: p.description,
              paymentDate: p.paymentDate,
              createdAt: p.createdAt,
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting payments: $e');
      return [];
    }
  }

  /// Get all payments for a supplier
  Future<List<PurchasePaymentRecord>> getPaymentsBySupplier(
    String supplierId,
  ) async {
    try {
      final payments =
          await (select(purchasePayments)
                ..where((tbl) => tbl.supplierId.equals(supplierId))
                ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
              .get();

      return payments
          .map(
            (p) => PurchasePaymentRecord(
              id: p.id,
              purchaseId: p.purchaseId,
              supplierId: p.supplierId,
              amount: p.amount,
              description: p.description,
              paymentDate: p.paymentDate,
              createdAt: p.createdAt,
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting payments: $e');
      return [];
    }
  }

  /// Get total payments for a supplier
  Future<int> getTotalPaymentsBySupplier(String supplierId) async {
    try {
      final result = await (select(
        purchasePayments,
      )..where((tbl) => tbl.supplierId.equals(supplierId))).get();
      return result.fold<int>(0, (sum, payment) => sum + payment.amount);
    } catch (e) {
      print('Error calculating total payments: $e');
      return 0;
    }
  }

  /// Cancel a supplier payment and rollback linked purchase paid amount when present.
  Future<bool> cancelPurchasePayment(String paymentId) async {
    return transaction(() async {
      final payment = await (select(
        purchasePayments,
      )..where((tbl) => tbl.id.equals(paymentId))).getSingleOrNull();

      if (payment == null) {
        return false;
      }

      if (payment.purchaseId != null) {
        final purchase =
            await (select(purchases)
                  ..where((tbl) => tbl.id.equals(payment.purchaseId!)))
                .getSingleOrNull();

        if (purchase != null) {
          final nextPaid = (purchase.paid - payment.amount).clamp(
            0,
            purchase.total,
          );
          await (update(purchases)..where((tbl) => tbl.id.equals(purchase.id)))
              .write(PurchasesCompanion(paid: Value(nextPaid)));
        }
      }

      await (delete(
        purchasePayments,
      )..where((tbl) => tbl.id.equals(paymentId))).go();

      return true;
    });
  }

  // ===== REPAIRS & DEBTS METHODS =====

  /// Create a new repair (Phase 1 - Received)
  Future<String> createRepairPhase1({
    required String customerName,
    String? customerPhone,
    String? customerId,
    required String device,
    String? model,
    String? imei,
    required String issue,
    required int estimatedCost,
    required int paidAtReceive,
  }) async {
    final now = DateTime.now();
    final repairId = const Uuid().v4();

    await into(repairs).insert(
      RepairsCompanion.insert(
        id: repairId,
        customerId: Value(customerId),
        customerName: customerName,
        customerPhone: Value(customerPhone),
        device: device,
        model: Value(model),
        imei: Value(imei),
        issue: issue,
        status: 'Received',
        estimatedCost: Value(estimatedCost),
        paidAtReceive: Value(paidAtReceive),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return repairId;
  }

  /// Finalize repair delivery (Phase 2)
  /// Returns remaining amount owed (positive if unpaid, 0 if fully paid)
  Future<(String repairId, int remaining)> finalizeRepairDelivery({
    required String repairId,
    required int finalCost,
    required int discount,
    required int paidAtDelivery,
    DateTime? dueDate,
  }) {
    final now = DateTime.now();
    final total = finalCost - discount;

    return transaction(() async {
      // Get existing repair
      final repair = await (select(
        repairs,
      )..where((tbl) => tbl.id.equals(repairId))).getSingleOrNull();

      if (repair == null) {
        throw StateError('Repair not found: $repairId');
      }

      // Calculate totals
      final totalPaidAll = repair.paidAtReceive + paidAtDelivery;
      final remaining = total - totalPaidAll;

      // Update repair
      await (update(repairs)..where((tbl) => tbl.id.equals(repairId))).write(
        RepairsCompanion(
          finalCost: Value(finalCost),
          discount: Value(discount),
          paidAtDelivery: Value(paidAtDelivery),
          totalPaid: Value(totalPaidAll),
          status: Value('Delivered'),
          updatedAt: Value(now),
        ),
      );

      // Handle debt
      if (remaining > 0) {
        // Create or update debt for this repair
        await createOrUpdateDebtForRepair(
          repairId: repairId,
          customerId: repair.customerId,
          customerName: repair.customerName,
          customerPhone: repair.customerPhone,
          amount: remaining,
          dueDate: dueDate,
          note:
              '${repair.device}${repair.model != null ? ' (${repair.model})' : ''}',
        );
      } else if (remaining <= 0) {
        // Mark any existing debt as settled
        await (update(debts)..where(
              (tbl) =>
                  tbl.sourceType.equals('repair') &
                  tbl.sourceId.equals(repairId),
            ))
            .write(
              DebtsCompanion(
                isSettled: const Value(true),
                settledAt: Value(now),
                amount: const Value(0),
              ),
            );
      }

      return (repairId, remaining > 0 ? remaining : 0);
    });
  }

  /// Create or update a debt for a repair
  Future<void> createOrUpdateDebtForRepair({
    required String repairId,
    String? customerId,
    required String customerName,
    String? customerPhone,
    required int amount,
    DateTime? dueDate,
    String? note,
  }) {
    final now = DateTime.now();

    return transaction(() async {
      // Check if debt already exists for this repair
      final existing =
          await (select(debts)..where(
                (tbl) =>
                    tbl.sourceType.equals('repair') &
                    tbl.sourceId.equals(repairId),
              ))
              .getSingleOrNull();

      if (existing != null && !existing.isSettled) {
        // Update existing debt
        await (update(debts)..where((tbl) => tbl.id.equals(existing.id))).write(
          DebtsCompanion(
            amount: Value(amount),
            dueDate: Value(dueDate),
            note: Value(note),
          ),
        );
      } else {
        // Create new debt
        final debtId = const Uuid().v4();
        await into(debts).insert(
          DebtsCompanion.insert(
            id: debtId,
            customerId: Value(customerId),
            customerName: customerName,
            customerPhone: Value(customerPhone),
            sourceType: 'repair',
            sourceId: repairId,
            amount: amount,
            dueDate: Value(dueDate),
            note: Value(note),
            createdAt: now,
          ),
        );
      }
    });
  }

  /// Create a debt for a credit sale if remaining > 0
  Future<void> createDebtForCreditSale({
    required String saleId,
    String? customerId,
    required String customerName,
    String? customerPhone,
    required int remaining,
    String? note,
  }) {
    final now = DateTime.now();

    return transaction(() async {
      if (remaining <= 0) return;

      final debtId = const Uuid().v4();
      await into(debts).insert(
        DebtsCompanion.insert(
          id: debtId,
          customerId: Value(customerId),
          customerName: customerName,
          customerPhone: Value(customerPhone),
          sourceType: 'sale',
          sourceId: saleId,
          amount: remaining,
          note: Value(note),
          createdAt: now,
        ),
      );
    });
  }

  Future<void> addRepairPart({
    required String repairId,
    required String productId,
    required int qty,
    required int unitPrice,
  }) async {
    final now = DateTime.now();
    final lineTotal = qty * unitPrice;

    await transaction(() async {
      final partId = const Uuid().v4();
      await into(repairParts).insert(
        RepairPartsCompanion.insert(
          id: partId,
          repairId: repairId,
          productId: productId,
          qty: qty,
          unitPrice: unitPrice,
          lineTotal: lineTotal,
        ),
      );

      // Decrease stock
      final product = await (select(
        products,
      )..where((tbl) => tbl.id.equals(productId))).getSingleOrNull();

      if (product != null) {
        await (update(products)..where((tbl) => tbl.id.equals(productId)))
            .write(ProductsCompanion(qty: Value(product.qty - qty)));

        await into(stockMovements).insert(
          StockMovementsCompanion.insert(
            id: const Uuid().v4(),
            productId: productId,
            type: 'out',
            qtyDelta: -qty,
            reason: 'repair_part',
            refId: Value(partId),
            createdAt: now,
          ),
        );
      }
    });

    // Update repair updateAt
    await (update(repairs)..where((tbl) => tbl.id.equals(repairId))).write(
      RepairsCompanion(updatedAt: Value(now)),
    );
  }

  Future<void> removeRepairPart(String repairPartId) async {
    final now = DateTime.now();

    await transaction(() async {
      final part = await (select(
        repairParts,
      )..where((tbl) => tbl.id.equals(repairPartId))).getSingleOrNull();

      if (part == null) return;

      await (delete(
        repairParts,
      )..where((tbl) => tbl.id.equals(repairPartId))).go();

      // Increase stock
      final product = await (select(
        products,
      )..where((tbl) => tbl.id.equals(part.productId))).getSingleOrNull();

      if (product != null) {
        await (update(products)..where((tbl) => tbl.id.equals(part.productId)))
            .write(ProductsCompanion(qty: Value(product.qty + part.qty)));

        await into(stockMovements).insert(
          StockMovementsCompanion.insert(
            id: const Uuid().v4(),
            productId: part.productId,
            type: 'in',
            qtyDelta: part.qty,
            reason: 'repair_part_removed',
            refId: Value(part.repairId),
            createdAt: now,
          ),
        );
      }
    });
  }

  Future<bool> deleteRepair(String repairId) async {
    try {
      await transaction(() async {
        // 1. Get all repair parts and restore stock
        final parts = await (select(
          repairParts,
        )..where((tbl) => tbl.repairId.equals(repairId))).get();

        for (final part in parts) {
          // Restore stock
          final product = await (select(
            products,
          )..where((tbl) => tbl.id.equals(part.productId))).getSingleOrNull();

          if (product != null) {
            await (update(products)
                  ..where((tbl) => tbl.id.equals(part.productId)))
                .write(ProductsCompanion(qty: Value(product.qty + part.qty)));

            await into(stockMovements).insert(
              StockMovementsCompanion.insert(
                id: const Uuid().v4(),
                productId: part.productId,
                type: 'in',
                qtyDelta: part.qty,
                reason: 'repair_deleted',
                refId: Value(repairId),
                createdAt: DateTime.now(),
              ),
            );
          }
        }

        // 2. Delete all repair parts
        await (delete(
          repairParts,
        )..where((tbl) => tbl.repairId.equals(repairId))).go();

        // 3. Delete any debts related to this repair
        await (delete(debts)..where(
              (tbl) =>
                  tbl.sourceType.equals('repair') &
                  tbl.sourceId.equals(repairId),
            ))
            .go();

        // 4. Delete the repair itself
        await (delete(repairs)..where((tbl) => tbl.id.equals(repairId))).go();
      });

      return true;
    } catch (e) {
      print('Error deleting repair: $e');
      return false;
    }
  }

  Future<String> createProductWithSupplier({
    required String name,
    required int sellPrice,
    required int costPrice,
    required String supplierName,
    String category = 'Spare Parts',
  }) async {
    final now = DateTime.now();
    final productId = const Uuid().v4();

    await transaction(() async {
      // Find or create supplier
      String? supplierId;
      final existingSupplier = await (select(
        suppliers,
      )..where((tbl) => tbl.name.equals(supplierName))).getSingleOrNull();

      if (existingSupplier != null) {
        supplierId = existingSupplier.id;
      } else {
        supplierId = const Uuid().v4();
        await into(suppliers).insert(
          SuppliersCompanion.insert(
            id: supplierId,
            name: supplierName,
            createdAt: now,
          ),
        );
      }

      // Create product
      await into(products).insert(
        ProductsCompanion.insert(
          id: productId,
          name: name,
          category: category,
          supplierId: Value(supplierId),
          sellPrice: sellPrice,
          costPrice: costPrice,
          qty: 1, // Start with 1 since we are likely adding it immediately
          trackImei: false,
          createdAt: now,
        ),
      );

      // Initial Stock movement
      await into(stockMovements).insert(
        StockMovementsCompanion.insert(
          id: const Uuid().v4(),
          productId: productId,
          type: 'in',
          qtyDelta: 1,
          reason: 'initial',
          createdAt: now,
        ),
      );
    });

    return productId;
  }

  /// Get all debts for a customer (unsettled first)
  Future<List<Debt>> getDebtsForCustomer(String? customerId) async {
    if (customerId == null) {
      return (select(debts)
            ..where((tbl) => tbl.customerId.isNull())
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.isSettled, mode: OrderingMode.asc),
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
            ]))
          .get();
    }
    return (select(debts)
          ..where((tbl) => tbl.customerId.equals(customerId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.isSettled, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Get all active debts (not settled) grouped by customer
  Future<Map<String?, List<Debt>>> getAllDebtsGroupedByCustomer() async {
    final allDebts =
        await (select(debts)
              ..where((tbl) => tbl.isSettled.equals(false))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.customerName,
                  mode: OrderingMode.asc,
                ),
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.asc,
                ),
              ]))
            .get();

    final grouped = <String?, List<Debt>>{};
    for (final debt in allDebts) {
      final rawCustomerId = debt.customerId?.trim();
      final normalizedCustomerId =
          (rawCustomerId == null || rawCustomerId.isEmpty)
          ? null
          : rawCustomerId;
      final key =
          normalizedCustomerId ??
          'name:${debt.customerName.trim().toLowerCase()}';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(debt);
    }
    return grouped;
  }

  /// Apply a payment to debts, using FIFO (oldest first)
  /// Returns the remaining payment amount after all debts are applied
  Future<int> receivePaymentApplyToDebts({
    required String? customerId,
    String? customerName,
    required int paymentAmount,
    String? note,
  }) {
    final now = DateTime.now();

    return transaction(() async {
      // Get unsettled debts for this customer, oldest first
      var query = select(debts)..where((tbl) => tbl.isSettled.equals(false));

      final normalizedCustomerId = customerId?.trim();
      if (normalizedCustomerId != null && normalizedCustomerId.isNotEmpty) {
        query = query
          ..where((tbl) => tbl.customerId.equals(normalizedCustomerId));
      } else {
        if (customerName != null && customerName.trim().isNotEmpty) {
          final normalizedName = customerName.trim();
          query = query
            ..where(
              (tbl) => tbl.customerId.isNull() | tbl.customerId.equals(''),
            )
            ..where((tbl) => tbl.customerName.equals(normalizedName));
        } else {
          query = query
            ..where(
              (tbl) => tbl.customerId.isNull() | tbl.customerId.equals(''),
            );
        }
      }

      query = query
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
        ]);

      final debtsList = await query.get();

      int remaining = paymentAmount;

      for (final debt in debtsList) {
        if (remaining <= 0) break;

        if (debt.amount <= remaining) {
          // Settle this debt completely
          remaining -= debt.amount;
          await (update(debts)..where((tbl) => tbl.id.equals(debt.id))).write(
            DebtsCompanion(
              amount: const Value(0),
              isSettled: const Value(true),
              settledAt: Value(now),
            ),
          );
        } else {
          // Partial payment
          final newAmount = debt.amount - remaining;
          await (update(debts)..where((tbl) => tbl.id.equals(debt.id))).write(
            DebtsCompanion(amount: Value(newAmount)),
          );
          remaining = 0;
        }
      }

      // Record the payment in Payments table
      const uuid = Uuid();
      await into(payments).insert(
        PaymentsCompanion(
          id: Value(uuid.v4()),
          customerId: Value(customerId ?? ''),
          amount: Value(paymentAmount),
          direction: const Value('in'),
          note: Value(note),
          createdAt: Value(now),
        ),
      );

      return remaining;
    });
  }

  // Dashboard query methods
  /// Get all sales from today
  Future<List<Sale>> getTodaySales() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(sales)..where(
          (s) =>
              s.createdAt.isBiggerOrEqualValue(startOfDay) &
              s.createdAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }

  /// Get all repairs from today
  Future<List<Repair>> getTodayRepairs() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(repairs)..where(
          (r) =>
              r.createdAt.isBiggerOrEqualValue(startOfDay) &
              r.createdAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }

  // Print service query methods
  /// Get a sale by ID
  Future<Sale?> getSaleById(String saleId) {
    return (select(
      sales,
    )..where((tbl) => tbl.id.equals(saleId))).getSingleOrNull();
  }

  /// Get sale items with product for a sale
  Future<List<SaleItemWithProduct>> getSaleItems(String saleId) async {
    final rows = await (select(saleItems).join([
      innerJoin(products, products.id.equalsExp(saleItems.productId)),
    ])..where(saleItems.saleId.equals(saleId))).get();

    return rows.map((row) {
      final saleItem = row.readTable(saleItems);
      final product = row.readTable(products);
      return SaleItemWithProduct(saleItem: saleItem, product: product);
    }).toList();
  }

  /// Get service transactions for a sale
  Future<List<ServiceTransaction>> getServiceTransactionsForSale(
    String saleId,
  ) {
    return (select(
      serviceTransactions,
    )..where((tbl) => tbl.saleId.equals(saleId))).get();
  }

  /// Get a repair by ID
  Future<Repair?> getRepairById(String repairId) {
    return (select(
      repairs,
    )..where((tbl) => tbl.id.equals(repairId))).getSingleOrNull();
  }

  /// Count devices currently in maintenance (not delivered/completed)
  /// This counts ALL repairs regardless of creation date
  Future<int> getCurrentMaintenanceDevicesCount() async {
    final count = await (select(
      repairs,
    )..where((r) => r.status.isNotValue('Delivered'))).get();
    return count.length;
  }

  /// Calculate repair profit correctly (revenue after discount - parts cost)
  /// For today's repairs only
  Future<int> getTodayRepairsProfit() async {
    final todayRepairs = await getTodayRepairs();
    int totalProfit = 0;

    for (final repair in todayRepairs) {
      // Net revenue after discount
      final netRevenue = repair.finalCost - repair.discount;

      // Calculate parts cost
      final repairParts = await getRepairParts(repair.id);
      int partsCost = 0;
      for (final partWithProduct in repairParts) {
        partsCost +=
            partWithProduct.repairPart.qty * partWithProduct.product.costPrice;
      }

      // Profit = revenue - cost
      final profit = netRevenue - partsCost;
      totalProfit += profit;
    }

    return totalProfit;
  }

  /// Get repair profit for a specific date range (only normal, non-reversed transactions)
  Future<int> getRepairsProfit(DateTime from, DateTime to) async {
    final repairsList =
        await (select(repairs)..where(
              (r) =>
                  r.createdAt.isBetweenValues(from, to) &
                  r.transactionStatus.equals('normal'),
            ))
            .get();

    int totalProfit = 0;

    for (final repair in repairsList) {
      // Net revenue after discount
      final netRevenue = repair.finalCost - repair.discount;

      // Calculate parts cost
      final repairParts = await getRepairParts(repair.id);
      int partsCost = 0;
      for (final partWithProduct in repairParts) {
        partsCost +=
            partWithProduct.repairPart.qty * partWithProduct.product.costPrice;
      }

      // Profit = revenue - cost
      final profit = netRevenue - partsCost;
      totalProfit += profit;
    }

    return totalProfit;
  }

  /// Get detailed profit breakdown for a date range
  Future<DetailedProfitBreakdown> getDetailedProfitBreakdown(
    DateTime from,
    DateTime to,
  ) async {
    // 1. Calculate sales profit (only normal, non-reversed transactions)
    final salesList =
        await (select(sales)..where(
              (s) =>
                  s.createdAt.isBetweenValues(from, to) &
                  s.status.equals('normal'),
            ))
            .get();

    int totalSalesBeforeDiscount = 0;
    int totalDiscounts = 0;
    int totalCostOfGoodsSold = 0;

    for (final sale in salesList) {
      totalSalesBeforeDiscount += sale.total + sale.discount;
      totalDiscounts += sale.discount;

      // Calculate cost of goods sold for this sale
      final saleItemsQuery = select(saleItems).join([
        innerJoin(products, products.id.equalsExp(saleItems.productId)),
      ])..where(saleItems.saleId.equals(sale.id));

      final saleItemRows = await saleItemsQuery.get();
      for (final row in saleItemRows) {
        final item = row.readTable(saleItems);
        final product = row.readTable(products);
        totalCostOfGoodsSold += product.costPrice * item.qty;
      }
    }

    final netSalesRevenue = totalSalesBeforeDiscount - totalDiscounts;
    final salesProfit = netSalesRevenue - totalCostOfGoodsSold;

    // 2. Calculate repairs profit (only normal, non-reversed transactions)
    final repairsProfit = await getRepairsProfit(from, to);

    // 3. Calculate service profits (only normal, non-reversed transactions)
    final serviceRows =
        await (select(serviceTransactions)..where(
              (tbl) =>
                  tbl.createdAt.isBetweenValues(from, to) &
                  tbl.status.equals('normal'),
            ))
            .get();

    int servicesProfit = 0;
    int servicesRevenue = 0;
    for (final service in serviceRows) {
      servicesRevenue += service.amountCents;
      servicesProfit += service.profitCents ?? 0;
    }

    // 4. Calculate other operations profits (only normal, non-reversed transactions)
    final telelinkList =
        await (select(telelinkOperations)..where(
              (t) =>
                  t.operatedAt.isBetweenValues(from, to) &
                  t.status.equals('normal'),
            ))
            .get();
    int telelinkRevenue = 0;
    int telelinkProfit = 0;
    for (final op in telelinkList) {
      telelinkRevenue += op.amount;
      telelinkProfit += (op.amount * 0.02).round();
    }

    final electricityList =
        await (select(electricityRecharges)..where(
              (e) =>
                  e.operatedAt.isBetweenValues(from, to) &
                  e.status.equals('normal'),
            ))
            .get();
    int electricityRevenue = 0;
    int electricityProfit = 0;
    for (final op in electricityList) {
      electricityRevenue += op.amount;
      electricityProfit += (op.amount * 0.015).round();
    }

    final totalProfit =
        salesProfit +
        repairsProfit +
        servicesProfit +
        telelinkProfit +
        electricityProfit;

    return DetailedProfitBreakdown(
      // Sales breakdown
      totalSalesBeforeDiscount: totalSalesBeforeDiscount,
      totalDiscounts: totalDiscounts,
      netSalesRevenue: netSalesRevenue,
      costOfGoodsSold: totalCostOfGoodsSold,
      salesProfit: salesProfit,

      // Other profits
      repairsProfit: repairsProfit,
      servicesProfit: servicesProfit,
      telelinkProfit: telelinkProfit,
      electricityProfit: electricityProfit,

      // Totals
      totalRevenue:
          netSalesRevenue +
          servicesRevenue +
          telelinkRevenue +
          electricityRevenue,
      totalProfit: totalProfit,
    );
  }

  /// Get all transactions for a specific date range
  /// Returns unified transaction data from all sources
  Future<List<Map<String, dynamic>>> getAllTransactions(
    DateTime from,
    DateTime to,
  ) async {
    final List<Map<String, dynamic>> allTransactions = [];

    // 1. Sales
    final salesList =
        await (select(sales)
              ..where((s) => s.createdAt.isBetweenValues(from, to))
              ..orderBy([
                (s) => OrderingTerm(
                  expression: s.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final sale in salesList) {
      // Calculate profit from sale items
      final saleItemsQuery = select(saleItems).join([
        innerJoin(products, products.id.equalsExp(saleItems.productId)),
      ])..where(saleItems.saleId.equals(sale.id));

      final saleItemRows = await saleItemsQuery.get();
      int saleProfit = 0;
      final saleItemSummaries = <String>[];
      for (final row in saleItemRows) {
        final item = row.readTable(saleItems);
        final product = row.readTable(products);
        saleProfit += (item.unitPrice - product.costPrice) * item.qty;
        saleItemSummaries.add('${item.qty}x ${product.name}');
      }

      const maxItemsInDescription = 4;
      final visibleItems = saleItemSummaries
          .take(maxItemsInDescription)
          .toList();
      final hiddenItemsCount = saleItemSummaries.length - visibleItems.length;
      final itemsSummary = visibleItems.join(', ');
      final saleDescription = itemsSummary.isEmpty
          ? 'Payment: ${sale.paymentType}'
          : hiddenItemsCount > 0
          ? '$itemsSummary +$hiddenItemsCount more • Payment: ${sale.paymentType}'
          : '$itemsSummary • Payment: ${sale.paymentType}';

      // Subtract discount from profit
      // The discount reduces the profit, not just the revenue
      saleProfit -= sale.discount;

      // Get customer name if exists
      String? customerName;
      if (sale.customerId != null) {
        final customer = await (select(
          customers,
        )..where((c) => c.id.equals(sale.customerId!))).getSingleOrNull();
        customerName = customer?.name;
      }

      allTransactions.add({
        'id': sale.id,
        'type': 'sale',
        'createdAt': sale.createdAt,
        'amountCents': sale.total,
        'profitCents': saleProfit,
        'customerName': customerName,
        'description': saleDescription,
        'status': sale.status,
        'reversedAt': sale.reversedAt,
      });
    }

    // 2. Repairs (completed/delivered only)
    final repairsList =
        await (select(repairs)
              ..where(
                (r) =>
                    r.createdAt.isBetweenValues(from, to) &
                    (r.status.equals('Ready') | r.status.equals('Delivered')),
              )
              ..orderBy([
                (r) => OrderingTerm(
                  expression: r.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final repair in repairsList) {
      final netRevenue = repair.finalCost - repair.discount;

      // Calculate parts cost
      final repairParts = await getRepairParts(repair.id);
      int partsCost = 0;
      for (final partWithProduct in repairParts) {
        partsCost +=
            partWithProduct.repairPart.qty * partWithProduct.product.costPrice;
      }

      final profit = netRevenue - partsCost;

      allTransactions.add({
        'id': repair.id,
        'type': 'repair',
        'createdAt': repair.createdAt,
        'amountCents': repair.finalCost,
        'profitCents': profit,
        'customerName': repair.customerName,
        'description': '${repair.device} - ${repair.issue}',
        'status': repair.transactionStatus,
        'reversedAt': repair.reversedAt,
      });
    }

    // 3. TeleLink Operations
    final telelinkList =
        await (select(telelinkOperations)
              ..where((t) => t.operatedAt.isBetweenValues(from, to))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.operatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final telelink in telelinkList) {
      // Assume 2% profit margin for TeleLink
      final profit = (telelink.amount * 0.02).round();

      allTransactions.add({
        'id': telelink.id,
        'type': 'telelink',
        'createdAt': telelink.operatedAt,
        'amountCents': telelink.amount,
        'profitCents': profit,
        'status': telelink.status,
        'reversedAt': telelink.reversedAt,
        'customerName': telelink.customerName,
        'description': telelink.notes,
      });
    }

    // 4. Electricity Recharges
    final electricityList =
        await (select(electricityRecharges)
              ..where((e) => e.operatedAt.isBetweenValues(from, to))
              ..orderBy([
                (e) => OrderingTerm(
                  expression: e.operatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final electricity in electricityList) {
      // Assume 1.5% profit margin for electricity
      final profit = (electricity.amount * 0.015).round();

      allTransactions.add({
        'id': electricity.id,
        'type': 'electricity',
        'createdAt': electricity.operatedAt,
        'amountCents': electricity.amount,
        'profitCents': profit,
        'customerName': electricity.customerName,
        'description':
            '${electricity.operationType} - ${electricity.subscriptionNumber ?? ""}',
        'status': electricity.status,
        'reversedAt': electricity.reversedAt,
      });
    }

    // 5. Program Topups
    final topupsList =
        await (select(programTopups)
              ..where((p) => p.operatedAt.isBetweenValues(from, to))
              ..orderBy([
                (p) => OrderingTerm(
                  expression: p.operatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final topup in topupsList) {
      // Assume 2% profit margin for program topups
      final profit = (topup.amount * 0.02).round();

      allTransactions.add({
        'id': topup.id,
        'type': 'programTopup',
        'createdAt': topup.operatedAt,
        'amountCents': topup.amount,
        'profitCents': profit,
        'customerName': null,
        'description': '${topup.programType} - ${topup.notes ?? ""}',
        'status': topup.status,
        'reversedAt': topup.reversedAt,
      });
    }

    // 6. Service Transactions
    final servicesList =
        await (select(serviceTransactions)
              ..where((s) => s.createdAt.isBetweenValues(from, to))
              ..orderBy([
                (s) => OrderingTerm(
                  expression: s.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final service in servicesList) {
      final providerName =
          service.provider == 'other' &&
              service.providerLabel != null &&
              service.providerLabel!.trim().isNotEmpty
          ? service.providerLabel!.trim()
          : service.provider;

      final serviceParts = <String>[
        service.category,
        service.serviceType,
        providerName,
      ];

      final cleanedServiceNotes = service.notes?.trim();
      if (cleanedServiceNotes != null && cleanedServiceNotes.isNotEmpty) {
        serviceParts.add(cleanedServiceNotes);
      }

      final serviceDescription = serviceParts
          .where((part) => part.trim().isNotEmpty)
          .join(' • ');

      allTransactions.add({
        'id': service.id,
        'type': 'service',
        'createdAt': service.createdAt,
        'amountCents': service.amountCents,
        'profitCents': service.profitCents ?? 0,
        'customerName': service.customerName,
        'description': serviceDescription,
        'status': service.status,
        'reversedAt': service.reversedAt,
      });
    }

    // 7. Farahnet Payments
    final farahnetList =
        await (select(farahnetPayments)
              ..where((f) => f.createdAt.isBetweenValues(from, to))
              ..orderBy([
                (f) => OrderingTerm(
                  expression: f.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final farahnet in farahnetList) {
      // Profit is already calculated in the table
      final profit = farahnet.profitAmount;

      allTransactions.add({
        'id': farahnet.id,
        'type': 'farahnet',
        'createdAt': farahnet.createdAt,
        'amountCents': farahnet.amountPaid,
        'profitCents': profit,
        'customerName': farahnet.customerName,
        'description': farahnet.notes,
        'status': farahnet.status,
        'reversedAt': farahnet.reversedAt,
      });
    }

    // 8. Wallet Operations
    final walletList =
        await (select(walletOperations)
              ..where((w) => w.operatedAt.isBetweenValues(from, to))
              ..orderBy([
                (w) => OrderingTerm(
                  expression: w.operatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    for (final wallet in walletList) {
      // Assume 2% profit margin
      final profit = (wallet.amount * 0.02).round();
      final cleanedWalletNotes = wallet.notes?.trim();
      final walletDescription =
          (cleanedWalletNotes != null && cleanedWalletNotes.isNotEmpty)
          ? cleanedWalletNotes
          : 'Cash drawer operation';

      allTransactions.add({
        'id': wallet.id,
        'type': 'wallet',
        'createdAt': wallet.operatedAt,
        'amountCents': wallet.amount,
        'profitCents': profit,
        'customerName': wallet.customerName,
        'description': walletDescription,
        'status': wallet.status,
        'reversedAt': wallet.reversedAt,
      });
    }

    // Sort all transactions by date (most recent first)
    allTransactions.sort((a, b) {
      final dateA = a['createdAt'] as DateTime;
      final dateB = b['createdAt'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return allTransactions;
  }

  /// Reverse a transaction by ID and type
  /// Returns true if successful, false if already reversed or not found
  Future<bool> reverseTransaction(
    String transactionId,
    String transactionType,
  ) async {
    final now = DateTime.now();

    try {
      return await transaction(() async {
        switch (transactionType) {
          case 'sale':
            final sale = await (select(
              sales,
            )..where((s) => s.id.equals(transactionId))).getSingleOrNull();
            if (sale == null || sale.status == 'reversed') return false;

            final saleItemsList = await (select(
              saleItems,
            )..where((item) => item.saleId.equals(transactionId))).get();

            for (final item in saleItemsList) {
              final product = await (select(
                products,
              )..where((p) => p.id.equals(item.productId))).getSingleOrNull();

              if (product == null) continue;

              await (update(products)
                    ..where((p) => p.id.equals(item.productId)))
                  .write(ProductsCompanion(qty: Value(product.qty + item.qty)));

              await into(stockMovements).insert(
                StockMovementsCompanion.insert(
                  id: const Uuid().v4(),
                  productId: item.productId,
                  type: 'in',
                  qtyDelta: item.qty,
                  reason: 'sale_reversal',
                  refId: Value(transactionId),
                  createdAt: now,
                ),
              );
            }

            if (sale.customerId != null) {
              final customer = await (select(
                customers,
              )..where((c) => c.id.equals(sale.customerId!))).getSingleOrNull();

              if (customer != null) {
                final balanceDelta = sale.total - sale.paid;
                if (balanceDelta != 0) {
                  await (update(
                    customers,
                  )..where((c) => c.id.equals(customer.id))).write(
                    CustomersCompanion(
                      balance: Value(customer.balance - balanceDelta),
                    ),
                  );
                }
              }
            }

            await (delete(debts)..where(
                  (d) =>
                      d.sourceType.equals('sale') &
                      d.sourceId.equals(transactionId),
                ))
                .go();

            await (update(
              sales,
            )..where((s) => s.id.equals(transactionId))).write(
              SalesCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'repair':
            final repair = await (select(
              repairs,
            )..where((r) => r.id.equals(transactionId))).getSingleOrNull();
            if (repair == null || repair.transactionStatus == 'reversed') {
              return false;
            }

            final parts = await (select(
              repairParts,
            )..where((part) => part.repairId.equals(transactionId))).get();

            for (final part in parts) {
              final product = await (select(
                products,
              )..where((p) => p.id.equals(part.productId))).getSingleOrNull();

              if (product == null) continue;

              await (update(products)
                    ..where((p) => p.id.equals(part.productId)))
                  .write(ProductsCompanion(qty: Value(product.qty + part.qty)));

              await into(stockMovements).insert(
                StockMovementsCompanion.insert(
                  id: const Uuid().v4(),
                  productId: part.productId,
                  type: 'in',
                  qtyDelta: part.qty,
                  reason: 'repair_reversal',
                  refId: Value(transactionId),
                  createdAt: now,
                ),
              );
            }

            await (delete(debts)..where(
                  (d) =>
                      d.sourceType.equals('repair') &
                      d.sourceId.equals(transactionId),
                ))
                .go();

            await (update(
              repairs,
            )..where((r) => r.id.equals(transactionId))).write(
              RepairsCompanion(
                transactionStatus: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'service':
            final service = await (select(
              serviceTransactions,
            )..where((s) => s.id.equals(transactionId))).getSingleOrNull();
            if (service == null || service.status == 'reversed') return false;
            await (update(
              serviceTransactions,
            )..where((s) => s.id.equals(transactionId))).write(
              ServiceTransactionsCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'telelink':
            final telelink = await (select(
              telelinkOperations,
            )..where((t) => t.id.equals(transactionId))).getSingleOrNull();
            if (telelink == null || telelink.status == 'reversed') return false;
            await (update(
              telelinkOperations,
            )..where((t) => t.id.equals(transactionId))).write(
              TelelinkOperationsCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'electricity':
            final electricity = await (select(
              electricityRecharges,
            )..where((e) => e.id.equals(transactionId))).getSingleOrNull();
            if (electricity == null || electricity.status == 'reversed') {
              return false;
            }
            await (update(
              electricityRecharges,
            )..where((e) => e.id.equals(transactionId))).write(
              ElectricityRechargesCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'programTopup':
            final topup = await (select(
              programTopups,
            )..where((p) => p.id.equals(transactionId))).getSingleOrNull();
            if (topup == null || topup.status == 'reversed') return false;
            await (update(
              programTopups,
            )..where((p) => p.id.equals(transactionId))).write(
              ProgramTopupsCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'farahnet':
            final farahnet = await (select(
              farahnetPayments,
            )..where((f) => f.id.equals(transactionId))).getSingleOrNull();
            if (farahnet == null || farahnet.status == 'reversed') return false;
            await (update(
              farahnetPayments,
            )..where((f) => f.id.equals(transactionId))).write(
              FarahnetPaymentsCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          case 'wallet':
            final wallet = await (select(
              walletOperations,
            )..where((w) => w.id.equals(transactionId))).getSingleOrNull();
            if (wallet == null || wallet.status == 'reversed') return false;
            await (update(
              walletOperations,
            )..where((w) => w.id.equals(transactionId))).write(
              WalletOperationsCompanion(
                status: const Value('reversed'),
                reversedAt: Value(now),
              ),
            );
            return true;

          default:
            return false;
        }
      });
    } catch (e) {
      print('Error reversing transaction: $e');
      return false;
    }
  }

  /// Check if a transaction is already reversed
  Future<bool> isTransactionReversed(
    String transactionId,
    String transactionType,
  ) async {
    switch (transactionType) {
      case 'sale':
        final sale = await (select(
          sales,
        )..where((s) => s.id.equals(transactionId))).getSingleOrNull();
        return sale?.status == 'reversed';
      case 'repair':
        final repair = await (select(
          repairs,
        )..where((r) => r.id.equals(transactionId))).getSingleOrNull();
        return repair?.transactionStatus == 'reversed';
      case 'service':
        final service = await (select(
          serviceTransactions,
        )..where((s) => s.id.equals(transactionId))).getSingleOrNull();
        return service?.status == 'reversed';
      case 'telelink':
        final telelink = await (select(
          telelinkOperations,
        )..where((t) => t.id.equals(transactionId))).getSingleOrNull();
        return telelink?.status == 'reversed';
      case 'electricity':
        final electricity = await (select(
          electricityRecharges,
        )..where((e) => e.id.equals(transactionId))).getSingleOrNull();
        return electricity?.status == 'reversed';
      case 'programTopup':
        final topup = await (select(
          programTopups,
        )..where((p) => p.id.equals(transactionId))).getSingleOrNull();
        return topup?.status == 'reversed';
      case 'farahnet':
        final farahnet = await (select(
          farahnetPayments,
        )..where((f) => f.id.equals(transactionId))).getSingleOrNull();
        return farahnet?.status == 'reversed';
      case 'wallet':
        final wallet = await (select(
          walletOperations,
        )..where((w) => w.id.equals(transactionId))).getSingleOrNull();
        return wallet?.status == 'reversed';
      default:
        return false;
    }
  }
}

class SaleItemInput {
  final String id;
  final String productId;
  final int qty;
  final int unitPrice;
  final int lineTotal;

  const SaleItemInput({
    required this.id,
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });
}

class SaleReturnItemInput {
  final String saleItemId;
  final int qty;

  const SaleReturnItemInput({required this.saleItemId, required this.qty});
}

class SaleCheckoutItem {
  final String productId;
  final int qty;
  final int unitPrice;

  const SaleCheckoutItem({
    required this.productId,
    required this.qty,
    required this.unitPrice,
  });
}

class RepairPartWithProduct {
  final RepairPart repairPart;
  final Product product;

  const RepairPartWithProduct({
    required this.repairPart,
    required this.product,
  });
}

class SalesSummary {
  final int totalAmount;
  final int salesCount;
  final int cashTotal;
  final int cardTotal;
  final int transferTotal;
  final int creditTotal;

  const SalesSummary({
    required this.totalAmount,
    required this.salesCount,
    required this.cashTotal,
    required this.cardTotal,
    required this.transferTotal,
    required this.creditTotal,
  });
}

class ProfitSummary {
  final int approximateProfit;

  const ProfitSummary({required this.approximateProfit});
}

class DetailedProfitBreakdown {
  // Sales breakdown
  final int totalSalesBeforeDiscount;
  final int totalDiscounts;
  final int netSalesRevenue;
  final int costOfGoodsSold;
  final int salesProfit;

  // Other profits
  final int repairsProfit;
  final int servicesProfit;
  final int telelinkProfit;
  final int electricityProfit;

  // Totals
  final int totalRevenue;
  final int totalProfit;

  const DetailedProfitBreakdown({
    required this.totalSalesBeforeDiscount,
    required this.totalDiscounts,
    required this.netSalesRevenue,
    required this.costOfGoodsSold,
    required this.salesProfit,
    required this.repairsProfit,
    required this.servicesProfit,
    required this.telelinkProfit,
    required this.electricityProfit,
    required this.totalRevenue,
    required this.totalProfit,
  });
}

class RepairStats {
  final int total;
  final int readyCount;
  final int deliveredCount;
  final int overdueCount;

  const RepairStats({
    required this.total,
    required this.readyCount,
    required this.deliveredCount,
    required this.overdueCount,
  });
}

class TopPartUsage {
  final String productId;
  final String productName;
  final int totalQty;

  const TopPartUsage({
    required this.productId,
    required this.productName,
    required this.totalQty,
  });

  TopPartUsage copyWith({int? totalQty}) {
    return TopPartUsage(
      productId: productId,
      productName: productName,
      totalQty: totalQty ?? this.totalQty,
    );
  }
}

class CustomerWithStats {
  final Customer customer;
  final int totalPurchasesCents;
  final int salesCount;

  const CustomerWithStats({
    required this.customer,
    required this.totalPurchasesCents,
    required this.salesCount,
  });
}

class SaleWithItems {
  final Sale sale;
  final List<SaleItemWithProduct> items;

  const SaleWithItems({required this.sale, required this.items});
}

class SaleWithCustomer {
  final Sale sale;
  final Customer? customer;

  const SaleWithCustomer({required this.sale, required this.customer});
}

class SaleItemWithProduct {
  final SaleItem saleItem;
  final Product product;

  const SaleItemWithProduct({required this.saleItem, required this.product});
}

class SalesSummaryBasic {
  final int count;
  final int totalCents;

  const SalesSummaryBasic({required this.count, required this.totalCents});
}

// Purchase Invoice data classes

class PurchaseInvoiceItemInput {
  final String productId;
  final int qty;
  final int purchasePrice;
  final int salePrice;
  final int lineTotal;

  const PurchaseInvoiceItemInput({
    required this.productId,
    required this.qty,
    required this.purchasePrice,
    required this.salePrice,
    required this.lineTotal,
  });
}

class PurchaseInvoiceWithItems {
  final PurchaseInvoice invoice;
  final List<PurchaseInvoiceItemWithProduct> items;

  const PurchaseInvoiceWithItems({required this.invoice, required this.items});
}

class PurchaseInvoiceItemWithProduct {
  final PurchaseInvoiceItem item;
  final Product product;

  const PurchaseInvoiceItemWithProduct({
    required this.item,
    required this.product,
  });
}

// Purchase (from suppliers) data classes

class PurchaseItemInput {
  final String productId;
  final int qty;
  final int unitCost;
  final int lineTotal;

  const PurchaseItemInput({
    required this.productId,
    required this.qty,
    required this.unitCost,
    required this.lineTotal,
  });
}

class PurchaseItemWithProduct {
  final PurchaseItem item;
  final Product product;

  const PurchaseItemWithProduct({required this.item, required this.product});
}

class PurchaseWithItems {
  final Purchase purchase;
  final List<PurchaseItemWithProduct> items;
  final Supplier? supplier;

  const PurchaseWithItems({
    required this.purchase,
    required this.items,
    this.supplier,
  });
}

class SupplierSummary {
  final Supplier supplier;
  final int totalPurchased; // Total purchase amount in cents
  final int totalPaid; // Total paid amount in cents
  final int balance; // Outstanding balance (totalPurchased - totalPaid)
  final int totalItems; // Line items across all purchases
  final int totalInvoices; // Number of invoices

  const SupplierSummary({
    required this.supplier,
    required this.totalPurchased,
    required this.totalPaid,
    required this.balance,
    required this.totalItems,
    required this.totalInvoices,
  });
}

class PurchasePaymentRecord {
  final String id;
  final String? purchaseId; // Nullable for general payments
  final String supplierId;
  final int amount;
  final String? description;
  final DateTime paymentDate;
  final DateTime createdAt;

  const PurchasePaymentRecord({
    required this.id,
    this.purchaseId,
    required this.supplierId,
    required this.amount,
    this.description,
    required this.paymentDate,
    required this.createdAt,
  });
}

// Combined model for purchases and general payments
class PurchaseOrPayment {
  final String id;
  final String type; // 'purchase' or 'payment'
  final String? supplierId;
  final String? supplierName;
  final String? invoiceNumber;
  final int total;
  final int paid;
  final String? description;
  final DateTime createdAt;

  const PurchaseOrPayment({
    required this.id,
    required this.type,
    this.supplierId,
    this.supplierName,
    this.invoiceNumber,
    required this.total,
    required this.paid,
    this.description,
    required this.createdAt,
  });

  bool get isPaid => paid >= total;
  int get balance => total - paid;
}

class SupplierRequestedProduct {
  final String id;
  final String supplierId;
  final String productName;
  final int requestedQty;
  final String? customerNote;
  final String status; // pending, ordered, received, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierRequestedProduct({
    required this.id,
    required this.supplierId,
    required this.productName,
    required this.requestedQty,
    this.customerNote,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

class MissingProductNote {
  final String id;
  final String itemName;
  final int requestedQty;
  final String? customerNote;
  final String status; // open, done
  final DateTime createdAt;
  final DateTime updatedAt;

  const MissingProductNote({
    required this.id,
    required this.itemName,
    required this.requestedQty,
    this.customerNote,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

extension DashboardQueries on AppDatabase {
  /// Get all sales from today
  Future<List<Sale>> getTodaySales() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(sales)..where(
          (s) =>
              s.createdAt.isBiggerOrEqualValue(startOfDay) &
              s.createdAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }

  /// Get all repairs from today
  Future<List<Repair>> getTodayRepairs() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(repairs)..where(
          (r) =>
              r.createdAt.isBiggerOrEqualValue(startOfDay) &
              r.createdAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }
}
