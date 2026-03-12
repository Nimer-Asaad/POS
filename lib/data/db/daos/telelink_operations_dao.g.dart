// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telelink_operations_dao.dart';

// ignore_for_file: type=lint
mixin _$TelelinkOperationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TelelinkOperationsTable get telelinkOperations =>
      attachedDatabase.telelinkOperations;
  TelelinkOperationsDaoManager get managers =>
      TelelinkOperationsDaoManager(this);
}

class TelelinkOperationsDaoManager {
  final _$TelelinkOperationsDaoMixin _db;
  TelelinkOperationsDaoManager(this._db);
  $$TelelinkOperationsTableTableManager get telelinkOperations =>
      $$TelelinkOperationsTableTableManager(
        _db.attachedDatabase,
        _db.telelinkOperations,
      );
}
