import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A modal bottom sheet with a drag handle, title, body, and footer.
///
/// Present via [showModalBottomSheet] rather than placing directly in the
/// widget tree. The sheet constrains its height to 80 % of the screen.
class BottomSheet extends StatelessWidget {
  /// Creates a bottom sheet.
  const BottomSheet({
    required this.title,
    required this.child,
    required this.footer,
    super.key,
  });

  /// The title rendered below the drag handle.
  final Widget title;

  /// The scrollable body content.
  final Widget child;

  /// A footer pinned to the bottom (e.g. action buttons).
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    return DefaultTextStyle(
      style: typo.body,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Radii.xxl),
          ),
          boxShadow: context.shadows.lg,
        ),
        padding: const EdgeInsets.only(
          top: Spacing.s2,
          bottom: Spacing.s4,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  top: Spacing.s2,
                  bottom: Spacing.s3,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.border,
                    borderRadius: Radii.pillAll,
                  ),
                  child: const SizedBox(height: 4, width: 40),
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontFamily: typo.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.3,
                  color: cs.text,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.s5,
                    right: Spacing.s5,
                    bottom: Spacing.s4,
                  ),
                  child: title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.s2,
                  horizontal: Spacing.s5,
                ),
                child: child,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: Spacing.s4,
                  left: Spacing.s5,
                  right: Spacing.s5,
                ),
                child: footer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
