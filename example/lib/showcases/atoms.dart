import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/controls.dart';
import '../widgets/showcase_page.dart';

// ─── Avatar ───────────────────────────────────────────────────────────────────

class AvatarShowcase extends StatefulWidget {
  const AvatarShowcase({super.key});
  @override
  State<AvatarShowcase> createState() => _AvatarShowcaseState();
}

class _AvatarShowcaseState extends State<AvatarShowcase> {
  double _size = 40;
  String _statusKey = 'none';
  String _shapeKey = 'circle';

  AvatarStatus? get _status => switch (_statusKey) {
    'online' => AvatarStatus.online,
    'busy' => AvatarStatus.busy,
    'away' => AvatarStatus.away,
    _ => null,
  };

  BoxShape get _shape =>
      _shapeKey == 'rectangle' ? BoxShape.rectangle : BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Avatar',
      preview: Avatar(name: 'Jane Smith', size: _size, status: _status, shape: _shape),
      controls: [
        SliderControl(label: 'Size', value: _size, min: 24, max: 80, onChanged: (v) => setState(() => _size = v)),
        SelectControl<String>(
          label: 'Status',
          value: _statusKey,
          options: const [('none', 'None'), ('online', 'Online'), ('busy', 'Busy'), ('away', 'Away')],
          onChanged: (v) => setState(() => _statusKey = v),
        ),
        SelectControl<String>(
          label: 'Shape',
          value: _shapeKey,
          options: const [('circle', 'Circle'), ('rectangle', 'Rectangle')],
          onChanged: (v) => setState(() => _shapeKey = v),
        ),
      ],
    );
  }
}

// ─── AvatarStack ──────────────────────────────────────────────────────────────

class AvatarStackShowcase extends StatefulWidget {
  const AvatarStackShowcase({super.key});
  @override
  State<AvatarStackShowcase> createState() => _AvatarStackShowcaseState();
}

class _AvatarStackShowcaseState extends State<AvatarStackShowcase> {
  int _count = 4;
  String _maxKey = 'none';

  int? get _maxCount => switch (_maxKey) {
    '2' => 2,
    '3' => 3,
    _ => null,
  };

  static const _names = ['Alice Brown', 'Bob Smith', 'Carol White', 'Dan Jones', 'Eve Davis'];

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'AvatarStack',
      preview: AvatarStack(
        avatars: List.generate(_count, (i) => Avatar(name: _names[i])),
        maxCount: _maxCount,
      ),
      controls: [
        IntControl(label: 'Count', value: _count, min: 2, max: 5, onChanged: (v) => setState(() => _count = v)),
        SelectControl<String>(
          label: 'Max count',
          value: _maxKey,
          options: const [('none', 'No limit'), ('2', '2'), ('3', '3')],
          onChanged: (v) => setState(() => _maxKey = v),
        ),
      ],
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

class BadgeShowcase extends StatefulWidget {
  const BadgeShowcase({super.key});
  @override
  State<BadgeShowcase> createState() => _BadgeShowcaseState();
}

class _BadgeShowcaseState extends State<BadgeShowcase> {
  BadgeVariant _variant = BadgeVariant.neutral;
  BadgeSize _size = BadgeSize.medium;
  bool _showDot = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Badge',
      preview: Badge(
        variant: _variant,
        size: _size,
        showDot: _showDot,
        child: const Text('Label'),
      ),
      controls: [
        SelectControl<BadgeVariant>(
          label: 'Variant',
          value: _variant,
          options: const [
            (BadgeVariant.neutral, 'Neutral'),
            (BadgeVariant.info, 'Info'),
            (BadgeVariant.success, 'Success'),
            (BadgeVariant.warning, 'Warning'),
            (BadgeVariant.danger, 'Danger'),
            (BadgeVariant.brand, 'Brand'),
          ],
          onChanged: (v) => setState(() => _variant = v),
        ),
        SelectControl<BadgeSize>(
          label: 'Size',
          value: _size,
          options: const [(BadgeSize.small, 'Small'), (BadgeSize.medium, 'Medium'), (BadgeSize.large, 'Large')],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(label: 'Show dot', value: _showDot, onChanged: (v) => setState(() => _showDot = v)),
      ],
    );
  }
}

// ─── Button ───────────────────────────────────────────────────────────────────

class ButtonShowcase extends StatefulWidget {
  const ButtonShowcase({super.key});
  @override
  State<ButtonShowcase> createState() => _ButtonShowcaseState();
}

