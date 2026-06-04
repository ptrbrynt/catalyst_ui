import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../atoms/button.dart';
import '../atoms/divider.dart';

/// A side panel that slides in from the edge of the screen.
///
/// Present via `showGeneralDialog` or a similar route rather than placing
/// directly in the widget tree. A close button is automatically shown in the
/// header row.
class Drawer extends StatelessWidget {
  /// Creates a drawer.
  const Drawer({
    required this.title,
    required this.body,
    this.footer,
    super.key,
  });

  /// The header title, shown next to the close button.
  final Widget title;

  /// The scrollable content area.
  final Widget body;

  /// An optional footer widget pinned below the body.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: context.shadows.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(CatalystSpacing.s4),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: typo.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: cs.text,
                    ),
                    child: title,
                  ),
                ),
                Button.icon(
                  size: ButtonSize.small,
                  variant: ButtonVariant.ghost,
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(CatalystSpacing.s3),
              child: body,
            ),
          ),
          if (footer != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(CatalystSpacing.s3),
              child: footer,
            ),
          ],
        ],
      ),
    );
  }
}
