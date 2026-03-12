import '../models/product_model.dart';

/// Repository interface for products
/// Abstracts the data source (local Drift vs remote Supabase)
abstract class ProductsRepository {
  /// Get all products
  Future<List<ProductModel>> getAll();

  /// Get a product by ID
  Future<ProductModel?> getById(String id);

  /// Search products
  Future<List<ProductModel>> search(String query);

  /// Get products by category
  Future<List<ProductModel>> getByCategory(String category);

  /// Create a new product
  Future<ProductModel> create(ProductModel product);

  /// Update an existing product
  Future<ProductModel> update(ProductModel product);

  /// Delete a product
  Future<void> delete(String id);

  /// Update product quantity
  Future<ProductModel> updateQuantity(String id, int newQty);

  /// Increment product quantity
  Future<ProductModel> incrementQuantity(String id, int amount);

  /// Decrement product quantity
  Future<ProductModel> decrementQuantity(String id, int amount);

  /// Watch all products with real-time updates
  Stream<List<ProductModel>> watchAll();

  /// Watch a single product with real-time updates
  Stream<ProductModel?> watchById(String id);

  /// Batch upsert products (for migration)
  Future<List<ProductModel>> batchUpsert(List<ProductModel> products);
}
