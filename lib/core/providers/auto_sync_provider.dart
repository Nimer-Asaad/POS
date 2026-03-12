import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sync/auto_sync_service.dart';
import '../../providers/db_provider.dart';

/// Provider for auto-sync service
final autoSyncServiceProvider = Provider<AutoSyncService>((ref) {
  final db = ref.watch(dbProvider);
  return AutoSyncService(database: db);
});

/// Provider to check if auto-sync is enabled
final isAutoSyncEnabledProvider = StateProvider<bool>((ref) => true);

/// Provider to toggle auto-sync
final toggleAutoSyncProvider = Provider<void Function(bool)>((ref) {
  return (enabled) {
    ref.read(isAutoSyncEnabledProvider.notifier).state = enabled;
    final syncService = ref.read(autoSyncServiceProvider);

    if (enabled) {
      syncService.enable();
      print('✅ Auto-sync enabled');
    } else {
      syncService.disable();
      print('⚠️  Auto-sync disabled');
    }
  };
});
