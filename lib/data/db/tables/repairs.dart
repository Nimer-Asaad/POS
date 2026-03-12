import 'package:drift/drift.dart';

class Repairs extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get device => text()();
  TextColumn get model => text().nullable()();
  TextColumn get imei => text().nullable()();
  TextColumn get issue => text()();
  TextColumn get status => text()();
  IntColumn get estimatedCost => integer().withDefault(const Constant(0))();
  IntColumn get finalCost => integer().withDefault(const Constant(0))();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  IntColumn get paidAtReceive => integer().withDefault(const Constant(0))();
  IntColumn get paidAtDelivery => integer().withDefault(const Constant(0))();
  IntColumn get totalPaid => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  // Reversal support
  TextColumn get transactionStatus => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
