import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:equatable/equatable.dart';

/// {@template dropdown_theme_data}
/// Defines the theme data for a Dropdown.
/// {@endtemplate}
@immutable
class DropdownThemeData extends Styleable<DropdownThemeData>
    with EquatableMixin {
  /// {@macro dropdown_theme_data}
  const DropdownThemeData({
    this.popupDecoration,
    this.dropdownItemBuilder = defaultDropdownItemBuilder,
    this.maxDropdownWidth = defaultMaxDropdownWidth,
    super.styles = const {},
  });

  /// The decoration of the dropdown popup.
  final Decoration? popupDecoration;

  /// The builder for the dropdown items.
  final Widget Function(BuildContext, String) dropdownItemBuilder;

  /// The maximum width of the dropdown popup.
  final double maxDropdownWidth;

  /// The default [dropdownItemBuilder].
  static Widget defaultDropdownItemBuilder(
    BuildContext context,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(label),
    );
  }

  /// The default [maxDropdownWidth].
  static const double defaultMaxDropdownWidth = 200;

  @override
  List<Object?> get props => [
        popupDecoration,
        dropdownItemBuilder,
        maxDropdownWidth,
        styles,
      ];
}
