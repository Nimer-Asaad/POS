import 'package:drift/drift.dart';

class SaleItems extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  IntColumn get qty => integer()();
  IntColumn get unitPrice => integer()();
  IntColumn get lineTotal => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
