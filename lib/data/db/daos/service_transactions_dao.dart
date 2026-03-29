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
    final id = const Uuid().v4();
    final now = DateTime.now();
    String? resolvedCustomerId;
    String? resolvedCustomerPhone;
    final normalizedCustomerName = customerName?.trim();

    return db.transaction(() async {
      if (normalizedCustomerName != null && normalizedCustomerName.isNotEmpty) {
        final existingCustomer =
            await (db.select(db.customers)
                  ..where((c) => c.name.equals(normalizedCustomerName)))
                .getSingleOrNull();

        if (existingCustomer != null) {
          resolvedCustomerId = existingCustomer.id;
          resolvedCustomerPhone = existingCustomer.phone;
        } else {
          resolvedCustomerId = const Uuid().v4();
          await db
              .into(db.customers)
              .insert(
                CustomersCompanion.insert(
                  id: resolvedCustomerId!,
                  name: normalizedCustomerName,
                  phone: const Value(null),
                  createdAt: now,
                ),
              );
        }
      }

      // Insert the service transaction
      await into(db.serviceTransactions).insert(
        ServiceTransactionsCompanion(
          id: Value(id),
          category: Value(category),
          provider: Value(provider),
          providerLabel: Value(providerLabel),
          customerName: Value(normalizedCustomerName),
          amountCents: Value(amountCents),
          profitCents: Value(profitCents),
          createdAt: Value(now),
          notes: Value(notes),
          saleId: Value(saleId),
        ),
      );

      // Create a debt record if customer name is provided
      if (normalizedCustomerName != null && normalizedCustomerName.isNotEmpty) {
        final debtId = const Uuid().v4();
        await into(db.debts).insert(
          DebtsCompanion.insert(
            id: debtId,
            customerId: Value(resolvedCustomerId),
            customerName: normalizedCustomerName,
            customerPhone: Value(resolvedCustomerPhone),
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
