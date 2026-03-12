import 'package:drift/drift.dart';

class RepairPartOrders extends Table {
  TextColumn get id => text()();
  TextColumn get repairId => text()(); // Foreign key to Repairs
  TextColumn get partId => text()(); // Product ID (part)
  TextColumn get supplierId => text().nullable()(); // Optional supplier
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get status => text().withDefault(
    const Constant('Pending'),
  )(); // 'Pending', 'Received', 'Cancelled'
  IntColumn get quantity => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
