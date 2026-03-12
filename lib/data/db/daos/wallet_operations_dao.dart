import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/wallet_operations.dart';

part 'wallet_operations_dao.g.dart';

@DriftAccessor(tables: [WalletOperations])
class WalletOperationsDao extends DatabaseAccessor<AppDatabase>
    with _$WalletOperationsDaoMixin {
  WalletOperationsDao(super.db);

  Future<int> addOperation({
    required String customerName,
    required int amount,
    required DateTime operatedAt,
    String? notes,
  }) async {
    return into(db.walletOperations).insert(
      WalletOperationsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        customerName: Value(customerName),
        amount: Value(amount),
        operatedAt: Value(operatedAt),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<WalletOperation>> watchAllOperations() {
    return (select(db.walletOperations)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<WalletOperation>> watchOperationsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.walletOperations)
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

  Future<int> getTotalForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final records =
        await (select(db.walletOperations)..where(
              (t) => t.operatedAt.isBetween(
                Constant(startOfDay),
                Constant(endOfDay),
              ),
            ))
            .get();

    return records.fold<int>(0, (sum, r) => sum + (r.amount));
  }

  Future<void> deleteOperation(String id) {
    return (delete(db.walletOperations)..where((t) => t.id.equals(id))).go();
  }
}
