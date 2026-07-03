# MultiSelect Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `MultiSelect<T>` molecule that lets users pick multiple values from a dropdown, visually and structurally matching `Select<T>` but backed by a `List<T>` selection.

**Architecture:** A new `lib/src/components/molecules/multi_select.dart` file reuses `Select`'s existing `SelectItem`/`SelectOption`/`SelectDivider`/`SelectSize` types. `MultiSelect` follows the same `OverlayEntry` + `LayerLink` positioning pattern as `Select`, but its dropdown rows use the existing `Checkbox` atom and toggle membership in a list instead of replacing a single value — and the dropdown stays open across selections, closing only on outside tap or re-tapping the trigger.

**Tech Stack:** Flutter (`flutter/widgets.dart` only — no Material/Cupertino), this repo's existing theme/token system (`context.colorScheme`, `context.typography`, `context.motion`, `context.shadows`, `context.iconography`).

## Global Constraints

- No `package:flutter/material.dart` or `package:flutter/cupertino.dart` imports anywhere — widgets only, per `CLAUDE.md`.
- Every public class, constructor, field, method, and enum value needs a `///` doc comment (`public_member_api_docs` lint).
- `dart analyze lib/` must report `No issues found!` before any task is considered done.
- Reuse `SelectItem<T>`, `SelectOption<T>`, `SelectDivider<T>`, `SelectSize` from `select.dart` — do not create parallel `MultiSelect`-specific versions of these types.
- `onChanged` is called with the full updated `List<T>` selection, not a single delta value.
- The dropdown does not close after a selection; only outside-tap or re-tapping the trigger closes it.
- This repo ships no widget test suite for components — verification is `dart analyze lib/` plus manual visual check via the `example` showcase app.

---

### Task 1: Implement the `MultiSelect` widget and export it

**Files:**
- Create: `lib/src/components/molecules/multi_select.dart`
- Modify: `lib/src/components/molecules/molecules.dart`

**Interfaces:**
- Consumes: `SelectItem<T>`, `SelectOption<T>`, `SelectDivider<T>`, `SelectSize` from `lib/src/components/molecules/select.dart`; `Checkbox`, `CheckboxSize` from `lib/src/components/atoms/checkbox.dart`; `context.colorScheme`, `context.typography`, `context.motion`, `context.shadows`, `context.iconography` from `lib/src/theme/extensions.dart`; `Radii` from `lib/src/tokens/radius.dart`.
- Produces: `MultiSelect<T>` widget with constructor `MultiSelect({IconData? trailingIcon, IconData? checkIcon, Key? key, String? label, List<T> value = const [], ValueChanged<List<T>>? onChanged, List<SelectItem<T>> options = const [], String? placeholder = 'Select…', bool disabled = false, String? helper, String? error, SelectSize size = SelectSize.medium})`. Later tasks (showcase) import this from `package:catalyst_ui/catalyst_ui.dart` via the `molecules.dart` barrel.

- [ ] **Step 1: Create `lib/src/components/molecules/multi_select.dart`**

```dart
import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../theme/shadows.dart';
import '../../theme/typography.dart';
import '../../tokens/radius.dart';
import '../atoms/checkbox.dart';
import 'select.dart';

/// A dropdown field for selecting multiple values from a list of options.
///
/// The [options] list accepts [SelectOption] entries and [SelectDivider]
/// entries, which render as a thin horizontal separator between groups.
/// [SelectOption] entries may include an optional icon displayed to the left
/// of the label in the dropdown rows, and in the trigger when exactly one
/// option is selected.
///
/// Unlike [Select], the dropdown stays open after a selection so users can
/// toggle several options in one session — it closes only when the user
/// taps outside it or taps the trigger again.
///
/// ```dart
/// MultiSelect<String>(
///   label: 'Countries',
///   placeholder: 'Pick countries…',
///   value: _countries,
///   options: const [
///     SelectOption(
///       value: 'gb',
///       label: 'United Kingdom',
///       icon: MyIcons.flagGb,
///     ),
///     SelectOption(value: 'us', label: 'United States'),
///     SelectDivider(),
///     SelectOption(value: 'ca', label: 'Canada'),
///   ],
///   onChanged: (v) => setState(() => _countries = v),
/// )
/// ```
class MultiSelect<T> extends StatefulWidget {
  /// Creates a multi-select field.
  const MultiSelect({
    this.trailingIcon,
    this.checkIcon,
    super.key,
    this.label,
    this.value = const [],
    this.onChanged,
    this.options = const [],
    this.placeholder = 'Select…',
    this.disabled = false,
    this.helper,
    this.error,
    this.size = SelectSize.medium,
  });

