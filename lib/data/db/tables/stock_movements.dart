import 'package:drift/drift.dart';

class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get type => text()();
  IntColumn get qtyDelta => integer()();
  TextColumn get reason => text()();
  TextColumn get refId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