class _ButtonShowcaseState extends State<ButtonShowcase> {
  ButtonVariant _variant = ButtonVariant.primary;
  ButtonSize _size = ButtonSize.large;
  bool _loading = false;
  bool _disabled = false;
  bool _fullWidth = false;
  bool _elevated = false;
  bool _leadingIcon = false;
  bool _trailingIcon = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Button',
      preview: Button(
        label: const Text('Click me'),
        variant: _variant,
        size: _size,
        loading: _loading,
        fullWidth: _fullWidth,
        elevated: _elevated,
        leadingIcon: _leadingIcon ? const Icon(LucideIcons.star) : null,
        trailingIcon: _trailingIcon ? const Icon(LucideIcons.arrowRight) : null,
        onPressed: _disabled ? null : () {},
      ),
      controls: [
        SelectControl<ButtonVariant>(
          label: 'Variant',
          value: _variant,
          options: const [
            (ButtonVariant.primary, 'Primary'),
            (ButtonVariant.secondary, 'Secondary'),
            (ButtonVariant.tertiary, 'Tertiary'),
            (ButtonVariant.ghost, 'Ghost'),
            (ButtonVariant.destructive, 'Destructive'),
            (ButtonVariant.success, 'Success'),
          ],
          onChanged: (v) => setState(() => _variant = v),
        ),
        SelectControl<ButtonSize>(
          label: 'Size',
          value: _size,
          options: const [
            (ButtonSize.small, 'Small'),
            (ButtonSize.medium, 'Medium'),
            (ButtonSize.large, 'Large'),
            (ButtonSize.extraLarge, 'Extra Large'),
          ],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(label: 'Loading', value: _loading, onChanged: (v) => setState(() => _loading = v)),
        BoolControl(label: 'Disabled', value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
        BoolControl(label: 'Full width', value: _fullWidth, onChanged: (v) => setState(() => _fullWidth = v)),
        BoolControl(label: 'Elevated', value: _elevated, onChanged: (v) => setState(() => _elevated = v)),
        BoolControl(label: 'Leading icon', value: _leadingIcon, onChanged: (v) => setState(() => _leadingIcon = v)),
        BoolControl(label: 'Trailing icon', value: _trailingIcon, onChanged: (v) => setState(() => _trailingIcon = v)),
      ],
    );
  }
}

// ─── Checkbox ─────────────────────────────────────────────────────────────────

class CheckboxShowcase extends StatefulWidget {
  const CheckboxShowcase({super.key});
  @override
  State<CheckboxShowcase> createState() => _CheckboxShowcaseState();
}

class _CheckboxShowcaseState extends State<CheckboxShowcase> {
  bool _value = false;
  bool _disabled = false;
  CheckboxSize _size = CheckboxSize.medium;
  bool _hasLabel = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Checkbox',
      preview: Checkbox(
        value: _value,
        size: _size,
        label: _hasLabel ? const Text('Accept terms and conditions') : null,
        onChanged: _disabled ? null : (v) => setState(() => _value = v ?? false),
      ),
      controls: [
        BoolControl(label: 'Checked', value: _value, onChanged: (v) => setState(() => _value = v)),
        BoolControl(label: 'Disabled', value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
        SelectControl<CheckboxSize>(
          label: 'Size',
          value: _size,
          options: const [(CheckboxSize.small, 'Small'), (CheckboxSize.medium, 'Medium'), (CheckboxSize.large, 'Large')],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(label: 'Has label', value: _hasLabel, onChanged: (v) => setState(() => _hasLabel = v)),
      ],
    );
  }
}

// ─── Chip ─────────────────────────────────────────────────────────────────────

class ChipShowcase extends StatefulWidget {
  const ChipShowcase({super.key});
  @override
  State<ChipShowcase> createState() => _ChipShowcaseState();
}

class _ChipShowcaseState extends State<ChipShowcase> {
  bool _selected1 = false;
  bool _selected2 = true;
  bool _selected3 = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Chip',
      preview: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          Chip(
            isSelected: _selected1,
            onTap: () => setState(() => _selected1 = !_selected1),
            child: const Text('Design'),
          ),
          Chip(
            isSelected: _selected2,
            onTap: () => setState(() => _selected2 = !_selected2),
            child: const Text('Engineering'),
          ),
          Chip(
            isSelected: _selected3,
            onTap: () => setState(() => _selected3 = !_selected3),
            child: const Text('Product'),
          ),
        ],
      ),
      controls: const [],
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class DividerShowcase extends StatefulWidget {
  const DividerShowcase({super.key});
  @override
  State<DividerShowcase> createState() => _DividerShowcaseState();
}

