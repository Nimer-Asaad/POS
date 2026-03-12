import 'package:drift/drift.dart';

class ProgramTopups extends Table {
  TextColumn get id => text()();
  TextColumn get programType => text()(); // 'Wallet', 'TeleLink'
  IntColumn get amount => integer()(); // Top-up amount in fils/cents
  DateTimeColumn get operatedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
