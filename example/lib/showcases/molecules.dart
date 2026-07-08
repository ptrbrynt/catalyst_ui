import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/controls.dart';
import '../widgets/showcase_page.dart';

// ─── ActionTile ───────────────────────────────────────────────────────────────

class ActionTileShowcase extends StatefulWidget {
  const ActionTileShowcase({super.key});
  @override
  State<ActionTileShowcase> createState() => _ActionTileShowcaseState();
}

class _ActionTileShowcaseState extends State<ActionTileShowcase> {
  bool _hasSubtitle = true;
  bool _hasBadge = false;
  bool _trailing = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'ActionTile',
      preview: ActionTile(
        icon: const Icon(LucideIcons.bookOpen),
        iconBackgroundColor: const Color(0xFF6366F1),
        title: const Text('Introduction to Design'),
        subtitle: _hasSubtitle ? const Text('Learn the basics of UI/UX') : null,
        badge: _hasBadge ? const Badge(child: Text('New')) : null,
        trailing: _trailing
            ? Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: context.colorScheme.textMuted,
              )
            : null,
        onTap: () {},
      ),
      controls: [
        BoolControl(
          label: 'Subtitle',
          value: _hasSubtitle,
          onChanged: (v) => setState(() => _hasSubtitle = v),
        ),
        BoolControl(
          label: 'Badge',
          value: _hasBadge,
          onChanged: (v) => setState(() => _hasBadge = v),
        ),
        BoolControl(
          label: 'Trailing chevron',
          value: _trailing,
          onChanged: (v) => setState(() => _trailing = v),
        ),
      ],
    );
  }
}

// ─── Alert ────────────────────────────────────────────────────────────────────

class AlertShowcase extends StatefulWidget {
  const AlertShowcase({super.key});
  @override
  State<AlertShowcase> createState() => _AlertShowcaseState();
}

class _AlertShowcaseState extends State<AlertShowcase> {
  AlertTone _tone = AlertTone.info;
  bool _hasTitle = true;
  bool _hasBody = true;
  bool _hasAction = false;
  bool _hasDismiss = false;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Alert',
      preview: _visible
          ? Alert(
              tone: _tone,
              title: _hasTitle ? const Text('Heads up') : null,
              children: _hasBody
                  ? const [
                      Text(
                        'This is an important message that requires your attention.',
                      ),
                    ]
                  : null,
              action: _hasAction
                  ? Button(
                      label: const Text('Learn more'),
                      variant: ButtonVariant.secondary,
                      size: ButtonSize.small,
                      onPressed: () {},
                    )
                  : null,
              onDismiss: _hasDismiss
                  ? () => setState(() => _visible = false)
                  : null,
            )
          : Button(
              label: const Text('Reset'),
              variant: ButtonVariant.secondary,
              onPressed: () => setState(() => _visible = true),
            ),
      controls: [
        SelectControl<AlertTone>(
          label: 'Tone',
          value: _tone,
          options: const [
            (AlertTone.info, 'Info'),
            (AlertTone.success, 'Success'),
            (AlertTone.warning, 'Warning'),
            (AlertTone.danger, 'Danger'),
          ],
          onChanged: (v) => setState(() => _tone = v),
        ),
        BoolControl(
          label: 'Has title',
          value: _hasTitle,
          onChanged: (v) => setState(() => _hasTitle = v),
        ),
        BoolControl(
          label: 'Has body',
          value: _hasBody,
          onChanged: (v) => setState(() => _hasBody = v),
        ),
        BoolControl(
          label: 'Has action',
          value: _hasAction,
          onChanged: (v) => setState(() => _hasAction = v),
        ),
        BoolControl(
          label: 'Dismissible',
          value: _hasDismiss,
          onChanged: (v) => setState(() => _hasDismiss = v),
        ),
      ],
    );
  }
}

// ─── Breadcrumb ───────────────────────────────────────────────────────────────

