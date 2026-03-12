// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_transactions_dao.dart';

// ignore_for_file: type=lint
mixin _$ServiceTransactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ServiceTransactionsTable get serviceTransactions =>
      attachedDatabase.serviceTransactions;
  ServiceTransactionsDaoManager get managers =>
      ServiceTransactionsDaoManager(this);
}

class ServiceTransactionsDaoManager {
  final _$ServiceTransactionsDaoMixin _db;
  ServiceTransactionsDaoManager(this._db);
  $$ServiceTransactionsTableTableManager get serviceTransactions =>
      $$ServiceTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.serviceTransactions,
      );
}
