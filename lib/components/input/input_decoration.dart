import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:equatable/equatable.dart';

export 'package:catalyst_ui/components/input/input_decoration.dart';
export 'package:catalyst_ui/components/input/input_decoration_theme.dart';

/// {@template input_decoration}
/// Decorates an Input.
/// {@endtemplate}
@immutable
class InputDecoration with EquatableMixin {
  /// {@macro input_decoration}
  const InputDecoration({
    this.labelText,
    this.placeholderText,
    this.hintText,
    this.helpText,
    this.errorText,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingAddOn,
    this.trailingAddOn,
  });

  /// The text to display as the label of the Input.
  ///
  /// Labels are displayed above the text field
  final String? labelText;

  /// The text to display as the placeholder of the Input.
  ///
  /// Placeholders are displayed inside the text field when the field is empty
  final String? placeholderText;

  /// The text to display as the hint of the Input.
  ///
  /// Hints are displayed to the top-right of the text field
  final String? hintText;

  /// The text to display as the help of the Input.
  ///
  /// Help text is displayed below the input when [errorText] is `null`
  final String? helpText;

  /// The text to display as the error of the Input.
  ///
  /// Error text is displayed below the input.
  final String? errorText;

  /// The icon to display to the left of the Input.
  final Widget? leadingIcon;

  /// The icon to display to the right of the Input.
  final Widget? trailingIcon;

  /// The text to display to the left of the Input.
  final String? leadingAddOn;

  /// The text to display to the right of the Input.
  final String? trailingAddOn;

  @override
  List<Object?> get props => [
        labelText,
        placeholderText,
        hintText,
        helpText,
        errorText,
        leadingIcon,
        trailingIcon,
        leadingAddOn,
        trailingAddOn,
      ];
}
