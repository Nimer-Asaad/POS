import 'package:drift/drift.dart';

class CashDrawerEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventType => text()(); // 'opened'
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get notes => text().nullable()();
}
