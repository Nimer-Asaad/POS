import 'package:drift/drift.dart';

class Purchases extends Table {
  TextColumn get id => text()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get invoiceNumber => text().nullable()();
  IntColumn get total => integer()();
  IntColumn get paid => integer()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
