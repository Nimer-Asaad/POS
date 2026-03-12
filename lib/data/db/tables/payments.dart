import 'package:drift/drift.dart';

class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  IntColumn get amount => integer()();
  TextColumn get direction => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