  /// An optional label rendered above the trigger.
  final String? label;

  /// The currently selected values.
  final List<T> value;

  /// Called with the full updated selection when the user toggles an option.
  final ValueChanged<List<T>>? onChanged;

  /// The list of items shown in the dropdown.
  ///
  /// May contain [SelectOption] entries and [SelectDivider] entries.
  final List<SelectItem<T>> options;

  /// Placeholder text when no value is selected.
  final String? placeholder;

  /// When `true`, the field is non-interactive.
  final bool disabled;

  /// Helper text below the trigger.
  final String? helper;

  /// When non-null, shows error styling with this message.
  final String? error;

  /// The height variant.
  final SelectSize size;

  /// Icon to display at the end of this [MultiSelect]. Defaults to
  /// `Iconography.expandIcon`.
  final IconData? trailingIcon;

  /// Icon to display on selected options' checkboxes. Defaults to
  /// `Iconography.checkIcon`.
  final IconData? checkIcon;

  @override
  State<MultiSelect<T>> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  OverlayEntry? _overlay;
  final _link = LayerLink();

  bool get _isOpen => _overlay != null;

  double get _triggerHeight => switch (widget.size) {
    SelectSize.small => 44,
    SelectSize.medium => 48,
    SelectSize.large => 52.0,
  };

  void _toggleValue(T value) {
    final next = List<T>.of(widget.value);
    if (!next.remove(value)) {
      next.add(value);
    }
    widget.onChanged?.call(next);
  }

