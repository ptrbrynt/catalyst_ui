import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';

/// {@template input}
/// An input field.
///
/// Can contain any [Widget] as its child, but is designed to work with:
/// * [EditableText]s
/// * [Dropdown]s
/// {@endtemplate}
class Input extends StyleableStatefulWidget {
  /// {@macro input}
  const Input({
    required this.child,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    super.styles = const [],
    super.key,
  });

  /// The [InputDecoration] for the Input.
  final InputDecoration decoration;

  /// Whether the Input is enabled.
  final bool enabled;

  /// The widget to display within the [Input].
  ///
  /// If it's an [EditableText], the [Input] will react according to the state
  /// of the [EditableText]
  final Widget child;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _inputStates = <InputState>{};

  late bool _showPlaceholder;

  EditableText? get _editableText =>
      widget.child is EditableText ? widget.child as EditableText : null;

  TextEditingController? get controller => _editableText?.controller;

  FocusNode? get focusNode => _editableText?.focusNode;

  @override
  void initState() {
    super.initState();
    _updateInputState();
    _showPlaceholder = controller?.text.isEmpty ?? true;
    focusNode?.addListener(_updateInputState);
    controller?.addListener(_onControllerUpdated);
  }

  void _updateInputState() {
    final newState = <InputState>{};
    if (widget.decoration.errorText != null) {
      newState.add(InputState.error);
    }
    if (!widget.enabled) {
      newState.add(InputState.disabled);
    } else {
      newState.add(InputState.enabled);
    }
    if (focusNode?.hasFocus ?? false) {
      newState.add(InputState.focused);
    }
    setState(() {
      _inputStates
        ..clear()
        ..addAll(newState);
    });
  }

  void _onControllerUpdated() {
    setState(() {
      _showPlaceholder = controller?.text.isEmpty ?? true;
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
          decoration: theme?.boxDecoration?.call(_inputStates),
          padding: theme?.contentPadding.call(_inputStates),
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
      data: theme?.leadingIconTheme.call(_inputStates) ??
          InputDecorationThemeData.defaultLeadingIconTheme(
            _inputStates,
          ),
      child: Padding(
        padding: theme?.leadingIconPadding.call(_inputStates) ??
            InputDecorationThemeData.defaultLeadingIconPadding(
              _inputStates,
            ),
        child: widget.decoration.leadingIcon,
      ),
    );
  }

  IconTheme _trailingIcon(InputDecorationThemeData? theme) {
    return IconTheme(
      data: theme?.trailingIconTheme.call(_inputStates) ??
          InputDecorationThemeData.defaultTrailingIconTheme(
            _inputStates,
          ),
      child: Padding(
        padding: theme?.trailingIconPadding.call(_inputStates) ??
            InputDecorationThemeData.defaultTrailingIconPadding(
              _inputStates,
            ),
        child: widget.decoration.trailingIcon,
      ),
    );
  }

  Padding _help(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.helpPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultHelpPadding(_inputStates),
      child: Text(
        widget.decoration.helpText ?? '',
        style: theme?.helpStyle?.call(_inputStates),
      ),
    );
  }

  Padding _error(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.errorPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultErrorPadding(_inputStates),
      child: Text(
        widget.decoration.errorText ?? '',
        style: theme?.errorStyle?.call(_inputStates),
      ),
    );
  }

  Padding _trailingAddOn(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.trailingAddOnPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultTrailingAddOnPadding(
            _inputStates,
          ),
      child: Text(
        widget.decoration.trailingAddOn ?? '',
        style: theme?.trailingAddOnStyle?.call(_inputStates),
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
            style: theme?.placeholderStyle?.call(_inputStates),
          ),
        ),
        widget.child,
      ],
    );
  }

  Padding _leadingAddOn(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.leadingAddOnPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultLeadingAddOnPadding(
            _inputStates,
          ),
      child: Text(
        widget.decoration.leadingAddOn ?? '',
        style: theme?.leadingAddOnStyle?.call(_inputStates),
      ),
    );
  }

  Padding _hint(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.hintPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultHintPadding(_inputStates),
      child: Text(
        widget.decoration.hintText ?? '',
        style: theme?.hintStyle?.call(_inputStates),
      ),
    );
  }

  Padding _label(InputDecorationThemeData? theme) {
    return Padding(
      padding: theme?.labelPadding.call(_inputStates) ??
          InputDecorationThemeData.defaultLabelPadding(_inputStates),
      child: Text(
        widget.decoration.labelText ?? '',
        style: theme?.labelStyle?.call(_inputStates),
      ),
    );
  }

  @override
  void dispose() {
    focusNode?.removeListener(_updateInputState);
    controller?.removeListener(_onControllerUpdated);
    super.dispose();
  }
}
