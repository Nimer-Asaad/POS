import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/farahnet_payments.dart';

part 'farahnet_payments_dao.g.dart';

@DriftAccessor(tables: [FarahnetPayments])
class FarahnetPaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$FarahnetPaymentsDaoMixin {
  FarahnetPaymentsDao(super.db);

  Future<int> addPayment({
    required String customerName,
    required int amountPaid,
    required DateTime operatedAt,
    String? notes,
  }) async {
    // Calculate 2% profit
    final profitAmount = (amountPaid * 2) ~/ 100;

    return into(db.farahnetPayments).insert(
      FarahnetPaymentsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        customerName: Value(customerName),
        amountPaid: Value(amountPaid),
        profitAmount: Value(profitAmount),
        operatedAt: Value(operatedAt),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<FarahnetPayment>> watchAllPayments() {
    return (select(db.farahnetPayments)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<FarahnetPayment>> watchPaymentsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.farahnetPayments)
          ..where(
            (t) => t.operatedAt.isBetween(
              Constant(startOfDay),
              Constant(endOfDay),
            ),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<Map<String, int>> getTotalsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final records =
        await (select(db.farahnetPayments)..where(
              (t) => t.operatedAt.isBetween(
                Constant(startOfDay),
                Constant(endOfDay),
              ),
            ))
            .get();

    int totalAmount = 0;
    int totalProfit = 0;

    for (final record in records) {
      totalAmount += record.amountPaid;
      totalProfit += record.profitAmount;
    }

    return {
      'totalAmount': totalAmount,
      'totalProfit': totalProfit,
      'payable': totalAmount - totalProfit,
    };
  }

  Future<void> deletePayment(String id) {
    return (delete(db.farahnetPayments)..where((t) => t.id.equals(id))).go();
  }
}