  void _open() {
    final cs = context.colorScheme;
    final typo = context.typography;
    final sh = context.shadows;

    final renderBox = context.findRenderObject()! as RenderBox;
    final triggerGlobal = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    const dropdownMaxHeight = 240.0;
    final spaceBelow = screenHeight - triggerGlobal.dy - _triggerHeight - 4;
    final showAbove = spaceBelow < dropdownMaxHeight;

    _overlay = OverlayEntry(
      builder: (_) => _MultiSelectDropdown<T>(
        layerLink: _link,
        triggerWidth: renderBox.size.width,
        options: widget.options,
        value: widget.value,
        colorScheme: cs,
        typography: typo,
        shadows: sh,
        showAbove: showAbove,
        onToggle: _toggleValue,
        checkIcon: widget.checkIcon ?? context.iconography.checkIcon,
        onDismiss: _close,
      ),
    );
    Overlay.of(context).insert(_overlay!);
    setState(() {});
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() {});
  }

  void _toggle() {
    if (widget.disabled) return;
    _isOpen ? _close() : _open();
  }

  @override
  void didUpdateWidget(MultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The open OverlayEntry's builder closure reads `widget.value` directly;
    // an OverlayEntry only rebuilds when explicitly told to, so without this
    // the checkboxes would not reflect a toggle while the dropdown is open.
    _overlay?.markNeedsBuild();
  }

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;
    final hasError = widget.error != null;

    final selectedOptions = widget.options
        .whereType<SelectOption<T>>()
        .where((o) => widget.value.contains(o.value))
        .toList();

    final Color borderColor;
    final List<BoxShadow> boxShadow;

    if (hasError) {
      borderColor = cs.danger;
      boxShadow = [
        BoxShadow(color: cs.danger.withValues(alpha: 0.18), spreadRadius: 3),
      ];
    } else if (_isOpen) {
      borderColor = cs.brand;
      boxShadow = [
        BoxShadow(color: cs.brand.withValues(alpha: 0.20), spreadRadius: 3),
      ];
    } else {
      borderColor = cs.border;
      boxShadow = [];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typo.p3.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.text,
            ),
          ),
          const SizedBox(height: 6),
        ],
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: _toggle,
            child: MouseRegion(
              cursor: widget.disabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: AnimatedOpacity(
                duration: motion.standard.duration,
                curve: motion.standard.curve,
                opacity: widget.disabled ? 0.5 : 1,
                child: AnimatedContainer(
                  duration: motion.standard.duration,
                  curve: motion.standard.curve,
                  height: _triggerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: widget.disabled ? cs.muted : cs.surface,
                    borderRadius: Radii.lgAll,
                    border: Border.all(color: borderColor),
                    boxShadow: boxShadow,
                  ),
                  child: Row(
                    children: [
                      if (selectedOptions.length == 1 &&
                          selectedOptions.first.icon != null) ...[
                        Icon(
                          selectedOptions.first.icon,
                          size: 18,
                          color: cs.text,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selectedOptions.isNotEmpty
                              ? selectedOptions.map((o) => o.label).join(', ')
                              : widget.placeholder ?? '',
                          style: typo.body.copyWith(
                            color: selectedOptions.isNotEmpty
                                ? cs.text
                                : cs.textSubtle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0,
                        duration: motion.micro.duration,
                        curve: motion.micro.curve,
                        child: Icon(
                          widget.trailingIcon ?? context.iconography.expandIcon,
                          size: 18,
                          color: cs.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.helper != null || hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.error ?? widget.helper!,
            style: typo.caption.copyWith(
              color: hasError ? cs.danger : cs.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class _MultiSelectDropdown<T> extends StatelessWidget {
  const _MultiSelectDropdown({
    required this.layerLink,
    required this.triggerWidth,
    required this.options,
    required this.value,
    required this.colorScheme,
    required this.typography,
    required this.shadows,
    required this.showAbove,
    required this.onToggle,
    required this.onDismiss,
    required this.checkIcon,
  });

  final LayerLink layerLink;
  final double triggerWidth;
  final List<SelectItem<T>> options;
  final List<T> value;
  final ColorScheme colorScheme;
  final Typography typography;
  final Shadows shadows;

  /// Whether the dropdown should open above the trigger.
  final bool showAbove;

  final ValueChanged<T> onToggle;
  final VoidCallback onDismiss;

  final IconData checkIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: showAbove
                ? Alignment.bottomLeft
                : Alignment.topLeft,
            offset: Offset(0, showAbove ? -4 : 4),
            child: SizedBox(
              width: triggerWidth,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: Radii.lgAll,
                  border: Border.all(color: colorScheme.border),
                  boxShadow: shadows.lg,
                ),
                child: ClipRRect(
                  borderRadius: Radii.lgAll,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final item in options)
                          switch (item) {
                            SelectOption<T>() => _MultiSelectOptionRow<T>(
                              option: item,
                              isSelected: value.contains(item.value),
                              onTap: () => onToggle(item.value),
                              colorScheme: colorScheme,
                              typography: typography,
                              checkIcon: checkIcon,
                            ),
                            SelectDivider<T>() => _MultiSelectItemDivider(
                              colorScheme: colorScheme,
                            ),
                          },
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectItemDivider extends StatelessWidget {
  const _MultiSelectItemDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: colorScheme.border);
  }
}

class _MultiSelectOptionRow<T> extends StatefulWidget {
  const _MultiSelectOptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.typography,
    required this.checkIcon,
  });

  final SelectOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final Typography typography;
  final IconData checkIcon;

  @override
  State<_MultiSelectOptionRow<T>> createState() =>
      _MultiSelectOptionRowState<T>();
}

class _MultiSelectOptionRowState<T> extends State<_MultiSelectOptionRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            color: (widget.isSelected || _hovered)
                ? widget.colorScheme.subtle
                : null,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              children: [
                Checkbox(
                  value: widget.isSelected,
                  onChanged: (_) => widget.onTap(),
                  checkIcon: widget.checkIcon,
                  size: CheckboxSize.small,
                ),
                const SizedBox(width: 8),
                if (widget.option.icon != null) ...[
                  Icon(
                    widget.option.icon,
                    size: 16,
                    color: widget.colorScheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.option.label,
                    style: widget.typography.p3.copyWith(
                      color: widget.colorScheme.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Export the new file from the molecules barrel**

In `lib/src/components/molecules/molecules.dart`, insert the export alphabetically between `menu_button.dart` and `pagination.dart`:

```dart
export 'action_tile.dart';
export 'alert.dart';
export 'breadcrumb.dart';
export 'card.dart';
export 'list_item.dart';
export 'menu_button.dart';
export 'multi_select.dart';
export 'pagination.dart';
export 'segmented_control.dart';
export 'select.dart';
export 'snackbar.dart';
export 'stat_card.dart';
export 'stepper.dart';
export 'tabs.dart';
export 'text_field.dart';
export 'tooltip.dart';
export 'value_row.dart';
```

- [ ] **Step 3: Run static analysis**

Run: `dart analyze lib/`
Expected: `No issues found!`

If there are issues, fix them before proceeding — do not suppress lints.

- [ ] **Step 4: Commit**

```bash
git add lib/src/components/molecules/multi_select.dart lib/src/components/molecules/molecules.dart
git commit -m "Add MultiSelect component"
```

---

### Task 2: Add the showcase page and manually verify

**Files:**
- Modify: `example/lib/showcases/molecules.dart:481-483` (insert new showcase between `SelectShowcase`'s closing brace and the `Snackbar` section comment)
- Modify: `example/lib/registry.dart:144-149` (insert new `ComponentEntry` between `Select` and `Snackbar`)

**Interfaces:**
- Consumes: `MultiSelect<T>` from Task 1 (via `package:catalyst_ui/catalyst_ui.dart`); `ShowcasePage`, `BoolControl`, `SelectControl` from `example/lib/widgets/showcase_page.dart` and `example/lib/widgets/controls.dart`; `SelectOption`, `SelectSize` (already exported).
- Produces: `MultiSelectShowcase` widget, registered in `example/lib/registry.dart` as `ComponentEntry(name: 'MultiSelect', ...)`, used only by the example app.

- [ ] **Step 1: Insert the showcase widget**

In `example/lib/showcases/molecules.dart`, insert this block after `SelectShowcase`'s closing `}` (line 481) and before the `// ─── Snackbar ───` comment (line 483):

```dart
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

```

- [ ] **Step 2: Register the showcase entry**

In `example/lib/registry.dart`, insert this entry between the `Select` entry and the `Snackbar` entry:

```dart
  ComponentEntry(
    name: 'Select',
    category: 'Molecules',
    description: 'Dropdown selection field',
    build: () => const SelectShowcase(),
  ),
  ComponentEntry(
    name: 'MultiSelect',
    category: 'Molecules',
    description: 'Multi-value dropdown selection field',
    build: () => const MultiSelectShowcase(),
  ),
  ComponentEntry(
    name: 'Snackbar',
    category: 'Molecules',
    description: 'Transient notification toast',
    build: () => const SnackbarShowcase(),
  ),
```

- [ ] **Step 3: Run static analysis on the example app**

Run: `cd example && dart analyze lib/ && cd ..`
Expected: `No issues found!`

- [ ] **Step 4: Manually verify in the running app**

Run: `cd example && flutter run -d macos` (or `chrome`, whichever device is available)

In the running app:
1. Navigate to Molecules → MultiSelect.
2. Tap the trigger — dropdown opens showing 5 country options with unchecked checkboxes.
3. Tap "United States" — its checkbox becomes checked, the dropdown **stays open**, and the trigger text updates to "United States".
4. Tap "Canada" — trigger text updates to "United States, Canada" (comma-joined, in option order).
5. Tap "United States" again to deselect it — trigger text updates to "Canada" and its checkbox unchecks, dropdown still open.
6. Tap outside the dropdown — it closes.
7. Toggle the "Disabled" control — trigger dims and no longer opens on tap.
8. Toggle "Show error" — trigger border/shadow turn red and the error helper text appears.
9. Cycle through the "Size" control (Small/Medium/Large) — trigger height changes accordingly.

Confirm all of the above behave as described. If anything doesn't match, fix `multi_select.dart` before proceeding.

- [ ] **Step 5: Commit**

```bash
git add example/lib/showcases/molecules.dart example/lib/registry.dart
git commit -m "Add MultiSelect showcase to example app"
```

---

### Task 3: Bump version and changelog

**Files:**
- Modify: `pubspec.yaml:4`
- Modify: `CHANGELOG.md:1`

**Interfaces:**
- Consumes: nothing new.
- Produces: nothing consumed by other tasks — this is the final release-bookkeeping step.

- [ ] **Step 1: Bump the package version**

In `pubspec.yaml`, change:

```yaml
version: 0.3.0
```

to:

```yaml
version: 0.4.0
```

- [ ] **Step 2: Add a changelog entry**

In `CHANGELOG.md`, insert a new entry at the top:

```markdown
# 0.4.0

- Add `MultiSelect`

# 0.3.0
```

(i.e. the new `# 0.4.0` heading and bullet go above the existing `# 0.3.0` heading, which stays as-is with its own content below it.)

- [ ] **Step 3: Run static analysis one final time**

Run: `dart analyze lib/`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to 0.4.0"
```
