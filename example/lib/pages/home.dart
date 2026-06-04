import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../app.dart';
import '../registry.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigate(BuildContext context, ComponentEntry entry) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        settings: RouteSettings(
          name: '/component/${entry.name}',
          arguments: entry.build(),
        ),
        pageBuilder: (context, animation, secondaryAnimation) => entry.build(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: const Cubic(0.2, 0, 0, 1))).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Atoms', 'Molecules', 'Organisms'];

    final items = <Widget>[];
    for (final category in categories) {
      final entries = registry.where((e) => e.category == category).toList();
      items.add(_SectionHeader(title: category));
      for (final entry in entries) {
        items.add(
          ListItem(
            title: Text(entry.name),
            subtitle: Text(entry.description),
            trailing: const Icon(LucideIcons.chevronRight, size: 16),
            onTap: () => _navigate(context, entry),
          ),
        );
      }
      items.add(const SizedBox(height: 8));
    }

    return ColoredBox(
      color: context.colorScheme.canvas,
      child: SizedBox.expand(
        child: Column(
          children: [
            AppBar(
              title: const Text('Catalyst UI'),
              automaticallyImplyLeading: false,
              trailing: _ThemeToggle(),
            ),
            Expanded(
              child: ListView(children: items),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(
        title,
        style: context.typography.p3.copyWith(
          color: context.colorScheme.textSubtle,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        return Button.icon(
          icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
          variant: ButtonVariant.ghost,
          size: ButtonSize.medium,
          onPressed: () {
            themeMode.value =
                isDark ? ThemeMode.light : ThemeMode.dark;
          },
        );
      },
    );
  }
}
