// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drawer_dao.dart';

// ignore_for_file: type=lint
mixin _$CashDrawerDaoMixin on DatabaseAccessor<AppDatabase> {
  $CashDrawerEventsTable get cashDrawerEvents =>
      attachedDatabase.cashDrawerEvents;
  CashDrawerDaoManager get managers => CashDrawerDaoManager(this);
}

class CashDrawerDaoManager {
  final _$CashDrawerDaoMixin _db;
  CashDrawerDaoManager(this._db);
  $$CashDrawerEventsTableTableManager get cashDrawerEvents =>
      $$CashDrawerEventsTableTableManager(
        _db.attachedDatabase,
        _db.cashDrawerEvents,
      );
}
