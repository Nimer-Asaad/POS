import 'package:drift/drift.dart';

class PurchaseItems extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text()();
  TextColumn get productId => text()();
  IntColumn get qty => integer()();
  IntColumn get unitCost => integer()();
  IntColumn get lineTotal => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
