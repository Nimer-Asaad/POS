import 'package:drift/drift.dart';

class Settlements extends Table {
  TextColumn get id => text()();
  TextColumn get programType => text()(); // 'Wallet', 'TeleLink', 'FarahNet'
  IntColumn get amount => integer()(); // Settlement amount in fils/cents
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
