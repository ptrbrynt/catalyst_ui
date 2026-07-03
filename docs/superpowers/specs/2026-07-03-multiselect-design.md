# MultiSelect component design

## Purpose

Add a `MultiSelect<T>` molecule that lets users pick multiple values from a
dropdown list, matching the visual style and interaction model of the
existing `Select<T>` component but supporting a list of selected values
instead of a single one.

## Location

`lib/src/components/molecules/multi_select.dart`, exported from
`lib/src/components/molecules/molecules.dart`.

## Reused types

To avoid duplicating structurally identical types, `MultiSelect` reuses
existing declarations from `select.dart` rather than introducing parallel
ones:

- `SelectItem<T>` / `SelectOption<T>` / `SelectDivider<T>` — the `options`
  list is exactly the same shape as `Select`'s (same optional per-option
  icon, same divider support).
- `SelectSize` — the same three trigger heights (`small` 44px, `medium`
  48px, `large` 52px) apply to `MultiSelect`'s trigger.

## Public API

```dart
class MultiSelect<T> extends StatefulWidget {
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

  final String? label;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final List<SelectItem<T>> options;
  final String? placeholder;
  final bool disabled;
  final String? helper;
  final String? error;
  final SelectSize size;
  final IconData? trailingIcon;
  final IconData? checkIcon;
}
```

`onChanged` is called with the **full updated selection list** each time an
option is toggled on or off — not a single delta value. This mirrors how a
caller manages the value with `setState`, e.g.:

```dart
MultiSelect<String>(
  label: 'Countries',
  value: _countries,
  options: const [
    SelectOption(value: 'gb', label: 'United Kingdom', icon: MyIcons.flagGb),
    SelectOption(value: 'us', label: 'United States'),
    SelectDivider(),
    SelectOption(value: 'ca', label: 'Canada'),
  ],
  onChanged: (v) => setState(() => _countries = v),
)
```

## Trigger

Visually identical chrome to `Select`'s trigger: same border/shadow/error/
focus states, same `AnimatedContainer`/`AnimatedOpacity` treatment for
disabled state, same rotating trailing icon (`expandIcon` default) driven by
open/closed state.

Content differs in how it summarizes the selection:

- **Text**: labels of all selected options, in `options` order (not
  selection order), joined with `", "`. Falls back to `placeholder` when
  none are selected. Single line, ellipsis-truncated — same
  `maxLines: 1` / `TextOverflow.ellipsis` treatment as `Select`.
- **Leading icon**: shown only when exactly one option is selected, using
  that option's `icon`. With zero or multiple selections there is no single
  representative icon, so none is shown.

## Dropdown

Same overlay mechanics as `Select`'s `_SelectDropdown`: `CompositedTransformFollower`
anchored to the trigger via `LayerLink`, flips above/below based on available
screen space, dismiss-on-outside-tap via a translucent full-screen
`GestureDetector`, same `Container` chrome (surface color, border, `shadows.lg`,
`Radii.lgAll`), same divider rendering for `SelectDivider` items.

Row rendering differs from `Select`'s `_SelectOptionRow`:

- A `Checkbox` atom (size `small`, 16px) is rendered at the leading edge of
  the row, before the option's icon (if any) and label. It reflects
  `isSelected` and is purely presentational within the row — the row's own
  `GestureDetector` drives the toggle, not the checkbox's own tap handling.
- The row's `checkIcon` (used inside the `Checkbox`) comes from
  `MultiSelect.checkIcon ?? context.iconography.checkIcon`, matching how
  `Select` and `Checkbox` already resolve their check icon.
- Tapping a row **toggles** that option's value in the `List<T>` and calls
  `onChanged` with the new list. Unlike `Select`, the dropdown does **not**
  close after a selection — it stays open so the user can toggle several
  options in one session. It only closes via the outside-tap dismiss handler
  or by tapping the trigger again (existing `_toggle` behavior, reused
  as-is).
- Hover/selected background highlight (`colorScheme.subtle`) behaves the
  same as `Select`'s rows.

## Error handling

No new error states beyond what `Select` already has (`error` string prop
drives red border/shadow/helper text). No validation of `value` against
`options` is performed — a `value` entry with no matching `SelectOption` is
silently not shown as selected in the trigger or dropdown, consistent with
how `Select` behaves today when `value` doesn't match any option.

## Testing / verification

This library has no per-component widget test suite — components are
verified via `dart analyze lib/`, which must report `No issues found!` and
enforces `public_member_api_docs` on every new public symbol. This is the
same verification bar `Select` was built and merged under.

## Out of scope (YAGNI)

- A "clear all" affordance on the trigger — deselecting happens via the
  dropdown only, matching the decision made during design.
- Select-all / search-filter within the dropdown — not requested.
- A dedicated `MultiSelectItem`/`MultiSelectSize` type — reusing `Select`'s
  existing types avoids duplication since the shapes are identical.
