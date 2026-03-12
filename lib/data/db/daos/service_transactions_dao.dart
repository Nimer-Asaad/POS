import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../tables/service_transactions.dart';

part 'service_transactions_dao.g.dart';

@DriftAccessor(tables: [ServiceTransactions])
class ServiceTransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$ServiceTransactionsDaoMixin {
  ServiceTransactionsDao(super.db);

  Future<int> insertTransaction({
    required String category,
    required String provider,
    String? providerLabel,
    String? customerName,
    required int amountCents,
    int? profitCents,
    String? notes,
    String? saleId,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    return db.transaction(() async {
      // Insert the service transaction
      await into(db.serviceTransactions).insert(
        ServiceTransactionsCompanion(
          id: Value(id),
          category: Value(category),
          provider: Value(provider),
          providerLabel: Value(providerLabel),
          customerName: Value(customerName),
          amountCents: Value(amountCents),
          profitCents: Value(profitCents),
          createdAt: Value(DateTime.now()),
          notes: Value(notes),
          saleId: Value(saleId),
        ),
      );
      
      // Create a debt record if customer name is provided
      if (customerName != null && customerName.isNotEmpty) {
        final debtId = const Uuid().v4();
        final now = DateTime.now();
        await into(db.debts).insert(
          DebtsCompanion.insert(
            id: debtId,
            customerId: Value(null), // Service transactions don't have a customerId
            customerName: customerName,
            customerPhone: const Value(null),
            sourceType: 'service',
            sourceId: id,
            amount: amountCents,
            note: Value(notes),
            createdAt: now,
          ),
        );
      }
      
      return 1; // Return success
    });
  }

  Stream<List<ServiceTransaction>> watchAllTransactions() {
    return (select(db.serviceTransactions)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<ServiceTransaction>> watchTodayTransactions({int? limit}) {
    final startOfDay = DateTime.now();
    final normalizedStart = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
    );
    final endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );

    var query = select(db.serviceTransactions)
      ..where(
        (t) => t.createdAt.isBetween(
          Constant(normalizedStart),
          Constant(endOfDay),
        ),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) {
      query = query..limit(limit);
    }

    return query.watch();
  }

  Future<int> getTodayTotalByCategory(String category) async {
    final startOfDay = DateTime.now();
    final normalizedStart = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
    );
    final endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );

    final query = select(db.serviceTransactions)
      ..where(
        (t) =>
            t.category.equals(category) &
            t.createdAt.isBetween(
              Constant(normalizedStart),
              Constant(endOfDay),
            ),
      );

    final records = await query.get();
    int total = 0;
    for (final r in records) {
      total += r.amountCents;
    }
    return total;
  }

  Future<int> getTodayGrandTotal() async {
    final startOfDay = DateTime.now();
    final normalizedStart = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
    );
    final endOfDay = DateTime(
      startOfDay.year,
      startOfDay.month,
      startOfDay.day,
      23,
      59,
      59,
    );

    final query = select(db.serviceTransactions)
      ..where(
        (t) => t.createdAt.isBetween(
          Constant(normalizedStart),
          Constant(endOfDay),
        ),
      );

    final records = await query.get();
    int total = 0;
    for (final r in records) {
      total += r.amountCents;
    }
    return total;
  }
}
