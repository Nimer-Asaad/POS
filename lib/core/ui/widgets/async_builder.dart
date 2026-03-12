import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_empty_state.dart';
import 'app_error_state.dart';

/// Helper widget for consistent AsyncValue handling across the app
class AsyncBuilder<T> extends StatelessWidget {
  final AsyncValue<T> async;
  final Widget Function(T data) builder;
  final Widget Function(
    Object error,
    StackTrace stackTrace,
    VoidCallback onRetry,
  )?
  onError;
  final Widget? loading;
  final Widget Function()? onEmpty;
  final VoidCallback? onRetry;

  const AsyncBuilder({
    super.key,
    required this.async,
    required this.builder,
    this.onError,
    this.loading,
    this.onEmpty,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (data) {
        // Check if data is an empty list/collection
        if (data is Iterable && data.isEmpty) {
          return onEmpty?.call() ??
              AppEmptyState(
                message: 'No data available',
                icon: Icons.inbox_outlined,
              );
        }
        return builder(data);
      },
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return onError?.call(error, stackTrace, onRetry ?? () {}) ??
            AppErrorState(
              message: error.toString(),
              details: error.toString(),
              stackTrace: stackTrace,
              onRetry: onRetry,
            );
      },
    );
  }
}
