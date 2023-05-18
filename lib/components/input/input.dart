import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';

/// {@template input}
/// An input field.
/// {@endtemplate}
class Input extends StyleableStatefulWidget {
  /// {@macro input}
  const Input({
    required this.editableText,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    super.styles = const [],
    super.key,
  });

  /// The [InputDecoration] for the Input.
  final InputDecoration decoration;

  /// Whether the Input is enabled.
  final bool enabled;

  /// The [EditableText] widget to display within the [Input]
  final EditableText editableText;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late InputState _inputState;

  late bool _showPlaceholder;

  TextEditingController get controller => widget.editableText.controller;

  FocusNode get focusNode => widget.editableText.focusNode;

  @override
  void initState() {
    super.initState();
    _updateInputState();
    _showPlaceholder = controller.text.isEmpty;
    focusNode.addListener(_updateInputState);
    controller.addListener(_onControllerUpdated);
  }

  void _updateInputState() {
    setState(() {
      if (widget.decoration.errorText != null) {
        _inputState = InputState.error;
      } else if (!widget.enabled) {
        _inputState = InputState.disabled;
      } else if (focusNode.hasFocus) {
        _inputState = InputState.focused;
      } else {
        _inputState = InputState.enabled;
      }
    });
  }

  void _onControllerUpdated() {
    setState(() {
      _showPlaceholder = controller.text.isEmpty;
    });
  }

  @override
  void didUpdateWidget(Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateInputState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CatalystTheme.of(context)
        ?.data
        .inputDecorationThemeData
        .forStyles(widget.styles);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label(theme),
            _hint(theme),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          decoration: theme?.boxDecoration?.call(_inputState),
          padding: theme?.contentPadding.call(_inputState),
          child: Row(
            children: [
              if (widget.decoration.leadingIcon != null) _leadingIcon(theme),
              if (widget.decoration.leadingAddOn != null) _leadingAddOn(theme),
              Expanded(child: _field(theme, context)),
              if (widget.decoration.trailingAddOn != null)
                _trailingAddOn(theme),
              if (widget.decoration.trailingIcon != null) _trailingIcon(theme),
            ],
          ),
        ),
        if (widget.decoration.errorText != null)
          _error(theme)
        else
          _help(theme),
      ],
    );
  }

  IconTheme _leadingIcon(InputDecorationThemeData? theme) {
    return IconTheme(
      data: theme?.leadingIconTheme.call(_inputState) ??
          InputDecorationThemeData.defaultLeadingIconTheme(
            _inputState,
          ),
      child: Padding(
        padding: theme?.leadingIconPadding.call(_inputState) ??
            InputDecorationThemeData.defaultLeadingIconPadding(
              _inputState,
            ),
        child: widget.decoration.leadingIcon,
      ),
    );
  }

  IconTheme _trailingIcon(InputDecorationThemeData? theme) {
    return IconTheme(
      data: theme?.trailingIconTheme.call(_inputState) ??
          InputDecorationThemeData.defaultTrailingIconTheme(
            _inputState,
          ),
      child: Padding(
        padding: theme?.trailingIconPadding.call(_inputState) ??
            InputDecorationThemeData.defaultTrailingIconPadding(
              _inputState,
            ),
        child: widget.decoration.trailingIcon,
      ),
    );
  }

  Padding _help(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.helpPadding.call(_inputState) ??
          InputDecorationThemeData.defaultHelpPadding(_inputState),
      child: Text(
        widget.decoration.helpText ?? '',
        style: theme?.helpStyle?.call(_inputState),
      ),
    );
  }

  Padding _error(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.errorPadding.call(_inputState) ??
          InputDecorationThemeData.defaultErrorPadding(_inputState),
      child: Text(
        widget.decoration.errorText ?? '',
        style: theme?.errorStyle?.call(_inputState),
      ),
    );
  }

  Padding _trailingAddOn(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.trailingAddOnPadding.call(_inputState) ??
          InputDecorationThemeData.defaultTrailingAddOnPadding(
            _inputState,
          ),
      child: Text(
        widget.decoration.trailingAddOn ?? '',
        style: theme?.trailingAddOnStyle?.call(_inputState),
      ),
    );
  }

  Widget _field(InputDecorationThemeData? theme, BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _showPlaceholder ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Text(
            widget.decoration.placeholderText ?? '',
            style: theme?.placeholderStyle?.call(_inputState),
          ),
        ),
        widget.editableText,
      ],
    );
  }

  Padding _leadingAddOn(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.leadingAddOnPadding.call(_inputState) ??
          InputDecorationThemeData.defaultLeadingAddOnPadding(
            _inputState,
          ),
      child: Text(
        widget.decoration.leadingAddOn ?? '',
        style: theme?.leadingAddOnStyle?.call(_inputState),
      ),
    );
  }

  Padding _hint(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.hintPadding.call(_inputState) ??
          InputDecorationThemeData.defaultHintPadding(_inputState),
      child: Text(
        widget.decoration.hintText ?? '',
        style: theme?.hintStyle?.call(_inputState),
      ),
    );
  }

  Padding _label(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.labelPadding.call(_inputState) ??
          InputDecorationThemeData.defaultLabelPadding(_inputState),
      child: Text(
        widget.decoration.labelText ?? '',
        style: theme?.labelStyle?.call(_inputState),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(_updateInputState);
    controller.removeListener(_onControllerUpdated);
    super.dispose();
  }
}
