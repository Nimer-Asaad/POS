// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farahnet_payments_dao.dart';

// ignore_for_file: type=lint
mixin _$FarahnetPaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FarahnetPaymentsTable get farahnetPayments =>
      attachedDatabase.farahnetPayments;
  FarahnetPaymentsDaoManager get managers => FarahnetPaymentsDaoManager(this);
}

class FarahnetPaymentsDaoManager {
  final _$FarahnetPaymentsDaoMixin _db;
  FarahnetPaymentsDaoManager(this._db);
  $$FarahnetPaymentsTableTableManager get farahnetPayments =>
      $$FarahnetPaymentsTableTableManager(
        _db.attachedDatabase,
        _db.farahnetPayments,
      );
}
