import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../domain/models/product_model.dart';

/// Exception thrown when a product operation fails
class ProductRemoteException implements Exception {
  final String message;
  final Object? originalError;

  ProductRemoteException(this.message, [this.originalError]);

  @override
  String toString() =>
      'ProductRemoteException: $message${originalError != null ? ' ($originalError)' : ''}';
}

/// Remote data source for products using Supabase
class ProductsRemoteDataSource {
  final SupabaseClient _client;
  final String _tableName = 'products';

  ProductsRemoteDataSource({SupabaseClient? client})
    : _client = client ?? SupabaseConfig.client;

  /// Create a new product
  Future<ProductModel> create(ProductModel product) async {
    try {
      final response = await _client
          .from(_tableName)
          .insert(product.toJson())
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      throw ProductRemoteException('Failed to create product', e);
    }
  }

  /// Update an existing product
  Future<ProductModel> update(ProductModel product) async {
    try {
      final response = await _client
          .from(_tableName)
          .update(product.toJson())
          .eq('id', product.id)
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      throw ProductRemoteException('Failed to update product', e);
    }
  }

  /// Delete a product by ID
  /// Also deletes all related records in other tables
  Future<void> delete(String id) async {
    try {
      // Delete all repair parts referencing this product
      await _client
          .from('repair_parts')
          .delete()
          .eq('product_id', id);

      // Delete all sale items referencing this product
      await _client
          .from('sale_items')
          .delete()
          .eq('product_id', id);

      // Delete all purchase items referencing this product
      await _client
          .from('purchase_items')
          .delete()
          .eq('product_id', id);

      // Delete all purchase invoice items referencing this product
      await _client
          .from('purchase_invoice_items')
          .delete()
          .eq('product_id', id);

      // Now delete the product itself
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw ProductRemoteException('Failed to delete product', e);
    }
  }

  /// Get a product by ID
  Future<ProductModel?> getById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ProductRemoteException('Failed to fetch product by ID', e);
    }
  }

  /// Get all products
  Future<List<ProductModel>> getAll() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ProductRemoteException('Failed to fetch all products', e);
    }
  }

  /// Search products by name or barcode
  Future<List<ProductModel>> search(String query) async {
    try {
      if (query.isEmpty) return getAll();

      final response = await _client
          .from(_tableName)
          .select()
          .or('name.ilike.%$query%,barcode.ilike.%$query%')
          .order('name');

      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ProductRemoteException('Failed to search products', e);
    }
  }

  /// Get products by category
  Future<List<ProductModel>> getByCategory(String category) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('category', category)
          .order('name');

      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ProductRemoteException('Failed to fetch products by category', e);
    }
  }

  /// Update product quantity (for stock management)
  Future<ProductModel> updateQuantity(String id, int newQty) async {
    try {
      final response = await _client
          .from(_tableName)
          .update({'qty': newQty})
          .eq('id', id)
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      throw ProductRemoteException('Failed to update product quantity', e);
    }
  }

  /// Increment product quantity (for purchases)
  Future<ProductModel> incrementQuantity(String id, int amount) async {
    try {
      // Fetch current product
      final product = await getById(id);
      if (product == null) {
        throw ProductRemoteException('Product not found');
      }

      final newQty = product.qty + amount;
      return updateQuantity(id, newQty);
    } catch (e) {
      throw ProductRemoteException('Failed to increment product quantity', e);
    }
  }

  /// Decrement product quantity (for sales)
  Future<ProductModel> decrementQuantity(String id, int amount) async {
    try {
      // Fetch current product
      final product = await getById(id);
      if (product == null) {
        throw ProductRemoteException('Product not found');
      }

      final newQty = (product.qty - amount).clamp(0, double.infinity).toInt();
      return updateQuantity(id, newQty);
    } catch (e) {
      throw ProductRemoteException('Failed to decrement product quantity', e);
    }
  }

  /// Stream products with real-time updates
  Stream<List<ProductModel>> watchAll() {
    try {
      final controller = StreamController<List<ProductModel>>();

      // Initial fetch
      getAll()
          .then((products) {
            if (!controller.isClosed) {
              controller.add(products);
            }
          })
          .catchError((e) {
            if (!controller.isClosed) {
              controller.addError(
                ProductRemoteException('Failed to fetch products', e),
              );
            }
          });

      // Subscribe to real-time changes
      final subscription = _client
          .from(_tableName)
          .stream(primaryKey: ['id'])
          .listen((data) {
            if (!controller.isClosed) {
              final products = (data as List)
                  .map(
                    (json) =>
                        ProductModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
              controller.add(products);
            }
          });

      // Clean up on close
      controller.onCancel = () {
        subscription.cancel();
      };

      return controller.stream;
    } catch (e) {
      throw ProductRemoteException('Failed to watch products', e);
    }
  }

  /// Stream a single product with real-time updates
  Stream<ProductModel?> watchById(String id) {
    try {
      return _client
          .from(_tableName)
          .stream(primaryKey: ['id'])
          .eq('id', id)
          .map((data) {
            if (data.isEmpty) return null;
            return ProductModel.fromJson(data.first);
          });
    } catch (e) {
      throw ProductRemoteException('Failed to watch product', e);
    }
  }

  /// Batch upsert products (for migration)
  Future<List<ProductModel>> batchUpsert(List<ProductModel> products) async {
    try {
      if (products.isEmpty) return [];

      final response = await _client
          .from(_tableName)
          .upsert(products.map((p) => p.toJson()).toList(), onConflict: 'id')
          .select();

      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ProductRemoteException('Failed to batch upsert products', e);
    }
  }
}
