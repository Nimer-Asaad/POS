import 'package:flutter_test/flutter_test.dart';

import 'package:pos_store/data/db/app_database.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Use in-memory database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Repair Database Logic', () {
    test('createRepairPhase1 stores estimated cost', () async {
      // Act
      final repairId = await db.createRepairPhase1(
        customerName: 'Test Customer',
        device: 'Test Device',
        issue: 'Broken Screen',
        estimatedCost: 15000, // 150.00
        paidAtReceive: 5000, // 50.00
      );

      // Assert
      final repair = await (db.select(
        db.repairs,
      )..where((t) => t.id.equals(repairId))).getSingle();
      expect(repair.estimatedCost, equals(15000));
      expect(repair.paidAtReceive, equals(5000));
      expect(repair.status, equals('Received'));
    });

    test('addRepairPart decreases stock and links part', () async {
      // Arrange
      // 1. Create product
      final productId = 'prod-1';
      await db.addProduct(
        id: productId,
        name: 'Screen',
        category: 'Parts',
        sellPrice: 10000,
        costPrice: 5000,
        qty: 10,
        trackImei: false,
      );

      // 2. Create repair
      final repairId = await db.createRepairPhase1(
        customerName: 'Customer',
        device: 'Phone',
        issue: 'Fix',
        estimatedCost: 0,
        paidAtReceive: 0,
      );

      // Act
      await db.addRepairPart(
        repairId: repairId,
        productId: productId,
        qty: 1,
        unitPrice: 10000,
      );

      // Assert
      // Check repair parts
      final parts = await db.getRepairParts(repairId);
      expect(parts.length, equals(1));
      expect(parts.first.repairPart.productId, equals(productId));

      // Check stock decreased
      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(productId))).getSingle();
      expect(product.qty, equals(9));
    });

    test('createProductWithSupplier creates supplier and product', () async {
      // Act
      final productId = await db.createProductWithSupplier(
        name: 'External Part',
        sellPrice: 20000,
        costPrice: 15000,
        supplierName: 'New Supplier',
      );

      // Assert
      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(productId))).getSingle();
      expect(product.name, equals('External Part'));
      expect(product.supplierId, isNotNull);

      final supplier = await (db.select(
        db.suppliers,
      )..where((t) => t.id.equals(product.supplierId!))).getSingle();
      expect(supplier.name, equals('New Supplier'));
    });

    test('repair profit calculates correctly with discount', () async {
      // Arrange: Create product with cost price
      final productId = 'prod-screen';
      await db.addProduct(
        id: productId,
        name: 'شاشة تكنو',
        category: 'قطع صيانة',
        sellPrice: 12000, // 120 sell price
        costPrice: 5000,  // 50 cost price
        qty: 10,
        trackImei: false,
      );

      // Create repair
      final repairId = await db.createRepairPhase1(
        customerName: 'حمودي حلبي',
        device: 'تكنو',
        model: 'go 2023',
        issue: 'شاشة',
        estimatedCost: 12000,
        paidAtReceive: 0,
      );

      // Add part to repair
      await db.addRepairPart(
        repairId: repairId,
        productId: productId,
        qty: 1,
        unitPrice: 12000, // Selling for 120
      );

      // Finalize with discount
      await db.finalizeRepairDelivery(
        repairId: repairId,
        finalCost: 12000,    // Parts total: 120
        discount: 2000,      // Discount: 20
        paidAtDelivery: 10000, // Paid 100 at delivery
      );

      // Act: Calculate profit
      final profit = await db.getTodayRepairsProfit();

      // Assert: Profit should be (120 - 20) - 50 = 50
      expect(profit, equals(5000)); // 50.00 in cents
    });

    test('maintenance devices count increases for non-delivered repairs', () async {
      // Arrange: Start with no repairs
      int count = await db.getCurrentMaintenanceDevicesCount();
      expect(count, equals(0));

      // Act 1: Create repair (status = 'Received')
      await db.createRepairPhase1(
        customerName: 'Customer 1',
        device: 'Device 1',
        issue: 'Issue 1',
        estimatedCost: 10000,
        paidAtReceive: 0,
      );

      // Assert 1: Count should increase to 1
      count = await db.getCurrentMaintenanceDevicesCount();
      expect(count, equals(1));

      // Act 2: Create another repair
      final repairId2 = await db.createRepairPhase1(
        customerName: 'Customer 2',
        device: 'Device 2',
        issue: 'Issue 2',
        estimatedCost: 15000,
        paidAtReceive: 5000,
      );

      // Assert 2: Count should be 2
      count = await db.getCurrentMaintenanceDevicesCount();
      expect(count, equals(2));

      // Act 3: Deliver one repair
      await db.finalizeRepairDelivery(
        repairId: repairId2,
        finalCost: 15000,
        discount: 0,
        paidAtDelivery: 10000,
      );

      // Assert 3: Count should decrease to 1 (only non-delivered counted)
      count = await db.getCurrentMaintenanceDevicesCount();
      expect(count, equals(1));
    });
  });
}