class BreadcrumbShowcase extends StatefulWidget {
  const BreadcrumbShowcase({super.key});
  @override
  State<BreadcrumbShowcase> createState() => _BreadcrumbShowcaseState();
}

class _BreadcrumbShowcaseState extends State<BreadcrumbShowcase> {
  int _depth = 3;

  static const _segments = [
    'Home',
    'Library',
    'Documents',
    'Reports',
    'Q4 2024',
  ];

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Breadcrumb',
      preview: Breadcrumb(
        items: _segments.take(_depth).toList(),
        onItemTapped: (_) {},
        separatorIcon: LucideIcons.chevronRight,
      ),
      controls: [
        IntControl(
          label: 'Depth',
          value: _depth,
          min: 2,
          max: 5,
          onChanged: (v) => setState(() => _depth = v),
        ),
      ],
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class CardShowcase extends StatefulWidget {
  const CardShowcase({super.key});
  @override
  State<CardShowcase> createState() => _CardShowcaseState();
}

class _CardShowcaseState extends State<CardShowcase> {
  CardTone _tone = CardTone.subtle;
  bool _interactive = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Card',
      preview: SizedBox(
        width: 240,
        child: Card(
          tone: _tone,
          interactive: _interactive,
          onTap: _interactive ? () {} : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card title', style: context.typography.h3),
              const SizedBox(height: 4),
              Text(
                'A flexible container for displaying grouped content.',
                style: context.typography.p2.copyWith(
                  color: context.colorScheme.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
      controls: [
        SelectControl<CardTone>(
          label: 'Tone',
          value: _tone,
          options: const [
            (CardTone.subtle, 'Subtle'),
            (CardTone.surface, 'Surface'),
            (CardTone.brand, 'Brand'),
            (CardTone.tint, 'Tint'),
          ],
          onChanged: (v) => setState(() => _tone = v),
        ),
        BoolControl(
          label: 'Interactive',
          value: _interactive,
          onChanged: (v) => setState(() => _interactive = v),
        ),
      ],
    );
  }
}

// ─── ListItem ─────────────────────────────────────────────────────────────────

class ListItemShowcase extends StatefulWidget {
  const ListItemShowcase({super.key});
  @override
  State<ListItemShowcase> createState() => _ListItemShowcaseState();
}

class _ListItemShowcaseState extends State<ListItemShowcase> {
  bool _hasLeading = true;
  bool _hasSubtitle = true;
  bool _hasTrailing = true;
  bool _hasDivider = true;
  bool _tappable = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'ListItem',
      preview: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListItem(
              title: const Text('First item'),
              leading: _hasLeading ? const Icon(LucideIcons.inbox) : null,
              subtitle: _hasSubtitle ? const Text('Secondary line') : null,
              trailing: _hasTrailing
                  ? const Icon(LucideIcons.chevronRight, size: 16)
                  : null,
              divider: _hasDivider,
              onTap: _tappable ? () {} : null,
            ),
            ListItem(
              title: const Text('Second item'),
              leading: _hasLeading ? const Icon(LucideIcons.star) : null,
              subtitle: _hasSubtitle ? const Text('Another line') : null,
              trailing: _hasTrailing
                  ? const Icon(LucideIcons.chevronRight, size: 16)
                  : null,
              divider: false,
              onTap: _tappable ? () {} : null,
            ),
          ],
        ),
      ),
      controls: [
        BoolControl(
          label: 'Leading icon',
          value: _hasLeading,
          onChanged: (v) => setState(() => _hasLeading = v),
        ),
        BoolControl(
          label: 'Subtitle',
          value: _hasSubtitle,
          onChanged: (v) => setState(() => _hasSubtitle = v),
        ),
        BoolControl(
          label: 'Trailing icon',
          value: _hasTrailing,
          onChanged: (v) => setState(() => _hasTrailing = v),
        ),
        BoolControl(
          label: 'Divider',
          value: _hasDivider,
          onChanged: (v) => setState(() => _hasDivider = v),
        ),
        BoolControl(
          label: 'Tappable',
          value: _tappable,
          onChanged: (v) => setState(() => _tappable = v),
        ),
      ],
    );
  }
}

