import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/side_revenue.dart';

part 'side_revenue_dao.g.dart';

@DriftAccessor(tables: [SideRevenue])
class SideRevenueDao extends DatabaseAccessor<AppDatabase>
    with _$SideRevenueDaoMixin {
  SideRevenueDao(super.db);

  Future<int> addSideRevenue({
    required String category,
    required String description,
    required int amountCents,
    String? customerName,
    String? notes,
    DateTime? operatedAt,
  }) async {
    return into(db.sideRevenue).insert(
      SideRevenueCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        category: Value(category),
        description: Value(description),
        amount: Value(amountCents),
        customerName: Value(customerName),
        notes: Value(notes),
        operatedAt: Value(operatedAt ?? DateTime.now()),
        createdAt: Value(DateTime.now()),
        status: const Value('normal'),
      ),
    );
  }

  Future<void> reverseSideRevenue(String id) async {
    await (update(db.sideRevenue)..where((tbl) => tbl.id.equals(id)))
        .write(
      SideRevenueCompanion(
        status: const Value('reversed'),
        reversedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<SideRevenueData>> getSideRevenueByDateRange(DateTime from, DateTime to) {
    return (select(db.sideRevenue)
          ..where((tbl) =>
              tbl.operatedAt.isBetweenValues(from, to) &
              tbl.status.equals('normal'))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.operatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }
}
