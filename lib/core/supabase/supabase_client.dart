import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client singleton
/// Initializes and provides access to the Supabase client throughout the app
class SupabaseConfig {
  static SupabaseClient? _client;

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }

  /// Check if Supabase is initialized
  static bool get isInitialized => _client != null;

  /// Initialize Supabase with credentials from .env
  static Future<void> initialize() async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URL not found in .env file');
      }

      if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEY not found in .env file');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true, // Set to false in production
      );

      _client = Supabase.instance.client;
      print('✅ Supabase initialized successfully');
      print('   URL: $supabaseUrl');
    } catch (e, stackTrace) {
      print('❌ Failed to initialize Supabase: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get auth instance (for future authentication features)
  static GoTrueClient get auth => client.auth;

  /// Get realtime instance (for real-time subscriptions)
  static RealtimeClient get realtime => client.realtime;

  /// Get storage instance (for file uploads)
  static SupabaseStorageClient get storage => client.storage;
}
