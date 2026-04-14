import 'package:drift/drift.dart';

class SideRevenue extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()(); // 'icloud', 'consultation', 'maintenance', 'other'
  TextColumn get description => text()();
  TextColumn get customerName => text().nullable()(); // Optional customer
  IntColumn get amount => integer()(); // Amount in fils/cents (100% is profit)
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
