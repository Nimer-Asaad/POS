import 'package:drift/drift.dart';

class ElectricityRecharges extends Table {
  TextColumn get id => text()();
  TextColumn get customerName => text()();
  TextColumn get subscriptionNumber =>
      text().nullable()(); // Optional for Mada Bills
  IntColumn get amount => integer()(); // Amount in fils/cents (SAR * 100)
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get operationType => text().withDefault(
    const Constant('Electricity'),
  )(); // 'Electricity', 'MadaBill'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