// ─── Pagination ───────────────────────────────────────────────────────────────

class PaginationShowcase extends StatefulWidget {
  const PaginationShowcase({super.key});
  @override
  State<PaginationShowcase> createState() => _PaginationShowcaseState();
}

class _PaginationShowcaseState extends State<PaginationShowcase> {
  int _page = 0;
  int _pageCount = 9;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Pagination',
      preview: Pagination(
        currentPage: _page,
        pageCount: _pageCount,
        onChanged: (p) => setState(() => _page = p),
        forwardIcon: LucideIcons.chevronRight,
        backIcon: LucideIcons.chevronLeft,
      ),
      controls: [
        IntControl(
          label: 'Total pages',
          value: _pageCount + 1,
          min: 2,
          max: 20,
          onChanged: (v) => setState(() {
            _pageCount = v - 1;
            if (_page > _pageCount) _page = _pageCount;
          }),
        ),
      ],
    );
  }
}

// ─── SegmentedControl ─────────────────────────────────────────────────────────

class SegmentedControlShowcase extends StatefulWidget {
  const SegmentedControlShowcase({super.key});
  @override
  State<SegmentedControlShowcase> createState() =>
      _SegmentedControlShowcaseState();
}

class _SegmentedControlShowcaseState extends State<SegmentedControlShowcase> {
  String _value = 'week';
  bool _fullWidth = false;

  @override
  Widget build(BuildContext context) {
    final options = const [
      SegmentedControlOption(value: 'day', label: 'Day'),
      SegmentedControlOption(value: 'week', label: 'Week'),
      SegmentedControlOption(value: 'month', label: 'Month'),
      SegmentedControlOption(value: 'year', label: 'Year'),
    ];

    return ShowcasePage(
      title: 'SegmentedControl',
      preview: SegmentedControl<String>(
        value: _value,
        options: options,
        fullWidth: _fullWidth,
        onChanged: (v) => setState(() => _value = v),
      ),
      controls: [
        BoolControl(
          label: 'Full width',
          value: _fullWidth,
          onChanged: (v) => setState(() => _fullWidth = v),
        ),
      ],
    );
  }
}

// ─── Select ───────────────────────────────────────────────────────────────────

class SelectShowcase extends StatefulWidget {
  const SelectShowcase({super.key});
  @override
  State<SelectShowcase> createState() => _SelectShowcaseState();
}

class _SelectShowcaseState extends State<SelectShowcase> {
  String? _value;
  SelectSize _size = SelectSize.medium;
  bool _disabled = false;
  bool _hasLabel = true;
  bool _hasHelper = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Select',
      preview: SizedBox(
        width: 280,
        child: Select<String>(
          label: _hasLabel ? 'Country' : null,
          value: _value,
          size: _size,
          disabled: _disabled,
          placeholder: 'Select a country…',
          helper: _hasHelper ? 'Choose your country of residence' : null,
          error: _hasError ? 'Please select a country' : null,
          options: const [
            SelectOption(value: 'us', label: 'United States'),
            SelectOption(value: 'gb', label: 'United Kingdom'),
            SelectOption(value: 'ca', label: 'Canada'),
            SelectOption(value: 'au', label: 'Australia'),
            SelectOption(value: 'de', label: 'Germany'),
          ],
          onChanged: _disabled ? null : (v) => setState(() => _value = v),
          trailingIcon: LucideIcons.chevronDown,
          checkIcon: LucideIcons.check,
        ),
      ),
      controls: [
        SelectControl<SelectSize>(
          label: 'Size',
          value: _size,
          options: const [
            (SelectSize.small, 'Small'),
            (SelectSize.medium, 'Medium'),
            (SelectSize.large, 'Large'),
          ],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(
          label: 'Disabled',
          value: _disabled,
          onChanged: (v) => setState(() => _disabled = v),
        ),
        BoolControl(
          label: 'Has label',
          value: _hasLabel,
          onChanged: (v) => setState(() => _hasLabel = v),
        ),
        BoolControl(
          label: 'Has helper',
          value: _hasHelper,
          onChanged: (v) => setState(() => _hasHelper = v),
        ),
        BoolControl(
          label: 'Show error',
          value: _hasError,
          onChanged: (v) => setState(() => _hasError = v),
        ),
      ],
    );
  }
}

