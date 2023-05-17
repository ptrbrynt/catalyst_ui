// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:equatable/equatable.dart';

/// {@template button_theme_data}
/// The theme data for Buttons.
/// {@endtemplate}
class ButtonThemeData extends Styleable<ButtonThemeData> with EquatableMixin {
  /// {@macro button_theme_data}
  const ButtonThemeData({
    this.decoration,
    this.height,
    this.padding,
    this.textStyle,
    this.iconPosition = defaultIconPosition,
    super.styles = const {},
  });

  /// The default shape for a button.
  static const defaultShape = BoxShape.rectangle;

  /// The default icon position for a button.
  static const defaultIconPosition = ButtonIconPosition.left;

  /// The decoration of the buttons.
  final ButtonStatefulProperty<BoxDecoration>? decoration;

  /// The fixed height of the buttons
  final double? height;

  /// The padding of the buttons.
  final ButtonStatefulProperty<EdgeInsetsGeometry>? padding;

  /// The text style of the buttons.
  final ButtonStatefulProperty<TextStyle>? textStyle;

  /// The icon position of the buttons.
  final ButtonIconPosition iconPosition;

  @override
  List<Object?> get props => [
        decoration,
        height,
        padding,
        textStyle,
        iconPosition,
        styles,
      ];

  ButtonThemeData copyWith({
    ButtonStatefulProperty<BoxDecoration>? decoration,
    double? height,
    ButtonStatefulProperty<EdgeInsetsGeometry>? padding,
    ButtonStatefulProperty<TextStyle>? textStyle,
    ButtonIconPosition? iconPosition,
  }) {
    return ButtonThemeData(
      decoration: decoration ?? this.decoration,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      iconPosition: iconPosition ?? this.iconPosition,
    );
  }
}

/// A property which reacts to the state of a button.
typedef ButtonStatefulProperty<T> = T? Function(ButtonState state);

/// Possible states for a button.
enum ButtonState {
  /// The button is enabled and idle
  enabled,

  /// The button is being hovered over
  hover,

  /// The button is disabled
  disabled,

  /// The button is currently being pressed
  pressed,
}
