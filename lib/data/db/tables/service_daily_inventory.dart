import 'package:drift/drift.dart';

class ServiceDailyInventory extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()(); // Midnight normalized
  TextColumn get provider => text()(); // telelink, platform, palpay
  IntColumn get openingBalanceCents => integer().withDefault(const Constant(0))();
  IntColumn get closingBalanceCents => integer().withDefault(const Constant(0))(); // Actual closing
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