// ─── MultiSelect ────────────────────────────────────────────────────────────

class MultiSelectShowcase extends StatefulWidget {
  const MultiSelectShowcase({super.key});
  @override
  State<MultiSelectShowcase> createState() => _MultiSelectShowcaseState();
}

class _MultiSelectShowcaseState extends State<MultiSelectShowcase> {
  List<String> _values = [];
  SelectSize _size = SelectSize.medium;
  bool _disabled = false;
  bool _hasLabel = true;
  bool _hasHelper = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'MultiSelect',
      preview: SizedBox(
        width: 280,
        child: MultiSelect<String>(
          label: _hasLabel ? 'Countries' : null,
          value: _values,
          size: _size,
          disabled: _disabled,
          placeholder: 'Select countries…',
          helper: _hasHelper ? 'Choose one or more countries' : null,
          error: _hasError ? 'Please select a country' : null,
          options: const [
            SelectOption(value: 'us', label: 'United States'),
            SelectOption(value: 'gb', label: 'United Kingdom'),
            SelectOption(value: 'ca', label: 'Canada'),
            SelectOption(value: 'au', label: 'Australia'),
            SelectOption(value: 'de', label: 'Germany'),
          ],
          onChanged: _disabled ? null : (v) => setState(() => _values = v),
          trailingIcon: LucideIcons.chevronDown,
          checkIcon: LucideIcons.check,
        ),
      ),
      controls: [
        SelectControl<SelectSize>(
          label: 'Size',
          value: _size,
          options: const [
            (SelectSize.small, 'Small'),
            (SelectSize.medium, 'Medium'),
            (SelectSize.large, 'Large'),
          ],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(
          label: 'Disabled',
          value: _disabled,
          onChanged: (v) => setState(() => _disabled = v),
        ),
        BoolControl(
          label: 'Has label',
          value: _hasLabel,
          onChanged: (v) => setState(() => _hasLabel = v),
        ),
        BoolControl(
          label: 'Has helper',
          value: _hasHelper,
          onChanged: (v) => setState(() => _hasHelper = v),
        ),
        BoolControl(
          label: 'Show error',
          value: _hasError,
          onChanged: (v) => setState(() => _hasError = v),
        ),
      ],
    );
  }
}

// ─── Snackbar ─────────────────────────────────────────────────────────────────

class SnackbarShowcase extends StatefulWidget {
  const SnackbarShowcase({super.key});
  @override
  State<SnackbarShowcase> createState() => _SnackbarShowcaseState();
}

class _SnackbarShowcaseState extends State<SnackbarShowcase> {
  SnackbarTone _tone = SnackbarTone.dark;
  bool _hasAction = false;
  bool _hasIcon = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Snackbar',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Snackbar(
            message: const Text('Your changes have been saved'),
            tone: _tone,
            icon: _hasIcon ? const Icon(LucideIcons.circleCheck) : null,
            action: _hasAction
                ? SnackbarAction(label: 'Undo', onPressed: () {})
                : null,
          ),
          const SizedBox(height: 16),
          Button(
            label: const Text('Show as toast'),
            variant: ButtonVariant.secondary,
            size: ButtonSize.small,
            onPressed: () => context.showSnackbar(
              Snackbar(
                message: const Text('Your changes have been saved'),
                tone: _tone,
                icon: _hasIcon ? const Icon(LucideIcons.circleCheck) : null,
                action: _hasAction
                    ? SnackbarAction(label: 'Undo', onPressed: () {})
                    : null,
              ),
            ),
          ),
        ],
      ),
      controls: [
        SelectControl<SnackbarTone>(
          label: 'Tone',
          value: _tone,
          options: const [
            (SnackbarTone.dark, 'Dark'),
            (SnackbarTone.success, 'Success'),
            (SnackbarTone.danger, 'Danger'),
          ],
          onChanged: (v) => setState(() => _tone = v),
        ),
        BoolControl(
          label: 'Has action',
          value: _hasAction,
          onChanged: (v) => setState(() => _hasAction = v),
        ),
        BoolControl(
          label: 'Has icon',
          value: _hasIcon,
          onChanged: (v) => setState(() => _hasIcon = v),
        ),
      ],
    );
  }
}

