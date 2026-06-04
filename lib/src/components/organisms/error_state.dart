import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../atoms/button.dart';
import 'empty_state.dart';

/// An error state widget for showing failure feedback with an optional retry.
///
/// ```dart
/// ErrorState(
///   title: const Text('Something went wrong'),
///   description: const Text('Check your connection and try again.'),
///   onRetry: _reload,
/// )
/// ```
class ErrorState extends StatelessWidget {
  /// Creates a standard-sized error state (64 px icon circle).
  const ErrorState({
    required this.title,
    required this.icon,
    this.description,
    this.onRetry,
    super.key,
  }) : _large = false;

  /// Creates a large error state (88 px icon circle).
  const ErrorState.large({
    required this.title,
    required this.icon,
    this.description,
    this.onRetry,
    super.key,
  }) : _large = true;

  /// The icon inside the red circle.
  final IconData icon;

  /// The primary error heading.
  final Widget title;

  /// An optional supporting description.
  final Widget? description;

  /// When non-null, a "Retry" button is shown.
  final VoidCallback? onRetry;

  final bool _large;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    final body = _large
        ? EmptyState.large(
            icon: icon,
            iconBackgroundColor: cs.dangerSoft,
            iconColor: cs.danger,
            title: title,
            description: description ?? const SizedBox.shrink(),
            action: _retryButton,
          )
        : EmptyState(
            icon: icon,
            iconBackgroundColor: cs.dangerSoft,
            iconColor: cs.danger,
            title: title,
            description: description ?? const SizedBox.shrink(),
            action: _retryButton,
          );

    return body;
  }

  Widget? get _retryButton => onRetry != null
      ? Button(
          size: ButtonSize.medium,
          label: const Text('Retry'),
          onPressed: onRetry,
        )
      : null;
}