class _DividerShowcaseState extends State<DividerShowcase> {
  bool _vertical = false;
  bool _hasLabel = false;

  @override
  Widget build(BuildContext context) {
    Widget divider;
    if (_vertical) {
      divider = SizedBox(
        height: 60,
        child: Divider.vertical(),
      );
    } else {
      divider = SizedBox(
        width: 240,
        child: _hasLabel ? Divider(label: const Text('or')) : const Divider(),
      );
    }

    return ShowcasePage(
      title: 'Divider',
      preview: divider,
      controls: [
        BoolControl(label: 'Vertical', value: _vertical, onChanged: (v) => setState(() => _vertical = v)),
        if (!_vertical)
          BoolControl(label: 'Has label', value: _hasLabel, onChanged: (v) => setState(() => _hasLabel = v)),
      ],
    );
  }
}

// ─── ProgressBar ──────────────────────────────────────────────────────────────

class ProgressBarShowcase extends StatefulWidget {
  const ProgressBarShowcase({super.key});
  @override
  State<ProgressBarShowcase> createState() => _ProgressBarShowcaseState();
}

class _ProgressBarShowcaseState extends State<ProgressBarShowcase> {
  double _value = 0.6;
  ProgressBarTone _tone = ProgressBarTone.brand;
  ProgressBarSize _size = ProgressBarSize.medium;
  bool _hasTitle = true;
  bool _hasValueLabel = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'ProgressBar',
      preview: SizedBox(
        width: 280,
        child: ProgressBar(
          value: _value,
          tone: _tone,
          size: _size,
          title: _hasTitle ? const Text('Loading…') : null,
          valueLabel: _hasValueLabel ? Text('${(_value * 100).round()}%') : null,
        ),
      ),
      controls: [
        SliderControl(label: 'Value', value: _value, min: 0, max: 1, onChanged: (v) => setState(() => _value = v)),
        SelectControl<ProgressBarTone>(
          label: 'Tone',
          value: _tone,
          options: const [
            (ProgressBarTone.brand, 'Brand'),
            (ProgressBarTone.success, 'Success'),
            (ProgressBarTone.warning, 'Warning'),
            (ProgressBarTone.danger, 'Danger'),
          ],
          onChanged: (v) => setState(() => _tone = v),
        ),
        SelectControl<ProgressBarSize>(
          label: 'Size',
          value: _size,
          options: const [
            (ProgressBarSize.small, 'Small'),
            (ProgressBarSize.medium, 'Medium'),
            (ProgressBarSize.large, 'Large'),
          ],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(label: 'Has title', value: _hasTitle, onChanged: (v) => setState(() => _hasTitle = v)),
        BoolControl(label: 'Has value label', value: _hasValueLabel, onChanged: (v) => setState(() => _hasValueLabel = v)),
      ],
    );
  }
}

// ─── Radio ────────────────────────────────────────────────────────────────────

class RadioShowcase extends StatefulWidget {
  const RadioShowcase({super.key});
  @override
  State<RadioShowcase> createState() => _RadioShowcaseState();
}

class _RadioShowcaseState extends State<RadioShowcase> {
  int _selected = 0;
  bool _disabled = false;
  RadioSize _size = RadioSize.medium;
  bool _hasLabel = true;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Radio',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio(
            value: _selected == 0,
            size: _size,
            label: _hasLabel ? const Text('Option A') : null,
            onSelected: _disabled ? null : (_) => setState(() => _selected = 0),
          ),
          const SizedBox(height: 12),
          Radio(
            value: _selected == 1,
            size: _size,
            label: _hasLabel ? const Text('Option B') : null,
            onSelected: _disabled ? null : (_) => setState(() => _selected = 1),
          ),
          const SizedBox(height: 12),
          Radio(
            value: _selected == 2,
            size: _size,
            label: _hasLabel ? const Text('Option C') : null,
            onSelected: _disabled ? null : (_) => setState(() => _selected = 2),
          ),
        ],
      ),
      controls: [
        BoolControl(label: 'Disabled', value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
        SelectControl<RadioSize>(
          label: 'Size',
          value: _size,
          options: const [(RadioSize.small, 'Small'), (RadioSize.medium, 'Medium'), (RadioSize.large, 'Large')],
          onChanged: (v) => setState(() => _size = v),
        ),
        BoolControl(label: 'Has label', value: _hasLabel, onChanged: (v) => setState(() => _hasLabel = v)),
      ],
    );
  }
}

