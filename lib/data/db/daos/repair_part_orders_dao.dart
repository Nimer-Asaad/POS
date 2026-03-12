import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/repair_part_orders.dart';

part 'repair_part_orders_dao.g.dart';

@DriftAccessor(tables: [RepairPartOrders])
class RepairPartOrdersDao extends DatabaseAccessor<AppDatabase>
    with _$RepairPartOrdersDaoMixin {
  RepairPartOrdersDao(super.db);

  Future<int> addPartOrder({
    required String repairId,
    required String partId,
    required String? supplierId,
    required int quantity,
    required String status, // 'Pending', 'Received', 'Cancelled'
    String? notes,
  }) async {
    return into(db.repairPartOrders).insert(
      RepairPartOrdersCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        repairId: Value(repairId),
        partId: Value(partId),
        supplierId: Value(supplierId),
        operatedAt: Value(DateTime.now()),
        status: Value(status),
        quantity: Value(quantity),
        notes: Value(notes),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<RepairPartOrder>> watchAllPartOrders() {
    return (select(db.repairPartOrders)..orderBy([
          (t) =>
              OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Stream<List<RepairPartOrder>> watchPartOrdersForRepair(String repairId) {
    return (select(db.repairPartOrders)
          ..where((t) => t.repairId.equals(repairId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<RepairPartOrder>> watchPartOrdersByStatus(String status) {
    return (select(db.repairPartOrders)
          ..where((t) => t.status.equals(status))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<RepairPartOrder>> watchPendingPartOrders() {
    return (select(db.repairPartOrders)
          ..where((t) => t.status.equals('Pending'))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Stream<List<RepairPartOrder>> watchPartOrdersForSupplier(String supplierId) {
    return (select(db.repairPartOrders)
          ..where((t) => t.supplierId.equals(supplierId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.operatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<void> updatePartOrderStatus(String id, String newStatus) {
    return (update(db.repairPartOrders)..where((t) => t.id.equals(id))).write(
      RepairPartOrdersCompanion(status: Value(newStatus)),
    );
  }

  Future<int> getPendingCountForRepair(String repairId) async {
    final allCount = await (select(
      db.repairPartOrders,
    )..where((t) => t.repairId.equals(repairId))).get();
    // Count those with 'Pending' status (filtering in Dart)
    return allCount.where((order) => order.status == 'Pending').length;
  }

  Future<void> deletePartOrder(String id) {
    return (delete(db.repairPartOrders)..where((t) => t.id.equals(id))).go();
  }

  Future<void> cancelPartOrder(String id) {
    return (update(db.repairPartOrders)..where((t) => t.id.equals(id))).write(
      const RepairPartOrdersCompanion(status: Value('Cancelled')),
    );
  }
}
