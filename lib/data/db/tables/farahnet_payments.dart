import 'package:drift/drift.dart';

class FarahnetPayments extends Table {
  TextColumn get id => text()();
  TextColumn get customerName => text()();
  IntColumn get amountPaid => integer()(); // Main amount in fils/cents
  IntColumn get profitAmount => integer()(); // 2% of amountPaid (calculated)
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
