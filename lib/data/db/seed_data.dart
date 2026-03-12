import 'package:uuid/uuid.dart';

import 'app_database.dart';

/// Seeds initial demo data into the database
class DatabaseSeeder {
  static const _uuid = Uuid();

  /// Check if database has any data
  static Future<bool> isDatabaseEmpty(AppDatabase db) async {
    final productCount = await db.getProductCount();
    return productCount == 0;
  }

  /// Seed demo products for testing
  static Future<void> seedDemoData(AppDatabase db) async {
    print('🌱 Seeding demo data...');

    // Add sample products
    final products = [
      {
        'name': 'شاشة سامسونج',
        'nameEn': 'Samsung Screen',
        'category': 'Screens',
        'sellPrice': 25000,
        // 250 SAR
        'costPrice': 18000,
        // 180 SAR
        'qty': 10,
      },
      {
        'name': 'بطارية آيفون 13',
        'nameEn': 'iPhone 13 Battery',
        'category': 'Batteries',
        'sellPrice': 15000,
        // 150 SAR
        'costPrice': 12000,
        // 120 SAR
        'qty': 15,
      },
      {
        'name': 'سماعة بلوتوث',
        'nameEn': 'Bluetooth Headset',
        'category': 'Accessories',
        'sellPrice': 8000,
        // 80 SAR
        'costPrice': 5000,
        // 50 SAR
        'qty': 20,
      },
      {
        'name': 'كفر حماية',
        'nameEn': 'Protective Case',
        'category': 'Accessories',
        'sellPrice': 3000,
        // 30 SAR
        'costPrice': 1500,
        // 15 SAR
        'qty': 50,
      },
      {
        'name': 'شاحن سريع',
        'nameEn': 'Fast Charger',
        'category': 'Chargers',
        'sellPrice': 5000,
        // 50 SAR
        'costPrice': 3000,
        // 30 SAR
        'qty': 30,
      },
    ];

    for (final product in products) {
      try {
        await db.addProduct(
          id: _uuid.v4(),
          name: '${product['name']} / ${product['nameEn']}',
          barcode: null,
          category: product['category'] as String,
          sellPrice: product['sellPrice'] as int,
          costPrice: product['costPrice'] as int,
          qty: product['qty'] as int,
          trackImei: false,
          imagePath: null,
        );
        print('✅ Added product: ${product['name']}');
      } catch (e) {
        print('❌ Failed to add product ${product['name']}: $e');
      }
    }

    // Add a sample customer
    try {
      await db.upsertCustomer(
        id: _uuid.v4(),
        name: 'عميل تجريبي / Demo Customer',
        phone: '0501234567',
      );
      print('✅ Added demo customer');
    } catch (e) {
      print('❌ Failed to add customer: $e');
    }

    print('🌱 Demo data seeding completed!');
  }

  /// Initialize database with demo data if empty
  static Future<void> initializeIfNeeded(AppDatabase db) async {
    try {
      final isEmpty = await isDatabaseEmpty(db);
      if (isEmpty) {
        print('📦 Database is empty, seeding demo data...');
        await seedDemoData(db);
      } else {
        print('✅ Database already has data');
      }
    } catch (e, stack) {
      print('❌ Error checking/seeding database: $e');
      print('Stack: $stack');
      // Don't rethrow - app should still work with empty database
    }
  }
}
