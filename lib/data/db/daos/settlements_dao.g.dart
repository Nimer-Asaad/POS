// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlements_dao.dart';

// ignore_for_file: type=lint
mixin _$SettlementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SettlementsTable get settlements => attachedDatabase.settlements;
  SettlementsDaoManager get managers => SettlementsDaoManager(this);
}

class SettlementsDaoManager {
  final _$SettlementsDaoMixin _db;
  SettlementsDaoManager(this._db);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db.attachedDatabase, _db.settlements);
}
