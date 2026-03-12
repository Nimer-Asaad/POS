import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get category => text()();
  TextColumn get supplierId =>
      text().nullable()(); // Optional supplier reference
  IntColumn get sellPrice => integer()();
  IntColumn get costPrice => integer()();
  IntColumn get qty => integer()();
  BoolColumn get trackImei => boolean()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