// ─── Stepper ──────────────────────────────────────────────────────────────────

class StepperShowcase extends StatefulWidget {
  const StepperShowcase({super.key});
  @override
  State<StepperShowcase> createState() => _StepperShowcaseState();
}

class _StepperShowcaseState extends State<StepperShowcase> {
  int _current = 1;
  int _stepCount = 4;

  static const _allSteps = [
    'Account',
    'Profile',
    'Preferences',
    'Review',
    'Confirm',
  ];

  @override
  Widget build(BuildContext context) {
    final steps = _allSteps.take(_stepCount).toList();
    final current = _current.clamp(0, _stepCount - 1);

    return ShowcasePage(
      title: 'Stepper',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stepper(current: current, steps: steps, checkIcon: LucideIcons.check),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                label: const Text('Back'),
                variant: ButtonVariant.secondary,
                size: ButtonSize.small,
                onPressed: current > 0
                    ? () => setState(() => _current = current - 1)
                    : null,
              ),
              const SizedBox(width: 8),
              Button(
                label: const Text('Next'),
                size: ButtonSize.small,
                onPressed: current < _stepCount - 1
                    ? () => setState(() => _current = current + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
      controls: [
        IntControl(
          label: 'Steps',
          value: _stepCount,
          min: 2,
          max: 5,
          onChanged: (v) => setState(() {
            _stepCount = v;
            if (_current >= v) _current = v - 1;
          }),
        ),
      ],
    );
  }
}

// ─── Tabs ─────────────────────────────────────────────────────────────────────

class TabsShowcase extends StatefulWidget {
  const TabsShowcase({super.key});
  @override
  State<TabsShowcase> createState() => _TabsShowcaseState();
}

class _TabsShowcaseState extends State<TabsShowcase> {
  String _value = 'all';
  bool _hasBadge = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Tabs',
      preview: Tabs<String>(
        value: _value,
        options: [
          const TabOption(value: 'all', label: 'All'),
          TabOption(
            value: 'active',
            label: 'Active',
            badge: _hasBadge ? '3' : null,
          ),
          TabOption(
            value: 'draft',
            label: 'Draft',
            badge: _hasBadge ? '12' : null,
          ),
          const TabOption(value: 'archived', label: 'Archived'),
        ],
        onChanged: (v) => setState(() => _value = v),
      ),
      controls: [
        BoolControl(
          label: 'Show badges',
          value: _hasBadge,
          onChanged: (v) => setState(() => _hasBadge = v),
        ),
      ],
    );
  }
}

// ─── TextField ────────────────────────────────────────────────────────────────

class TextFieldShowcase extends StatefulWidget {
  const TextFieldShowcase({super.key});
  @override
  State<TextFieldShowcase> createState() => _TextFieldShowcaseState();
}

