import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:equatable/equatable.dart';

/// {@template input_decoration_theme}
/// Defines the visual properties of Inputs.
/// {@endtemplate}
@immutable
class InputDecorationThemeData extends Styleable<InputDecorationThemeData>
    with EquatableMixin {
  /// {@macro input_decoration_theme}
  const InputDecorationThemeData({
    this.textStyle,
    this.labelStyle,
    this.placeholderStyle,
    this.hintStyle,
    this.errorStyle,
    this.helpStyle,
    this.leadingAddOnStyle,
    this.trailingAddOnStyle,
    this.boxDecoration,
    this.contentPadding = defaultContentPadding,
    this.labelPadding = defaultLabelPadding,
    this.helpPadding = defaultHelpPadding,
    this.hintPadding = defaultHintPadding,
    this.errorPadding = defaultErrorPadding,
    this.leadingAddOnPadding = defaultLeadingAddOnPadding,
    this.trailingAddOnPadding = defaultTrailingAddOnPadding,
    this.leadingIconPadding = defaultLeadingIconPadding,
    this.trailingIconPadding = defaultTrailingIconPadding,
    this.leadingIconTheme = defaultLeadingIconTheme,
    this.trailingIconTheme = defaultTrailingIconTheme,
    this.cursorColor = defaultCursorColor,
    this.backgroundCursorColor = defaultBackgroundCursorColor,
    super.styles = const {},
  });

  /// The default content padding
  static EdgeInsets defaultContentPadding(Set<InputState> _) =>
      const EdgeInsets.fromLTRB(12, 8, 12, 8);

  /// The default label padding
  static EdgeInsets defaultLabelPadding(Set<InputState> _) =>
      const EdgeInsets.only(bottom: 8);

  /// The default help padding
  static EdgeInsets defaultHelpPadding(Set<InputState> _) =>
      const EdgeInsets.only(top: 8);

  /// The default hint padding
  static EdgeInsets defaultHintPadding(Set<InputState> _) =>
      const EdgeInsets.only(bottom: 8);

  /// The default error padding
  static EdgeInsets defaultErrorPadding(Set<InputState> _) =>
      const EdgeInsets.only(top: 8);

  /// The default leading add on padding
  static EdgeInsets defaultLeadingAddOnPadding(Set<InputState> _) =>
      const EdgeInsets.only(right: 4);

  /// The default trailing add on padding
  static EdgeInsets defaultTrailingAddOnPadding(Set<InputState> _) =>
      const EdgeInsets.only(left: 4);

  /// The default leading icon padding
  static EdgeInsets defaultLeadingIconPadding(Set<InputState> _) =>
      const EdgeInsets.only(right: 4);

  /// The default trailing icon padding
  static EdgeInsets defaultTrailingIconPadding(Set<InputState> _) =>
      const EdgeInsets.only(left: 4);

  /// The default leading icon theme
  static IconThemeData defaultLeadingIconTheme(Set<InputState> _) =>
      const IconThemeData();

  /// The default trailing icon theme
  static IconThemeData defaultTrailingIconTheme(Set<InputState> _) =>
      const IconThemeData();

  /// The default cursor color
  static Color defaultCursorColor(Set<InputState> _) => const Color(0x80808080);

  /// The default background cursor color
  static Color defaultBackgroundCursorColor(Set<InputState> _) =>
      const Color.fromARGB(100, 0, 0, 0);

  /// The text style of the input content
  final InputStatefulProperty<TextStyle>? textStyle;

  /// The text style of the input label
  final InputStatefulProperty<TextStyle>? labelStyle;

  /// The text style of the input placeholder
  final InputStatefulProperty<TextStyle>? placeholderStyle;

  /// The text style of the input hint
  final InputStatefulProperty<TextStyle>? hintStyle;

  /// The text style of the input error
  final InputStatefulProperty<TextStyle>? errorStyle;

  /// The text style of the input help text
  final InputStatefulProperty<TextStyle>? helpStyle;

  /// The text style of the input leading add-on
  final InputStatefulProperty<TextStyle>? leadingAddOnStyle;

  /// The text style of the input trailing add-on
  final InputStatefulProperty<TextStyle>? trailingAddOnStyle;

  /// The decoration of the input
  final InputStatefulProperty<BoxDecoration>? boxDecoration;

  /// The padding of the input content
  final InputStatefulProperty<EdgeInsets> contentPadding;

  /// The padding of the input label
  final InputStatefulProperty<EdgeInsets> labelPadding;

  /// The padding of the input help text
  final InputStatefulProperty<EdgeInsets> helpPadding;

  /// The padding of the input hint
  final InputStatefulProperty<EdgeInsets> hintPadding;

  /// The padding of the input error
  final InputStatefulProperty<EdgeInsets> errorPadding;

  /// The padding of the input leading add-on
  final InputStatefulProperty<EdgeInsets> leadingAddOnPadding;

  /// The padding of the input trailing add-on
  final InputStatefulProperty<EdgeInsets> trailingAddOnPadding;

  /// The padding of the input leading icon
  final InputStatefulProperty<EdgeInsets> leadingIconPadding;

  /// The padding of the input trailing icon
  final InputStatefulProperty<EdgeInsets> trailingIconPadding;

  /// The icon theme of the input leading icon
  final InputStatefulProperty<IconThemeData> leadingIconTheme;

  /// The icon theme of the input trailing icon
  final InputStatefulProperty<IconThemeData> trailingIconTheme;

  /// The cursor color of the input
  final InputStatefulProperty<Color?> cursorColor;

  /// The background cursor color of the input
  final InputStatefulProperty<Color?> backgroundCursorColor;

  @override
  List<Object?> get props => [
        textStyle,
        labelStyle,
        placeholderStyle,
        hintStyle,
        errorStyle,
        helpStyle,
        leadingAddOnStyle,
        trailingAddOnStyle,
        boxDecoration,
        contentPadding,
        labelPadding,
        helpPadding,
        hintPadding,
        errorPadding,
        leadingAddOnPadding,
        trailingAddOnPadding,
        leadingIconPadding,
        trailingIconPadding,
        leadingIconTheme,
        trailingIconTheme,
        cursorColor,
        backgroundCursorColor,
      ];
}

/// A property which reacts to the state of an Input.
typedef InputStatefulProperty<T> = T? Function(Set<InputState> state);

/// Possible states for Inputs
enum InputState {
  /// The default state of the Input
  enabled,

  /// The state of the Input when it is focused
  focused,

  /// The state of the Input when it has a validation error
  error,

  /// The state of the Input when it is disabled
  disabled,
}
