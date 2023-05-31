import 'package:catalyst_ui/components/dropdown/dropdown_theme_data.dart';
import 'package:catalyst_ui/components/theme/catalyst_theme.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';
import 'package:flutter/material.dart';

export 'dropdown_theme_data.dart';

/// {@template dropdown}
/// A dropdown widget.
/// {@endtemplate}
///
/// TODO: Animate the dropdown
class Dropdown<T> extends StyleableStatefulWidget {
  /// {@macro dropdown}
  const Dropdown({
    required this.items,
    required this.itemLabelBuilder,
    super.key,
    super.styles = const [],
    this.value,
    this.onChanged,
  });

  /// The items to show in the Dropdown
  final List<T> items;

  /// The currently selected value
  final T? value;

  /// The callback when a new option is selected
  final ValueChanged<T?>? onChanged;

  /// Function to translate the item to a label
  final String Function(T) itemLabelBuilder;

  @override
  State<StatefulWidget> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  final _buttonKey = GlobalKey();
  final _portalController = OverlayPortalController();

  String _formatItem(T item) {
    return widget.itemLabelBuilder.call(item);
  }

  Offset? get _buttonPosition {
    final box = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final theme = CatalystTheme.of(context)?.data.dropdownThemeData;
    final itemBuilder = theme?.dropdownItemBuilder ??
        DropdownThemeData.defaultDropdownItemBuilder;

    return OverlayPortal(
      overlayChildBuilder: (context) {
        final position = _buttonPosition;
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                setState(_portalController.hide);
              },
              child: const ColoredBox(color: Color(0x00000000)),
            ),
            Positioned(
              left: position?.dx,
              top: position?.dy,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: theme?.maxDropdownWidth ??
                      DropdownThemeData.defaultMaxDropdownWidth,
                ),
                decoration: theme?.popupDecoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in widget.items)
                      GestureDetector(
                        onTap: () {
                          widget.onChanged?.call(item);
                          setState(_portalController.hide);
                        },
                        child: itemBuilder(context, _formatItem(item)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      controller: _portalController,
      child: GestureDetector(
        key: _buttonKey,
        onTap: () => setState(_portalController.toggle),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null ? _formatItem(value) : '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
