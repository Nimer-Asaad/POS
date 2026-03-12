import 'package:drift/drift.dart';

class TelelinkOperations extends Table {
  TextColumn get id => text()();
  TextColumn get customerName => text()();
  IntColumn get amount => integer()(); // Amount in fils/cents
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
