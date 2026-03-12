import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cash_drawer_events.dart';

part 'cash_drawer_dao.g.dart';

@DriftAccessor(tables: [CashDrawerEvents])
class CashDrawerDao extends DatabaseAccessor<AppDatabase>
    with _$CashDrawerDaoMixin {
  CashDrawerDao(super.db);

  Future<int> insertOpenEvent({String? notes}) async {
    return into(db.cashDrawerEvents).insert(
      CashDrawerEventsCompanion(
        eventType: const Value('opened'),
        createdAt: Value(DateTime.now()),
        notes: Value(notes),
      ),
    );
  }

  Stream<List<CashDrawerEvent>> watchTodayOpenEvents() {
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

    return (select(db.cashDrawerEvents)
          ..where(
            (t) => t.createdAt.isBetween(
              Constant(normalizedStart),
              Constant(endOfDay),
            ),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<CashDrawerEvent>> watchAllEvents() {
    return (select(db.cashDrawerEvents)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<int> getTodayOpenCount() async {
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

    final records =
        await (select(db.cashDrawerEvents)..where(
              (t) => t.createdAt.isBetween(
                Constant(normalizedStart),
                Constant(endOfDay),
              ),
            ))
            .get();

    return records.length;
  }
}
