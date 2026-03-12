import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/db_provider.dart';
import '../data/datasources/products_remote_datasource.dart';
import '../data/repositories/products_repository_impl.dart';
import '../domain/models/product_model.dart';
import '../domain/repositories/products_repository.dart';

/// Provider for the remote data source
final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((
  ref,
) {
  return ProductsRemoteDataSource();
});

/// Provider for the products repository
/// Uses Supabase as primary source with Drift as local cache
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(
    remoteDataSource: ref.watch(productsRemoteDataSourceProvider),
    localDatabase: ref.watch(dbProvider),
    useLocalCache: true,
  );
});

/// Stream provider for all products (real-time)
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchAll();
});

/// Stream provider for a specific product by ID (real-time)
final productByIdStreamProvider = StreamProvider.family<ProductModel?, String>((
  ref,
  id,
) {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.watchById(id);
});

/// Future provider for all products (one-time fetch)
final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productsRepositoryProvider);
  return await repository.getAll();
});

/// Future provider for product search
final productSearchProvider = FutureProvider.family<List<ProductModel>, String>(
  (ref, query) async {
    final repository = ref.watch(productsRepositoryProvider);
    return await repository.search(query);
  },
);

/// Future provider for products by category
final productsByCategoryProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, category) async {
      final repository = ref.watch(productsRepositoryProvider);
      return await repository.getByCategory(category);
    });
