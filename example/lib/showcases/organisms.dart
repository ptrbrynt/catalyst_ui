import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/controls.dart';
import '../widgets/showcase_page.dart';

// ─── AppBar ───────────────────────────────────────────────────────────────────

class AppBarShowcase extends StatefulWidget {
  const AppBarShowcase({super.key});
  @override
  State<AppBarShowcase> createState() => _AppBarShowcaseState();
}

class _AppBarShowcaseState extends State<AppBarShowcase> {
  bool _hasTitle = true;
  bool _hasTrailing = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'AppBar',
      preview: SizedBox(
        width: 320,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: _hasTitle ? const Text('Page Title') : null,
                trailing: _hasTrailing
                    ? Button.icon(
                        icon: const Icon(LucideIcons.bell),
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.medium,
                        onPressed: () {},
                      )
                    : null,
              ),
              ColoredBox(
                color: context.colorScheme.canvas,
                child: const SizedBox(height: 80, width: double.infinity),
              ),
            ],
          ),
        ),
      ),
      controls: [
        BoolControl(label: 'Has title', value: _hasTitle, onChanged: (v) => setState(() => _hasTitle = v)),
        BoolControl(label: 'Has trailing action', value: _hasTrailing, onChanged: (v) => setState(() => _hasTrailing = v)),
      ],
    );
  }
}

// ─── BottomNav ────────────────────────────────────────────────────────────────

class BottomNavShowcase extends StatefulWidget {
  const BottomNavShowcase({super.key});
  @override
  State<BottomNavShowcase> createState() => _BottomNavShowcaseState();
}

class _BottomNavShowcaseState extends State<BottomNavShowcase> {
  String _selected = 'home';

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'BottomNav',
      preview: SizedBox(
        width: 360,
        child: BottomNav<String>(
          selectedItem: _selected,
          onItemSelected: (v) => setState(() => _selected = v),
          destinations: const [
            BottomNavDestination(value: 'home', label: 'Home', icon: LucideIcons.house),
            BottomNavDestination(value: 'explore', label: 'Explore', icon: LucideIcons.compass),
            BottomNavDestination(value: 'inbox', label: 'Inbox', icon: LucideIcons.inbox),
            BottomNavDestination(value: 'profile', label: 'Profile', icon: LucideIcons.user),
          ],
        ),
      ),
      controls: const [],
    );
  }
}

// ─── BottomSheet ──────────────────────────────────────────────────────────────

class BottomSheetShowcase extends StatefulWidget {
  const BottomSheetShowcase({super.key});
  @override
  State<BottomSheetShowcase> createState() => _BottomSheetShowcaseState();
}

class _BottomSheetShowcaseState extends State<BottomSheetShowcase> {
  bool _draggable = true;