// ─── Slider ───────────────────────────────────────────────────────────────────

class SliderShowcase extends StatefulWidget {
  const SliderShowcase({super.key});
  @override
  State<SliderShowcase> createState() => _SliderShowcaseState();
}

class _SliderShowcaseState extends State<SliderShowcase> {
  double _value = 0.5;
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Slider',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 280,
            child: Slider(
              value: _value,
              onChanged: _disabled ? null : (v) => setState(() => _value = v),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _value.toStringAsFixed(2),
            style: context.typography.p3.copyWith(color: context.colorScheme.textSubtle),
          ),
        ],
      ),
      controls: [
        BoolControl(label: 'Disabled', value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
      ],
    );
  }
}

// ─── Spinner ──────────────────────────────────────────────────────────────────

class SpinnerShowcase extends StatelessWidget {
  const SpinnerShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Spinner',
      preview: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spinner.small(),
              const SizedBox(height: 8),
              Text('Small', style: context.typography.caption.copyWith(color: context.colorScheme.textSubtle)),
            ],
          ),
          const SizedBox(width: 28),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spinner(),
              const SizedBox(height: 8),
              Text('Default', style: context.typography.caption.copyWith(color: context.colorScheme.textSubtle)),
            ],
          ),
          const SizedBox(width: 28),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spinner.large(),
              const SizedBox(height: 8),
              Text('Large', style: context.typography.caption.copyWith(color: context.colorScheme.textSubtle)),
            ],
          ),
          const SizedBox(width: 28),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spinner.extraLarge(),
              const SizedBox(height: 8),
              Text('XL', style: context.typography.caption.copyWith(color: context.colorScheme.textSubtle)),
            ],
          ),
        ],
      ),
      controls: const [],
    );
  }
}

// ─── StatusDot ────────────────────────────────────────────────────────────────

class StatusDotShowcase extends StatefulWidget {
  const StatusDotShowcase({super.key});
  @override
  State<StatusDotShowcase> createState() => _StatusDotShowcaseState();
}

class _StatusDotShowcaseState extends State<StatusDotShowcase> {
  String _toneKey = 'success';
  bool _pulse = false;

  StatusTone get _tone => switch (_toneKey) {
    'warning' => StatusTone.warning,
    'danger' => StatusTone.danger,
    'info' => StatusTone.info,
    'neutral' => StatusTone.neutral,
    _ => StatusTone.success,
  };

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'StatusDot',
      preview: StatusDot(tone: _tone, pulse: _pulse),
      controls: [
        SelectControl<String>(
          label: 'Tone',
          value: _toneKey,
          options: const [
            ('success', 'Success'),
            ('warning', 'Warning'),
            ('danger', 'Danger'),
            ('info', 'Info'),
            ('neutral', 'Neutral'),
          ],
          onChanged: (v) => setState(() => _toneKey = v),
        ),
        BoolControl(label: 'Pulse', value: _pulse, onChanged: (v) => setState(() => _pulse = v)),
      ],
    );
  }
}

// ─── Switch ───────────────────────────────────────────────────────────────────

class SwitchShowcase extends StatefulWidget {
  const SwitchShowcase({super.key});
  @override
  State<SwitchShowcase> createState() => _SwitchShowcaseState();
}

class _SwitchShowcaseState extends State<SwitchShowcase> {
  bool _value = false;
  bool _disabled = false;
  SwitchSize _size = SwitchSize.medium;

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Switch',
      preview: Switch(
        value: _value,
        size: _size,
        onChanged: _disabled ? null : (v) => setState(() => _value = v),
      ),
      controls: [
        BoolControl(label: 'On', value: _value, onChanged: (v) => setState(() => _value = v)),
        BoolControl(label: 'Disabled', value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
        SelectControl<SwitchSize>(
          label: 'Size',
          value: _size,
          options: const [(SwitchSize.small, 'Small'), (SwitchSize.medium, 'Medium'), (SwitchSize.large, 'Large')],
          onChanged: (v) => setState(() => _size = v),
        ),
      ],
    );
  }
}
