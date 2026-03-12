import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/utils/error_logger.dart';
import 'core/supabase/supabase_client.dart';
import 'core/database/auto_sync_extension.dart';
import 'providers/db_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation for mobile devices
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
    print('✅ Environment variables loaded');
  } catch (e) {
    print('⚠️  Warning: Could not load .env file: $e');
    print('   Supabase features will be disabled.');
  }

  // Initialize Supabase (non-blocking - continues even if fails)
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    print('⚠️  Warning: Supabase initialization failed: $e');
    print('   App will continue with local-only mode.');
  }

  // Set up global error handling for Flutter errors
  FlutterError.onError = (details) {
    ErrorLogger.logFlutterError(details);
  };

  // Wrap the app with error zone to catch uncaught async errors
  runZonedGuarded(
    () {
      // Create provider container to access database
      final container = ProviderContainer();

      // Initialize auto-sync after database is ready
      if (SupabaseConfig.isInitialized) {
        try {
          final db = container.read(dbProvider);
          AutoSyncExtension.initializeAutoSync(db);
          print('✅ Auto-sync initialized successfully');
        } catch (e) {
          print('⚠️  Warning: Auto-sync initialization failed: $e');
        }
      }

      runApp(
        UncontrolledProviderScope(container: container, child: const App()),
      );
    },
    (error, stackTrace) {
      ErrorLogger.logError(error, stackTrace, context: 'Uncaught Exception');
    },
  );
}
