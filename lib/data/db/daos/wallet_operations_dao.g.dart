// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_operations_dao.dart';

// ignore_for_file: type=lint
mixin _$WalletOperationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletOperationsTable get walletOperations =>
      attachedDatabase.walletOperations;
  WalletOperationsDaoManager get managers => WalletOperationsDaoManager(this);
}

class WalletOperationsDaoManager {
  final _$WalletOperationsDaoMixin _db;
  WalletOperationsDaoManager(this._db);
  $$WalletOperationsTableTableManager get walletOperations =>
      $$WalletOperationsTableTableManager(
        _db.attachedDatabase,
        _db.walletOperations,
      );
}
