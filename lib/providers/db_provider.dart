import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/settings_provider.dart';
import '../data/db/app_database.dart';
import '../data/db/seed_data.dart';

// Singleton instance to prevent multiple database creations
AppDatabase? _dbInstance;
Future<void>? _initFuture;

final dbProvider = Provider<AppDatabase>((ref) {
  // On first access, get the initial path from settings
  // After that, always use the same instance
  if (_dbInstance == null) {
    // Get path synchronously on first call
    final settings = ref.watch(settingsProvider);
    final databaseDirectoryPath = settings.databaseDirectoryPath;

    // Create new instance only once
    _dbInstance = AppDatabase(databaseDirectoryPath: databaseDirectoryPath);

    // Initialize database with demo data if empty (fire and forget)
    _initFuture ??= DatabaseSeeder.initializeIfNeeded(_dbInstance!);

    ref.onDispose(() {
      // Keep the instance alive - don't close it
      // The database should live for the entire app lifetime
    });
  }

  return _dbInstance!;
});
