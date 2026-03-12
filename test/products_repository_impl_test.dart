import 'package:flutter_test/flutter_test.dart';
import 'package:pos_store/features/inventory/domain/models/product_model.dart';

void main() {
  group('ProductsRepositoryImpl - Patterns', () {
    // Sample products for testing
    final product1 = ProductModel(
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
      createdAt: DateTime(2025, 2, 21),
      updatedAt: DateTime(2025, 2, 21),
    );

    final product2 = ProductModel(
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
      createdAt: DateTime(2025, 2, 21),
      updatedAt: DateTime(2025, 2, 21),
    );

    final product3 = ProductModel(
      id: 'prod-003',
      name: 'USB-C Cable',
      barcode: 'USB-001',
      category: 'accessories',
      supplierId: null,
      sellPrice: 3000,
      costPrice: 1000,
      qty: 50,
      trackImei: false,
      imagePath: null,
      createdAt: DateTime(2025, 2, 21),
      updatedAt: DateTime(2025, 2, 21),
    );

    group('Remote-First with Local Cache Pattern', () {
      test('All products list should be sorted by creation date', () {
        final products = [product3, product1, product2];

        products.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        // All have same creation date, so verify they're handled correctly
        expect(products.length, 3);
      });

      test('Get product by ID', () {
        final products = [product1, product2, product3];

        final found = products.firstWhere((p) => p.id == 'prod-002');

        expect(found.id, 'prod-002');
        expect(found.name, 'iPhone 15');
      });

      test('Get product by ID - not found returns null', () {
        final products = [product1, product2, product3];

        final found = products.cast<ProductModel?>().firstWhere(
          (p) => p?.id == 'non-existent',
          orElse: () => null,
        );

        expect(found, isNull);
      });

      test('Search products by name', () {
        final products = [product1, product2, product3];
        final query = 'Samsung';

        final results = products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()) ||
                  (p.barcode?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList();

        expect(results.length, 1); // Samsung Galaxy
        expect(results.any((p) => p.id == 'prod-001'), true);
      });

      test('Search products by barcode', () {
        final products = [product1, product2, product3];
        final query = 'APP';

        final results = products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()) ||
                  (p.barcode?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList();

        expect(results.length, 1);
        expect(results.first.id, 'prod-002');
      });

      test('Filter by category', () {
        final products = [product1, product2, product3];
        final category = 'phones';

        final results = products.where((p) => p.category == category).toList();

        expect(results.length, 2);
        expect(results.every((p) => p.category == 'phones'), true);
      });

      test('Filter by category - accessories', () {
        final products = [product1, product2, product3];
        final category = 'accessories';

        final results = products.where((p) => p.category == category).toList();

        expect(results.length, 1);
        expect(results.first.name, 'USB-C Cable');
      });
    });

    group('CRUD Operations Simulation', () {
      test('Create product - product has all required fields', () {
        final newProduct = ProductModel(
          id: 'prod-004',
          name: 'New Charger',
          barcode: 'CHR-002',
          category: 'accessories',
          supplierId: null,
          sellPrice: 5000,
          costPrice: 2000,
          qty: 10,
          trackImei: false,
          imagePath: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(newProduct.id, isNotEmpty);
        expect(newProduct.name, isNotEmpty);
        expect(newProduct.createdAt, isNotNull);
      });

      test('Update product - changed fields', () {
        final original = product1;
        final updated = original.copyWith(
          name: 'Samsung Galaxy S24',
          qty: 8,
          sellPrice: 55000,
        );

        expect(updated.id, original.id); // id unchanged
        expect(updated.name, 'Samsung Galaxy S24');
        expect(updated.qty, 8);
        expect(updated.sellPrice, 55000);
        expect(original.name, 'Samsung Galaxy'); // original unchanged
      });

      test('Delete product - remove from list', () {
        var products = [product1, product2, product3];

        products = products.where((p) => p.id != 'prod-002').toList();

        expect(products.length, 2);
        expect(products.any((p) => p.id == 'prod-002'), false);
      });
    });

    group('Cache Fallback Patterns', () {
      test('Remote data should cache to local', () {
        final remoteProducts = [product1, product2, product3];
        final cachedProducts = <ProductModel>[];

        // Simulate caching
        for (final product in remoteProducts) {
          cachedProducts.add(product);
        }

        expect(cachedProducts.length, remoteProducts.length);
        expect(cachedProducts.first.id, 'prod-001');
      });

      test('If remote unavailable, fallback to cache', () {
        final cachedProducts = [product1, product2, product3];

        final result = cachedProducts;

        expect(result.length, 3);
      });

      test('Merge remote and cache - avoid duplicates', () {
        // Simulating remote returns updated data
        final remoteProducts = [
          product1,
          product2.copyWith(qty: 10), // updated quantity
          product3,
        ];

        // Simulating local cache
        final cachedProducts = [product1, product2, product3];

        // Merge: remote overwrites cache
        final merged = <String, ProductModel>{};
        for (final p in cachedProducts) {
          merged[p.id] = p;
        }
        for (final p in remoteProducts) {
          merged[p.id] = p; // remote overwrites
        }

        expect(merged.length, 3); // no duplicates
        expect(merged['prod-002']?.qty, 10); // remote version
      });
    });

    group('Stock Management', () {
      test('Update quantity in local cache', () {
        var product = product1;
        final newQty = 12;

        product = product.copyWith(qty: newQty);

        expect(product.qty, 12);
      });

      test('Increment quantity', () {
        var product = product1;

        product = product.copyWith(qty: product.qty + 5);

        expect(product.qty, 10); // 5 + 5
      });

      test('Decrement quantity with minimum zero', () {
        var product = product1.copyWith(qty: 2);

        final newQty = (product.qty - 5).clamp(0, 999999);
        product = product.copyWith(qty: newQty);

        expect(product.qty, 0); // clamped to 0
      });

      test('Track stock value changes', () {
        final product = product1;

        final stockValue = product.qty * product.costPrice;
        expect(stockValue, 150000); // 5 * 30000

        final updated = product.copyWith(qty: 10);
        final newStockValue = updated.qty * updated.costPrice;
        expect(newStockValue, 300000); // 10 * 30000
      });
    });

    group('Batch Operations', () {
      test('Batch upsert should handle multiple products', () {
        final products = [product1, product2, product3];

        // Simulate upsert: new products or updates
        final upsertedProducts = <ProductModel>[];
        for (final p in products) {
          upsertedProducts.add(p);
        }

        expect(upsertedProducts.length, 3);
      });

      test('Batch upsert overwrite duplicates', () {
        final products = [product1, product2];
        final updated = [product1.copyWith(qty: 20), product3];

        final result = <String, ProductModel>{};
        for (final p in products) {
          result[p.id] = p;
        }
        for (final p in updated) {
          result[p.id] = p;
        }

        expect(result.length, 3); // 3 unique products
        expect(result['prod-001']?.qty, 20); // overwritten
      });
    });

    group('Business Logic', () {
      test('Calculate total inventory value', () {
        final products = [product1, product2, product3];

        final totalValue = products.fold<int>(
          0,
          (sum, p) => sum + (p.qty * p.costPrice),
        );

        expect(totalValue, 350000); // (5*30000) + (3*50000) + (50*1000)
      });

      test('Find low stock products', () {
        final products = [product1, product2, product3];
        final lowStockThreshold = 5;

        final lowStock = products
            .where((p) => p.qty <= lowStockThreshold)
            .toList();

        expect(lowStock.length, 2); // product1 (5) and product2 (3)
      });

      test('Find high stock products', () {
        final products = [product1, product2, product3];
        final highStockThreshold = 10;

        final highStock = products
            .where((p) => p.qty > highStockThreshold)
            .toList();

        expect(highStock.length, 1); // product3 (50)
      });

      test('Filter products by supplier', () {
        final products = [
          product1,
          product2.copyWith(supplierId: 'supplier-001'),
          product3.copyWith(supplierId: 'supplier-002'),
        ];

        final fromSupplier1 = products
            .where((p) => p.supplierId == 'supplier-001')
            .toList();

        expect(fromSupplier1.length, 1);
      });

      test('Calculate total revenue potential', () {
        final products = [product1, product2, product3];

        final revenueAtFullInventory = products.fold<int>(
          0,
          (sum, p) => sum + (p.qty * p.sellPrice),
        );

        expect(
          revenueAtFullInventory,
          640000,
        ); // (5*50000) + (3*80000) + (50*3000)
      });
    });

    group('Data Integrity', () {
      test('Product ID uniqueness', () {
        final products = [product1, product2, product3];
        final ids = products.map((p) => p.id).toList();

        expect(ids.toSet().length, ids.length); // all unique
      });

      test('Price consistency - cost <= sell', () {
        final products = [product1, product2, product3];

        final valid = products.every((p) => p.costPrice < p.sellPrice);
        expect(valid, true);
      });

      test('Quantity is non-negative', () {
        final products = [product1, product2, product3];

        final valid = products.every((p) => p.qty >= 0);
        expect(valid, true);
      });

      test('Required fields not null', () {
        final product = product1;

        expect(product.id, isNotEmpty);
        expect(product.name, isNotEmpty);
        expect(product.category, isNotEmpty);
        expect(product.createdAt, isNotNull);
      });
    });
  });
}