  void _show(BuildContext context) {
    showBottomSheet(
      context,
      (_) => BottomSheet(
        title: const Text('Share document'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListItem(
              title: const Text('Copy link'),
              leading: const Icon(LucideIcons.link),
              onTap: () => Navigator.pop(context),
            ),
            ListItem(
              title: const Text('Send via email'),
              leading: const Icon(LucideIcons.mail),
              onTap: () => Navigator.pop(context),
            ),
            ListItem(
              title: const Text('Export as PDF'),
              leading: const Icon(LucideIcons.fileText),
              divider: false,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        footer: Button(
          label: const Text('Cancel'),
          variant: ButtonVariant.secondary,
          fullWidth: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      draggable: _draggable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'BottomSheet',
      preview: Button(
        label: const Text('Show bottom sheet'),
        onPressed: () => _show(context),
      ),
      controls: [
        BoolControl(label: 'Draggable', value: _draggable, onChanged: (v) => setState(() => _draggable = v)),
      ],
    );
  }
}

// ─── Drawer ───────────────────────────────────────────────────────────────────

class DrawerShowcase extends StatelessWidget {
  const DrawerShowcase({super.key});

  void _show(BuildContext context) {
    showDrawer(
      context,
      (_) => Drawer(
        title: const Text('Settings'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListItem(
              title: const Text('Account'),
              leading: const Icon(LucideIcons.user),
              onTap: () {},
            ),
            ListItem(
              title: const Text('Notifications'),
              leading: const Icon(LucideIcons.bell),
              onTap: () {},
            ),
            ListItem(
              title: const Text('Privacy'),
              leading: const Icon(LucideIcons.shield),
              onTap: () {},
            ),
            ListItem(
              title: const Text('Appearance'),
              leading: const Icon(LucideIcons.palette),
              divider: false,
              onTap: () {},
            ),
          ],
        ),
        footer: Button(
          label: const Text('Sign out'),
          variant: ButtonVariant.destructive,
          fullWidth: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Drawer',
      preview: Button(
        label: const Text('Show drawer'),
        onPressed: () => _show(context),
      ),
      controls: const [],
    );
  }
}

// ─── EmptyState ───────────────────────────────────────────────────────────────

class EmptyStateShowcase extends StatefulWidget {
  const EmptyStateShowcase({super.key});
  @override
  State<EmptyStateShowcase> createState() => _EmptyStateShowcaseState();
}

class _EmptyStateShowcaseState extends State<EmptyStateShowcase> {
  bool _hasAction = true;
  bool _large = false;

  @override
  Widget build(BuildContext context) {
    final action = _hasAction
        ? Button(
            label: const Text('Create project'),
            onPressed: () {},
          )
        : null;

    return ShowcasePage(
      title: 'EmptyState',
      preview: _large
          ? EmptyState.large(
              icon: LucideIcons.folderOpen,
              title: const Text('No projects yet'),
              description: const Text('Create your first project to get started.'),
              action: action,
            )
          : EmptyState(
              icon: LucideIcons.folderOpen,
              title: const Text('No projects yet'),
              description: const Text('Create your first project to get started.'),
              action: action,
            ),
      controls: [
        BoolControl(label: 'Large', value: _large, onChanged: (v) => setState(() => _large = v)),
        BoolControl(label: 'Has action', value: _hasAction, onChanged: (v) => setState(() => _hasAction = v)),
      ],
    );
  }
}

// ─── ErrorState ───────────────────────────────────────────────────────────────

class ErrorStateShowcase extends StatefulWidget {
  const ErrorStateShowcase({super.key});
  @override
  State<ErrorStateShowcase> createState() => _ErrorStateShowcaseState();
}

class _ErrorStateShowcaseState extends State<ErrorStateShowcase> {
  bool _hasDescription = true;
  bool _hasRetry = true;
  bool _large = false;

  @override
  Widget build(BuildContext context) {
    final base = _large
        ? ErrorState.large(
            title: const Text('Something went wrong'),
            description: _hasDescription
                ? const Text('We could not load your data. Please try again.')
                : null,
            onRetry: _hasRetry ? () {} : null,
          )
        : ErrorState(
            title: const Text('Something went wrong'),
            description: _hasDescription
                ? const Text('We could not load your data. Please try again.')
                : null,
            onRetry: _hasRetry ? () {} : null,
          );

    return ShowcasePage(
      title: 'ErrorState',
      preview: base,
      controls: [
        BoolControl(label: 'Large', value: _large, onChanged: (v) => setState(() => _large = v)),
        BoolControl(label: 'Has description', value: _hasDescription, onChanged: (v) => setState(() => _hasDescription = v)),
        BoolControl(label: 'Has retry', value: _hasRetry, onChanged: (v) => setState(() => _hasRetry = v)),
      ],
    );
  }
}

// ─── FormLayout ───────────────────────────────────────────────────────────────

class FormLayoutShowcase extends StatefulWidget {
  const FormLayoutShowcase({super.key});
  @override
  State<FormLayoutShowcase> createState() => _FormLayoutShowcaseState();
}

class _FormLayoutShowcaseState extends State<FormLayoutShowcase> {
  FormLayoutStyle _style = FormLayoutStyle.stacked;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'FormLayout',
      previewExpanded: true,
      preview: FormLayout(
        style: _style,
        groups: [
          FormLayoutGroup(
            title: const Text('Personal information'),
            subtitle: const Text('Your basic profile details.'),
            fields: const [
              TextField(label: 'First name', placeholder: 'Jane'),
              TextField(label: 'Last name', placeholder: 'Smith'),
              TextField(label: 'Email', placeholder: 'jane@example.com'),
            ],
          ),
          FormLayoutGroup(
            title: const Text('Preferences'),
            subtitle: const Text('Customise your experience.'),
            fields: [
              Checkbox(
                value: true,
                label: const Text('Receive marketing emails'),
                onChanged: (_) {},
              ),
              Checkbox(
                value: false,
                label: const Text('Enable two-factor authentication'),
                onChanged: (_) {},
              ),
            ],
          ),
        ],
        footerButtons: [
          Button(label: const Text('Save'), onPressed: () {}),
          Button(
            label: const Text('Cancel'),
            variant: ButtonVariant.secondary,
            onPressed: () {},
          ),
        ],
      ),
      controls: [
        SelectControl<FormLayoutStyle>(
          label: 'Style',
          value: _style,
          options: const [
            (FormLayoutStyle.stacked, 'Stacked'),
            (FormLayoutStyle.twoColumn, 'Two column'),
            (FormLayoutStyle.twoColumnWithCards, 'Two column + cards'),
          ],
          onChanged: (v) => setState(() => _style = v),
        ),
      ],
    );
  }
}

// ─── Modal ────────────────────────────────────────────────────────────────────

class ModalShowcase extends StatefulWidget {
  const ModalShowcase({super.key});
  @override
  State<ModalShowcase> createState() => _ModalShowcaseState();
}

class _ModalShowcaseState extends State<ModalShowcase> {
  bool _hasActions = true;

  void _show(BuildContext context) {
    showModal(
      context,
      (_) => Modal(
        title: const Text('Delete project'),
        body: const Text(
          'Are you sure you want to delete this project? This action cannot be undone and all data will be permanently removed.',
        ),
        actions: _hasActions
            ? [
                Button(
                  label: const Text('Cancel'),
                  variant: ButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
                Button(
                  label: const Text('Delete'),
                  variant: ButtonVariant.destructive,
                  onPressed: () => Navigator.pop(context),
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Modal',
      preview: Button(
        label: const Text('Show modal'),
        onPressed: () => _show(context),
      ),
      controls: [
        BoolControl(label: 'Has actions', value: _hasActions, onChanged: (v) => setState(() => _hasActions = v)),
      ],
    );
  }
}

// ─── SideNav ──────────────────────────────────────────────────────────────────

class SideNavShowcase extends StatefulWidget {
  const SideNavShowcase({super.key});
  @override
  State<SideNavShowcase> createState() => _SideNavShowcaseState();
}

class _SideNavShowcaseState extends State<SideNavShowcase> {
  String _selected = 'dashboard';
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'SideNav',
      preview: SizedBox(
        height: 320,
        child: SideNav<String>(
          selectedItem: _selected,
          isExpanded: _isExpanded,
          onItemSelected: (v) => setState(() => _selected = v),
          items: <SideNavItem<String>>[
            SideNavGroupTitle<String>('Main'),
            SideNavDestination<String>(
              value: 'dashboard',
              icon: const Icon(LucideIcons.layoutDashboard),
              label: const Text('Dashboard'),
            ),
            SideNavDestination<String>(
              value: 'inbox',
              icon: const Icon(LucideIcons.inbox),
              label: const Text('Inbox'),
              badge: const Badge(child: Text('4')),
            ),
            SideNavDestination<String>(
              value: 'projects',
              icon: const Icon(LucideIcons.folderOpen),
              label: const Text('Projects'),
            ),
            SideNavGroupTitle<String>('Account'),
            SideNavDestination<String>(
              value: 'profile',
              icon: const Icon(LucideIcons.user),
              label: const Text('Profile'),
            ),
            SideNavDestination<String>(
              value: 'settings',
              icon: const Icon(LucideIcons.settings),
              label: const Text('Settings'),
            ),
          ],
        ),
      ),
      controls: [
        BoolControl(label: 'Expanded', value: _isExpanded, onChanged: (v) => setState(() => _isExpanded = v)),
      ],
    );
  }
}

// ─── TopBar ───────────────────────────────────────────────────────────────────

class TopBarShowcase extends StatefulWidget {
  const TopBarShowcase({super.key});
  @override
  State<TopBarShowcase> createState() => _TopBarShowcaseState();
}

class _TopBarShowcaseState extends State<TopBarShowcase> {
  String _selected = 'home';
  bool _hasLeading = true;
  bool _hasActions = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'TopBar',
      preview: TopBar<String>(
        destinations: const [
          TopBarDestination(value: 'home', label: 'Home'),
          TopBarDestination(value: 'products', label: 'Products'),
          TopBarDestination(value: 'pricing', label: 'Pricing'),
          TopBarDestination(value: 'about', label: 'About'),
        ],
        selectedItem: _selected,
        onItemSelected: (v) => setState(() => _selected = v),
        leading: _hasLeading
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Acme',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              )
            : null,
        actions: _hasActions
            ? [
                Button.icon(
                  icon: const Icon(LucideIcons.bell),
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.medium,
                  onPressed: () {},
                ),
                Button.icon(
                  icon: const Icon(LucideIcons.user),
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.medium,
                  onPressed: () {},
                ),
              ]
            : [],
      ),
      controls: [
        BoolControl(label: 'Leading brand', value: _hasLeading, onChanged: (v) => setState(() => _hasLeading = v)),
        BoolControl(label: 'Action buttons', value: _hasActions, onChanged: (v) => setState(() => _hasActions = v)),
      ],
    );
  }
}
