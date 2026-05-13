import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/database/auto_sync_extension.dart';
import '../../../../data/db/app_database.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

/// Products repository implementation using Supabase as primary source
/// with optional Drift cache
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final AppDatabase? _localDatabase;
  final bool _useLocalCache;

  ProductsRepositoryImpl({
    ProductsRemoteDataSource? remoteDataSource,
    AppDatabase? localDatabase,
    bool useLocalCache = true,
  }) : _remoteDataSource = remoteDataSource ?? ProductsRemoteDataSource(),
       _localDatabase = localDatabase,
       _useLocalCache = useLocalCache && localDatabase != null;

  /// Helper to check if Supabase is available
  bool get _isOnline => SupabaseConfig.isInitialized;

  @override
  Future<List<ProductModel>> getAll() async {
    try {
      if (_isOnline) {
        final products = await _remoteDataSource.getAll();

        // Cache to local if enabled
        if (_useLocalCache && _localDatabase != null) {
          await _cacheProducts(products);
        }

        return products;
      } else {
        // Fallback to local database
        return await _getFromLocal();
      }
    } catch (e) {
      print('Error fetching products from remote: $e');

      // Fallback to local cache
      if (_useLocalCache && _localDatabase != null) {
        print('Falling back to local cache...');
        return await _getFromLocal();
      }

      rethrow;
    }
  }

  @override
  Future<ProductModel?> getById(String id) async {
    try {
      if (_isOnline) {
        final product = await _remoteDataSource.getById(id);

        // Cache to local if enabled
        if (_useLocalCache && _localDatabase != null && product != null) {
          await _cacheProduct(product);
        }

        return product;
      } else {
        return await _getByIdFromLocal(id);
      }
    } catch (e) {
      print('Error fetching product by ID from remote: $e');

      // Fallback to local cache
      if (_useLocalCache && _localDatabase != null) {
        return await _getByIdFromLocal(id);
      }

      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> search(String query) async {
    try {
      if (_isOnline) {
        return await _remoteDataSource.search(query);
      } else {
        return await _searchLocal(query);
      }
    } catch (e) {
      print('Error searching products from remote: $e');

      // Fallback to local cache
      if (_useLocalCache && _localDatabase != null) {
        return await _searchLocal(query);
      }

      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getByCategory(String category) async {
    try {
      if (_isOnline) {
        final products = await _remoteDataSource.getByCategory(category);

        // Cache to local if enabled
        if (_useLocalCache && _localDatabase != null) {
          await _cacheProducts(products);
        }

        return products;
      } else {
        return await _getByCategoryFromLocal(category);
      }
    } catch (e) {
      print('Error fetching products by category from remote: $e');

      // Fallback to local cache
      if (_useLocalCache && _localDatabase != null) {
        return await _getByCategoryFromLocal(category);
      }

      rethrow;
    }
  }

  @override
  Future<ProductModel> create(ProductModel product) async {
    if (_useLocalCache && _localDatabase != null) {
      await _localDatabase!.addProductWithSync(product.toDriftCompanion());
      return product;
    }

    if (!_isOnline) {
      throw Exception('Cannot create product: offline mode');
    }

    final created = await _remoteDataSource.create(product);

    // Cache to local
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProduct(created);
    }

    return created;
  }

  @override
  Future<ProductModel> update(ProductModel product) async {
    if (_useLocalCache && _localDatabase != null) {
      await _localDatabase!.updateProductWithSync(product.toDrift());
      return product;
    }

    if (!_isOnline) {
      throw Exception('Cannot update product: offline mode');
    }

    final updated = await _remoteDataSource.update(product);

    // Update local cache
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProduct(updated);
    }

    return updated;
  }

  @override
  Future<void> delete(String id) async {
    // Delete from local database only
    if (_useLocalCache && _localDatabase != null) {
      await _deleteFromLocal(id);
    }
    // TODO: Re-enable Supabase sync in future
    // await _remoteDataSource.delete(id);
  }

  @override
  Future<ProductModel> updateQuantity(String id, int newQty) async {
    if (!_isOnline) {
      throw Exception('Cannot update quantity: offline mode');
    }

    final updated = await _remoteDataSource.updateQuantity(id, newQty);

    // Update local cache
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProduct(updated);
    }

    return updated;
  }

  @override
  Future<ProductModel> incrementQuantity(String id, int amount) async {
    if (!_isOnline) {
      throw Exception('Cannot increment quantity: offline mode');
    }

    final updated = await _remoteDataSource.incrementQuantity(id, amount);

    // Update local cache
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProduct(updated);
    }

    return updated;
  }

  @override
  Future<ProductModel> decrementQuantity(String id, int amount) async {
    if (!_isOnline) {
      throw Exception('Cannot decrement quantity: offline mode');
    }

    final updated = await _remoteDataSource.decrementQuantity(id, amount);

    // Update local cache
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProduct(updated);
    }

    return updated;
  }

  @override
  Stream<List<ProductModel>> watchAll() {
    // Always watch from local database for immediate updates
    // Remote changes will be synced to local and reflected automatically
    if (_useLocalCache && _localDatabase != null) {
      return _watchAllFromLocal();
    }

    if (_isOnline) {
      return _remoteDataSource.watchAll();
    } else {
      // Fallback to local stream
      return _watchAllFromLocal();
    }
  }

  @override
  Stream<ProductModel?> watchById(String id) {
    // Always watch from local database for immediate updates
    // Remote changes will be synced to local and reflected automatically
    if (_useLocalCache && _localDatabase != null) {
      return _watchByIdFromLocal(id);
    }

    if (_isOnline) {
      return _remoteDataSource.watchById(id);
    } else {
      // Fallback to local stream
      return _watchByIdFromLocal(id);
    }
  }

  @override
  Future<List<ProductModel>> batchUpsert(List<ProductModel> products) async {
    if (!_isOnline) {
      throw Exception('Cannot batch upsert: offline mode');
    }

    final upserted = await _remoteDataSource.batchUpsert(products);

    // Cache to local
    if (_useLocalCache && _localDatabase != null) {
      await _cacheProducts(upserted);
    }

    return upserted;
  }

  // ========================================================================
  // LOCAL CACHE HELPERS
  // ========================================================================

  Future<void> _cacheProduct(ProductModel product) async {
    if (_localDatabase == null) return;

    await _localDatabase
        .into(_localDatabase.products)
        .insertOnConflictUpdate(product.toDriftCompanion());
  }

  Future<void> _cacheProducts(List<ProductModel> products) async {
    if (_localDatabase == null) return;

    for (final product in products) {
      await _cacheProduct(product);
    }
  }

  Future<List<ProductModel>> _getFromLocal() async {
    if (_localDatabase == null) return [];

    final products = await _localDatabase.select(_localDatabase.products).get();
    return products.map((p) => ProductModel.fromDrift(p)).toList();
  }

  Future<ProductModel?> _getByIdFromLocal(String id) async {
    if (_localDatabase == null) return null;

    final product = await (_localDatabase.select(
      _localDatabase.products,
    )..where((p) => p.id.equals(id))).getSingleOrNull();

    return product != null ? ProductModel.fromDrift(product) : null;
  }

  Future<List<ProductModel>> _searchLocal(String query) async {
    if (_localDatabase == null) return [];

    final allProducts = await _localDatabase
        .select(_localDatabase.products)
        .get();
    final queryLower = query.toLowerCase();

    return allProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(queryLower) ||
              (p.barcode?.toLowerCase().contains(queryLower) ?? false),
        )
        .map((p) => ProductModel.fromDrift(p))
        .toList();
  }

  Future<List<ProductModel>> _getByCategoryFromLocal(String category) async {
    if (_localDatabase == null) return [];

    final products = await (_localDatabase.select(
      _localDatabase.products,
    )..where((p) => p.category.equals(category))).get();

    return products.map((p) => ProductModel.fromDrift(p)).toList();
  }

  Future<void> _deleteFromLocal(String id) async {
    if (_localDatabase == null) return;

    await _localDatabase.transaction(() async {
      // Delete all repair parts referencing this product
      await (_localDatabase.delete(
        _localDatabase.repairParts,
      )..where((rp) => rp.productId.equals(id))).go();

      // Delete all purchase items referencing this product
      await (_localDatabase.delete(
        _localDatabase.purchaseItems,
      )..where((pi) => pi.productId.equals(id))).go();

      // Delete all sale items referencing this product
      await (_localDatabase.delete(
        _localDatabase.saleItems,
      )..where((si) => si.productId.equals(id))).go();

      // Delete the product itself
      await (_localDatabase.delete(
        _localDatabase.products,
      )..where((p) => p.id.equals(id))).go();
    });
  }

  Stream<List<ProductModel>> _watchAllFromLocal() {
    if (_localDatabase == null) {
      return Stream.value([]);
    }

    return _localDatabase
        .select(_localDatabase.products)
        .watch()
        .map(
          (products) => products.map((p) => ProductModel.fromDrift(p)).toList(),
        );
  }

  Stream<ProductModel?> _watchByIdFromLocal(String id) {
    if (_localDatabase == null) {
      return Stream.value(null);
    }

    return (_localDatabase.select(
      _localDatabase.products,
    )..where((p) => p.id.equals(id))).watchSingleOrNull().map(
      (product) => product != null ? ProductModel.fromDrift(product) : null,
    );
  }
}
