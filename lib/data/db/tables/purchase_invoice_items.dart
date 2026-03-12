import 'package:drift/drift.dart';

class PurchaseInvoiceItems extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseInvoiceId => text()();
  TextColumn get productId => text()();
  IntColumn get qty => integer()();
  IntColumn get purchasePrice => integer()();
  IntColumn get salePrice => integer()();
  IntColumn get lineTotal => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
