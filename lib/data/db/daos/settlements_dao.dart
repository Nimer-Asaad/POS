import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/settlements.dart';

part 'settlements_dao.g.dart';

@DriftAccessor(tables: [Settlements])
class SettlementsDao extends DatabaseAccessor<AppDatabase>
    with _$SettlementsDaoMixin {
  SettlementsDao(super.db);

  Future<int> addSettlement({
    required String programType, // 'Wallet', 'TeleLink', 'FarahNet'
    required int amount,
    required DateTime operatedAt,
    String? notes,
  }) async {
    return into(db.settlements).insert(
      SettlementsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        programType: Value(programType),
        amount: Value(amount),
        operatedAt: Value(operatedAt),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Settlement>> watchAllSettlements() {
    return (select(db.settlements)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<Settlement>> watchSettlementsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.settlements)
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

  Stream<List<Settlement>> watchSettlementsByProgram(String programType) {
    return (select(db.settlements)
          ..where((t) => t.programType.equals(programType))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<Settlement>> watchSettlementsInRange(DateTime from, DateTime to) {
    return (select(db.settlements)
          ..where((t) => t.operatedAt.isBetween(Constant(from), Constant(to)))
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
        await (select(db.settlements)..where(
              (t) => t.operatedAt.isBetween(
                Constant(startOfDay),
                Constant(endOfDay),
              ),
            ))
            .get();

    return records.fold<int>(0, (sum, r) => sum + r.amount);
  }

  Future<int> getTotalByProgram(String programType) async {
    final records = await (select(
      db.settlements,
    )..where((t) => t.programType.equals(programType))).get();

    return records.fold<int>(0, (sum, r) => sum + r.amount);
  }

  Future<void> deleteSettlement(String id) {
    return (delete(db.settlements)..where((t) => t.id.equals(id))).go();
  }
}