class _TextFieldShowcaseState extends State<TextFieldShowcase> {
  TextFieldSize _size = TextFieldSize.medium;
  bool _disabled = false;
  bool _hasLabel = true;
  bool _hasHelper = false;
  bool _hasError = false;
  bool _required = false;
  bool _obscureText = false;
  bool _hasLeading = false;
  bool _hasTrailing = false;
  bool _multiLine = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'TextField',
      preview: SizedBox(
        width: 280,
        child: TextField(
          label: _hasLabel ? 'Email address' : null,
          placeholder: 'you@example.com',
          helper: _hasHelper ? 'We will never share your email' : null,
          error: _hasError ? 'Please enter a valid email' : null,
          enabled: !_disabled,
          obscureText: _obscureText,
          leading: _hasLeading ? const Icon(LucideIcons.mail) : null,
          trailing: _hasTrailing ? const Icon(LucideIcons.x) : null,
          required: _required,
          size: _size,
          maxLines: _multiLine ? 4 : 1,
        ),
      ),
      controls: [
        SelectControl<TextFieldSize>(
          label: 'Size',
          value: _size,
          options: const [
            (TextFieldSize.small, 'Small'),
            (TextFieldSize.medium, 'Medium'),
            (TextFieldSize.large, 'Large'),
          ],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(
          label: 'Disabled',
          value: _disabled,
          onChanged: (v) => setState(() => _disabled = v),
        ),
        BoolControl(
          label: 'Has label',
          value: _hasLabel,
          onChanged: (v) => setState(() => _hasLabel = v),
        ),
        BoolControl(
          label: 'Has helper',
          value: _hasHelper,
          onChanged: (v) => setState(() => _hasHelper = v),
        ),
        BoolControl(
          label: 'Show error',
          value: _hasError,
          onChanged: (v) => setState(() => _hasError = v),
        ),
        BoolControl(
          label: 'Required',
          value: _required,
          onChanged: (v) => setState(() => _required = v),
        ),
        BoolControl(
          label: 'Obscure text',
          value: _obscureText,
          onChanged: (v) => setState(() => _obscureText = v),
        ),
        BoolControl(
          label: 'Leading icon',
          value: _hasLeading,
          onChanged: (v) => setState(() => _hasLeading = v),
        ),
        BoolControl(
          label: 'Trailing icon',
          value: _hasTrailing,
          onChanged: (v) => setState(() => _hasTrailing = v),
        ),
        BoolControl(
          label: 'Multi-line',
          value: _multiLine,
          onChanged: (v) => setState(() => _multiLine = v),
        ),
      ],
    );
  }
}

// ─── Tooltip ──────────────────────────────────────────────────────────────────

class TooltipShowcase extends StatefulWidget {
  const TooltipShowcase({super.key});
  @override
  State<TooltipShowcase> createState() => _TooltipShowcaseState();
}

class _TooltipShowcaseState extends State<TooltipShowcase> {
  TooltipSide _side = TooltipSide.top;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Tooltip',
      preview: Tooltip(
        content: 'This is a helpful tooltip',
        side: _side,
        child: Button(
          label: const Text('Hover me'),
          variant: ButtonVariant.secondary,
          onPressed: () {},
        ),
      ),
      controls: [
        SelectControl<TooltipSide>(
          label: 'Side',
          value: _side,
          options: const [
            (TooltipSide.top, 'Top'),
            (TooltipSide.bottom, 'Bottom'),
          ],
          onChanged: (v) => setState(() => _side = v),
        ),
      ],
    );
  }
}

// ─── ValueRow ─────────────────────────────────────────────────────────────────

class ValueRowShowcase extends StatefulWidget {
  const ValueRowShowcase({super.key});
  @override
  State<ValueRowShowcase> createState() => _ValueRowShowcaseState();
}

class _ValueRowShowcaseState extends State<ValueRowShowcase> {
  bool _divider = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'ValueRow',
      preview: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueRow('Plan', 'Pro', divider: _divider),
            ValueRow('Status', 'Active', divider: _divider),
            ValueRow('Next billing', 'Jul 1, 2025', divider: _divider),
            const ValueRow('Amount', r'$49 / mo', divider: false),
          ],
        ),
      ),
      controls: [
        BoolControl(
          label: 'Dividers',
          value: _divider,
          onChanged: (v) => setState(() => _divider = v),
        ),
      ],
    );
  }
}
