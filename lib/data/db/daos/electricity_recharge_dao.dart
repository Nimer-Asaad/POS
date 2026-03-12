import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/electricity_recharges.dart';

part 'electricity_recharge_dao.g.dart';

@DriftAccessor(tables: [ElectricityRecharges])
class ElectricityRechargeDao extends DatabaseAccessor<AppDatabase>
    with _$ElectricityRechargeDaoMixin {
  ElectricityRechargeDao(super.db);

  Future<int> addRecharge({
    required String customerName,
    required String? subscriptionNumber,
    required int amount,
    required DateTime operatedAt,
    required String operationType, // 'Electricity' or 'MadaBill'
    String? notes,
  }) async {
    return into(db.electricityRecharges).insert(
      ElectricityRechargesCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        customerName: Value(customerName),
        subscriptionNumber: Value(subscriptionNumber),
        amount: Value(amount),
        operatedAt: Value(operatedAt),
        operationType: Value(operationType),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<ElectricityRecharge>> watchAllRecharges() {
    return (select(db.electricityRecharges)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<ElectricityRecharge>> watchRechargesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(db.electricityRecharges)
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

  Stream<List<ElectricityRecharge>> watchRechargesByCustomer(
    String customerName,
  ) {
    return (select(db.electricityRecharges)
          ..where((t) => t.customerName.like('%$customerName%'))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<ElectricityRecharge>> watchRechargesInRange(
    DateTime from,
    DateTime to,
  ) {
    return (select(db.electricityRecharges)
          ..where((t) => t.operatedAt.isBetween(Constant(from), Constant(to)))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<ElectricityRecharge>> watchRechargesByType(String operationType) {
    return (select(db.electricityRecharges)
          ..where((t) => t.operationType.equals(operationType))
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
        await (select(db.electricityRecharges)..where(
              (t) => t.operatedAt.isBetween(
                Constant(startOfDay),
                Constant(endOfDay),
              ),
            ))
            .get();

    return records.fold<int>(0, (sum, r) => sum + (r.amount));
  }

  Future<void> deleteRecharge(String id) {
    return (delete(
      db.electricityRecharges,
    )..where((t) => t.id.equals(id))).go();
  }
}
