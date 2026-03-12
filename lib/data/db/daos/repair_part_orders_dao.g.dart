// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_part_orders_dao.dart';

// ignore_for_file: type=lint
mixin _$RepairPartOrdersDaoMixin on DatabaseAccessor<AppDatabase> {
  $RepairPartOrdersTable get repairPartOrders =>
      attachedDatabase.repairPartOrders;
  RepairPartOrdersDaoManager get managers => RepairPartOrdersDaoManager(this);
}

class RepairPartOrdersDaoManager {
  final _$RepairPartOrdersDaoMixin _db;
  RepairPartOrdersDaoManager(this._db);
  $$RepairPartOrdersTableTableManager get repairPartOrders =>
      $$RepairPartOrdersTableTableManager(
        _db.attachedDatabase,
        _db.repairPartOrders,
      );
}
