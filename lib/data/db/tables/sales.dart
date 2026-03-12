import 'package:drift/drift.dart';

class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable()();
  IntColumn get total => integer()();
  IntColumn get discount => integer()();
  IntColumn get paid => integer()();
  TextColumn get paymentType => text()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
