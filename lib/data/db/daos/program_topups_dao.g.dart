// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_topups_dao.dart';

// ignore_for_file: type=lint
mixin _$ProgramTopupsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProgramTopupsTable get programTopups => attachedDatabase.programTopups;
  ProgramTopupsDaoManager get managers => ProgramTopupsDaoManager(this);
}

class ProgramTopupsDaoManager {
  final _$ProgramTopupsDaoMixin _db;
  ProgramTopupsDaoManager(this._db);
  $$ProgramTopupsTableTableManager get programTopups =>
      $$ProgramTopupsTableTableManager(_db.attachedDatabase, _db.programTopups);
}
