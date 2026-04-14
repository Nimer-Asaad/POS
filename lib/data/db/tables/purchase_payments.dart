import 'package:drift/drift.dart';

class PurchasePayments extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId =>
      text().nullable()(); // Nullable for general supplier payments
  TextColumn get supplierId => text()();
  IntColumn get amount => integer()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get paymentDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
