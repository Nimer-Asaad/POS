import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// Global error logger for capturing all exceptions
class ErrorLogger {
  static void logError(
    dynamic exception,
    StackTrace stackTrace, {
    String? context,
  }) {
    final formattedError =
        '''
═══════════════════════════════════════════════════════════
🔴 ERROR LOG
═══════════════════════════════════════════════════════════
Context: ${context ?? 'Unknown'}
Exception: $exception
═══════════════════════════════════════════════════════════
StackTrace:
$stackTrace
═══════════════════════════════════════════════════════════
''';

    debugPrint(formattedError);
    developer.log(
      exception.toString(),
      error: exception,
      stackTrace: stackTrace,
      name: 'POS.Error',
    );
  }

  static void logFlutterError(FlutterErrorDetails details) {
    debugPrint(details.exceptionAsString());
    if (details.stack != null) {
      debugPrint(details.stack.toString());
    }
  }
}
