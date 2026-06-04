import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../atoms/divider.dart';

/// A dialog modal with a title, body, and row of action buttons.
///
/// Present via `showDialog` or a custom `showModal` utility rather than
/// placing directly in the widget tree. Actions are right-aligned at the
/// bottom.
///
/// ```dart
/// Modal(
///   title: const Text('Delete item?'),
///   body: const Text('This action cannot be undone.'),
///   actions: [
///     Button(label: const Text('Cancel'),
///       variant: ButtonVariant.secondary, ...),
///     Button(label: const Text('Delete'),
///       variant: ButtonVariant.destructive, ...),
///   ],
/// )
/// ```
class Modal extends StatelessWidget {
  /// Creates a modal.
  const Modal({
    required this.title,
    required this.body,
    this.actions = const [],
    this.maxWidth = 480,
    super.key,
  });

  /// The modal heading.
  final Widget title;

  /// The main content.
  final Widget body;

  /// Action widgets (e.g. [Button]s) at the bottom.
  final List<Widget> actions;

  /// Maximum width. Defaults to 480.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: typo.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.55,
          color: cs.textMuted,
        ),
        child: AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: Radii.xlAll,
            border: Border.all(color: cs.border),
            boxShadow: context.shadows.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.s2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.s4,
                  vertical: Spacing.s2,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: typo.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    height: 1.3,
                    color: cs.text,
                  ),
                  child: title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.s4,
                  vertical: Spacing.s2,
                ),
                child: body,
              ),
              const SizedBox(height: Spacing.s2),
              if (actions.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(Spacing.s3),
                  child: Row(
                    spacing: Spacing.s2,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
