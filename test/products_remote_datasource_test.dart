import 'package:flutter_test/flutter_test.dart';

import 'package:pos_store/features/inventory/domain/models/product_model.dart';

void main() {
  group('ProductModel - Data Conversion', () {
    group('Product CRUD Operations', () {
      final testProduct = ProductModel(
        id: 'prod-001',
        name: 'Test Product',
        barcode: 'BAR-001',
        category: 'Electronics',
        supplierId: null,
        sellPrice: 10000, // 100.00
        costPrice: 5000, // 50.00
        qty: 10,
        trackImei: false,
        imagePath: null,
        createdAt: DateTime(2025, 2, 21),
        updatedAt: DateTime(2025, 2, 21),
      );

      test('Create product should convert to JSON correctly', () {
        final json = testProduct.toJson();

        expect(json['id'], 'prod-001');
        expect(json['name'], 'Test Product');
        expect(json['barcode'], 'BAR-001');
        expect(json['category'], 'Electronics');
        expect(json['sell_price'], 10000);
        expect(json['cost_price'], 5000);
        expect(json['qty'], 10);
        expect(json['track_imei'], false);
      });

      test('Product JSON to Model conversion', () {
        final json = {
          'id': 'prod-001',
          'name': 'Test Product',
          'barcode': 'BAR-001',
          'category': 'Electronics',
          'supplier_id': null,
          'sell_price': 10000,
          'cost_price': 5000,
          'qty': 10,
          'track_imei': false,
          'image_path': null,
          'created_at': '2025-02-21T00:00:00.000Z',
          'updated_at': '2025-02-21T00:00:00.000Z',
        };

        final product = ProductModel.fromJson(json);

        expect(product.id, 'prod-001');
        expect(product.name, 'Test Product');
        expect(product.barcode, 'BAR-001');
        expect(product.category, 'Electronics');
        expect(product.qty, 10);
      });

      test('Product copyWith should update specific fields', () {
        final updated = testProduct.copyWith(name: 'Updated Product', qty: 20);

        expect(updated.name, 'Updated Product');
        expect(updated.qty, 20);
        expect(updated.id, testProduct.id); // id unchanged
        expect(updated.barcode, testProduct.barcode); // barcode unchanged
      });

      test('Product with null optional fields', () {
        final json = {
          'id': 'prod-002',
          'name': 'Simple Product',
          'barcode': null,
          'category': 'General',
          'supplier_id': null,
          'sell_price': 5000,
          'cost_price': 2500,
          'qty': 5,
          'track_imei': false,
          'image_path': null,
          'created_at': '2025-02-21T00:00:00.000Z',
          'updated_at': null,
        };

        final product = ProductModel.fromJson(json);

        expect(product.barcode, isNull);
        expect(product.supplierId, isNull);
        expect(product.imagePath, isNull);
        expect(product.updatedAt, isNull);
      });

      test('Product with IMEI tracking', () {
        final phoneProduct = testProduct.copyWith(
          category: 'phones',
          trackImei: true,
        );

        expect(phoneProduct.category, 'phones');
        expect(phoneProduct.trackImei, true);

        final json = phoneProduct.toJson();
        expect(json['track_imei'], true);
      });
    });

    group('Search and Filter', () {
      test('Product search by name', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Samsung Galaxy',
          barcode: 'SAM-001',
          category: 'phones',
          supplierId: null,
          sellPrice: 50000,
          costPrice: 30000,
          qty: 5,
          trackImei: true,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final searchQuery = 'Samsung';
        final matches = product.name.contains(searchQuery);

        expect(matches, true);
      });

      test('Product search by barcode', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Phone',
          barcode: 'SN123456',
          category: 'phones',
          supplierId: null,
          sellPrice: 50000,
          costPrice: 30000,
          qty: 5,
          trackImei: true,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final searchQuery = 'SN123';
        final matches = (product.barcode?.contains(searchQuery) ?? false);

        expect(matches, true);
      });

      test('Product filter by category', () {
        final products = [
          ProductModel(
            id: 'prod-001',
            name: 'Samsung Galaxy',
            barcode: 'SAM-001',
            category: 'phones',
            supplierId: null,
            sellPrice: 50000,
            costPrice: 30000,
            qty: 5,
            trackImei: true,
            imagePath: null,
            createdAt: DateTime.now(),
            updatedAt: null,
          ),
          ProductModel(
            id: 'prod-002',
            name: 'iPhone 15',
            barcode: 'APP-001',
            category: 'phones',
            supplierId: null,
            sellPrice: 80000,
            costPrice: 50000,
            qty: 3,
            trackImei: true,
            imagePath: null,
            createdAt: DateTime.now(),
            updatedAt: null,
          ),
          ProductModel(
            id: 'prod-003',
            name: 'Samsung Charger',
            barcode: 'CHR-001',
            category: 'accessories',
            supplierId: null,
            sellPrice: 5000,
            costPrice: 2000,
            qty: 20,
            trackImei: false,
            imagePath: null,
            createdAt: DateTime.now(),
            updatedAt: null,
          ),
        ];

        final phonesOnly = products
            .where((p) => p.category == 'phones')
            .toList();

        expect(phonesOnly.length, 2);
        expect(phonesOnly.every((p) => p.category == 'phones'), true);
      });
    });

    group('Stock Management', () {
      test('Calculate stock value', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final stockValue = product.qty * product.costPrice;
        expect(stockValue, 50000); // 10 * 5000
      });

      test('Update quantity', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final updated = product.copyWith(qty: 15);
        expect(updated.qty, 15);
        expect(product.qty, 10); // original unchanged
      });

      test('Decrement quantity with minimum zero', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 5,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        // Try to decrement by 10 (exceed current qty)
        final newQty = (product.qty - 10).clamp(0, 999999);
        final updated = product.copyWith(qty: newQty);

        expect(updated.qty, 0); // clamped to minimum
      });

      test('Increment quantity', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final updated = product.copyWith(qty: product.qty + 5);
        expect(updated.qty, 15);
      });
    });

    group('Pricing', () {
      test('Calculate profit', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final profit = product.sellPrice - product.costPrice;
        expect(profit, 5000); // 10000 - 5000
      });

      test('Calculate profit margin percentage', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        final margin =
            ((product.sellPrice - product.costPrice) / product.costPrice) * 100;
        expect(margin, 100.0); // 100% margin
      });

      test('Handle products with zero cost price', () {
        final product = ProductModel(
          id: 'prod-001',
          name: 'Free Product',
          barcode: 'FREE-001',
          category: 'Promotional',
          supplierId: null,
          sellPrice: 0,
          costPrice: 0,
          qty: 100,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        expect(product.sellPrice, 0);
        expect(product.costPrice, 0);
      });
    });

    group('Date Handling', () {
      test('Product timestamp tracking', () {
        final now = DateTime.now();
        final product = ProductModel(
          id: 'prod-001',
          name: 'Test Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: now,
          updatedAt: now,
        );

        expect(product.createdAt.year, now.year);
        expect(product.updatedAt?.year, now.year);
      });

      test('Product with null updated timestamp', () {
        final now = DateTime.now();
        final product = ProductModel(
          id: 'prod-001',
          name: 'New Product',
          barcode: 'BAR-001',
          category: 'Electronics',
          supplierId: null,
          sellPrice: 10000,
          costPrice: 5000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: now,
          updatedAt: null, // not yet updated
        );

        expect(product.updatedAt, isNull);
      });
    });
  });
}
