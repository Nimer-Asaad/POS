// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_recharge_dao.dart';

// ignore_for_file: type=lint
mixin _$ElectricityRechargeDaoMixin on DatabaseAccessor<AppDatabase> {
  $ElectricityRechargesTable get electricityRecharges =>
      attachedDatabase.electricityRecharges;
  ElectricityRechargeDaoManager get managers =>
      ElectricityRechargeDaoManager(this);
}

class ElectricityRechargeDaoManager {
  final _$ElectricityRechargeDaoMixin _db;
  ElectricityRechargeDaoManager(this._db);
  $$ElectricityRechargesTableTableManager get electricityRecharges =>
      $$ElectricityRechargesTableTableManager(
        _db.attachedDatabase,
        _db.electricityRecharges,
      );
}
