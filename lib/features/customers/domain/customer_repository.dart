import 'package:drift/drift.dart';
import '../../../data/db/app_database.dart';

/// Repository for customer operations
/// Provides a clean interface for customer-related database operations
class CustomerRepository {
  final AppDatabase _db;

  CustomerRepository(this._db);

  // Customer CRUD operations

  /// Create or update a customer
  Future<String> upsertCustomer({
    String? id,
    required String name,
    String? phone,
  }) {
    return _db.upsertCustomer(id: id, name: name, phone: phone);
  }

  /// Search customers by query
  Future<List<Customer>> searchCustomers(String query) {
    return _db.searchCustomers(query);
  }

  /// Watch customers list with search
  Stream<List<Customer>> watchCustomers(String query) {
    return _db.watchCustomers(query);
  }

  /// Get a single customer by ID
  Future<Customer?> getCustomerById(String customerId) {
    return (_db.select(
      _db.customers,
    )..where((tbl) => tbl.id.equals(customerId))).getSingleOrNull();
  }

  // Customer statistics

  /// Get total number of sales for a customer
  Future<int> getCustomerSalesCount(String customerId) {
    return _db.getCustomerSalesCount(customerId);
  }

  /// Get total purchase amount in cents
  Future<int> getCustomerTotalPurchasesCents(String customerId) {
    return _db.getCustomerTotalPurchasesCents(customerId);
  }

  /// Get last purchase date for a customer
  Future<DateTime?> getCustomerLastPurchaseDate(String customerId) async {
    final sales =
        await (_db.select(_db.sales)
              ..where((tbl) => tbl.customerId.equals(customerId))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .get();

    return sales.isEmpty ? null : sales.first.createdAt;
  }

  // Customer sales history

  /// Get recent sales for a customer
  Future<List<Sale>> getRecentSalesForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return _db.getRecentSalesForCustomer(customerId, limit: limit);
  }

  /// Get all sales for a customer with pagination
  Future<List<Sale>> getSalesForCustomer(
    String customerId, {
    int? limit,
    int? offset,
  }) async {
    var query = _db.select(_db.sales)
      ..where((tbl) => tbl.customerId.equals(customerId))
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// Get recent repairs for a customer
  Future<List<Repair>> getRecentRepairsForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return _db.getRecentRepairsForCustomer(customerId, limit: limit);
  }

  /// Get recent payments for a customer
  Future<List<Payment>> getRecentPaymentsForCustomer(
    String customerId, {
    int limit = 20,
  }) {
    return _db.getRecentPaymentsForCustomer(customerId, limit: limit);
  }

  // Payment operations

  /// Record a payment from/to customer
  Future<void> recordPayment({
    required String customerId,
    required int amountCents,
    required String direction,
    String? note,
  }) {
    return _db.recordPayment(
      customerId: customerId,
      amountCents: amountCents,
      direction: direction,
      note: note,
    );
  }
}
