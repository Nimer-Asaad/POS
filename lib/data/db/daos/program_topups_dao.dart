import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/program_topups.dart';

part 'program_topups_dao.g.dart';

@DriftAccessor(tables: [ProgramTopups])
class ProgramTopupsDao extends DatabaseAccessor<AppDatabase>
    with _$ProgramTopupsDaoMixin {
  ProgramTopupsDao(super.db);

  Future<int> addTopup({
    required String programType, // 'Wallet', 'TeleLink'
    required int amount,
    required DateTime operatedAt,
    String? notes,
  }) async {
    return into(db.programTopups).insert(
      ProgramTopupsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        programType: Value(programType),
        amount: Value(amount),
        operatedAt: Value(operatedAt),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<ProgramTopup>> watchAllTopups() {
    return (select(db.programTopups)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<ProgramTopup>> watchTopupsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.programTopups)
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

  Stream<List<ProgramTopup>> watchTopupsByProgram(String programType) {
    return (select(db.programTopups)
          ..where((t) => t.programType.equals(programType))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<ProgramTopup>> watchTopupsInRange(DateTime from, DateTime to) {
    return (select(db.programTopups)
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
        await (select(db.programTopups)..where(
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
      db.programTopups,
    )..where((t) => t.programType.equals(programType))).get();
    return records.fold<int>(0, (sum, r) => sum + r.amount);
  }

  Future<void> deleteTopup(String id) {
    return (delete(db.programTopups)..where((t) => t.id.equals(id))).go();
  }
}
