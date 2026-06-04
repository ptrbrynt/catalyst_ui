import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({
    super.key,
    required this.title,
    required this.preview,
    this.controls = const [],
    this.previewExpanded = false,
  });

  final String title;
  final Widget preview;
  final List<Widget> controls;
  final bool previewExpanded;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final ty = context.typography;

    final previewChild = SizedBox(
      width: double.infinity,
      child: Center(child: preview),
    );

    return ColoredBox(
      color: cs.canvas,
      child: SizedBox.expand(
        child: Column(
          children: [
            AppBar(backIcon: LucideIcons.chevronLeft, title: Text(title)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (previewExpanded)
                      previewChild
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 140),
                        child: previewChild,
                      ),
                    if (controls.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Properties', style: ty.h3),
                      const SizedBox(height: 4),
                      Divider(margin: const EdgeInsets.symmetric(vertical: 12)),
                      for (var i = 0; i < controls.length; i++) ...[
                        controls[i],
                        if (i < controls.length - 1) const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
