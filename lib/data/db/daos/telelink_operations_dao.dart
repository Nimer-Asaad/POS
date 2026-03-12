import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/telelink_operations.dart';

part 'telelink_operations_dao.g.dart';

@DriftAccessor(tables: [TelelinkOperations])
class TelelinkOperationsDao extends DatabaseAccessor<AppDatabase>
    with _$TelelinkOperationsDaoMixin {
  TelelinkOperationsDao(super.db);

  Future<int> addOperation({
    required String customerName,
    required int amount,
    required String operationType,
    required DateTime operatedAt,
    String? notes,
  }) async {
    return into(db.telelinkOperations).insert(
      TelelinkOperationsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        customerName: Value(customerName),
        amount: Value(amount),
        operatedAt: Value(operatedAt),
        notes: Value(
          notes != null && notes.isNotEmpty
              ? '$operationType|$notes'
              : operationType,
        ),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<TelelinkOperation>> watchAllOperations() {
    return (select(db.telelinkOperations)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<TelelinkOperation>> watchOperationsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.telelinkOperations)
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
        await (select(db.telelinkOperations)..where(
              (t) => t.operatedAt.isBetween(
                Constant(startOfDay),
                Constant(endOfDay),
              ),
            ))
            .get();
    return records.fold<int>(0, (sum, r) => sum + r.amount);
  }

  Future<void> deleteOperation(String id) {
    return (delete(db.telelinkOperations)..where((t) => t.id.equals(id))).go();
  }
}
