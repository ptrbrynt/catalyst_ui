import 'dart:ui' as ui;

import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// {@template input}
/// An input field.
/// {@endtemplate}
class Input extends StyleableStatefulWidget {
  /// {@macro input}
  Input({
    this.autocorrect = true,
    this.autofocus = false,
    this.autofillHints,
    this.canRequestFocus = true,
    this.clipBehavior = Clip.none,
    this.contentInsertionConfiguration,
    TextEditingController? controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.expands = false,
    FocusNode? focusNode,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType = TextInputType.text,
    this.enableIMEPersonalizedLearning = true,
    this.enableSuggestions = true,
    this.magnifierConfiguration,
    this.maxLines = 1,
    this.minLines,
    this.mouseCursor,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.onAppPrivateCommand,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20),
    this.scrollPhysics,
    this.onTapOutside,
    this.restorationId,
    this.scribbleEnabled = true,
    this.selectionControls,
    this.showCursor,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.textInputAction,
    this.undoController,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    super.styles = const [],
    super.key,
  })  : controller = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled);

  /// The [InputDecoration] for the Input.
  final InputDecoration decoration;

  /// Whether the Input is enabled.
  final bool enabled;

  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.intro}
  ///
  /// {@macro flutter.widgets.magnifier.intro}
  ///
  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.details}
  ///
  /// By default, builds a [CupertinoTextMagnifier] on iOS and [TextMagnifier]
  /// on Android, and builds nothing on all other platforms. If it is desired to
  /// suppress the magnifier, consider passing [TextMagnifierConfiguration.disabled].
  ///
  /// {@tool dartpad}
  /// This sample demonstrates how to customize the magnifier that this text field uses.
  ///
  /// ** See code in examples/api/lib/widgets/text_magnifier/text_magnifier.0.dart **
  /// {@end-tool}
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// myFocusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field. The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode focusNode;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.TextInputConfiguration.smartDashesType}
  final SmartDashesType smartDashesType;

  /// {@macro flutter.services.TextInputConfiguration.smartQuotesType}
  final SmartQuotesType smartQuotesType;

  /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.onAppPrivateCommand}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// {@template flutter.material.textfield.onTap}
  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  /// {@endtemplate}
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.onTapOutside}
  ///
  /// {@tool dartpad}
  /// This example shows how to use a `TextFieldTapRegion` to wrap a set of
  /// "spinner" buttons that increment and decrement a value in the [TextField]
  /// without causing the text field to lose keyboard focus.
  ///
  /// This example includes a generic `SpinnerField<T>` class that you can copy
  /// into your own project and customize.
  ///
  /// ** See code in examples/api/lib/widgets/tap_region/text_field_tap_region.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [TapRegion] for how the region group is determined.
  final TapRegionCallback? onTapOutside;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  final MouseCursor? mouseCursor;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@template flutter.material.textfield.restorationId}
  /// Restoration ID to save and restore the state of the text field.
  ///
  /// If non-null, the text field will persist and restore its current scroll
  /// offset and - if no [controller] has been provided - the content of the
  /// text field. If a [controller] has been provided, it is the responsibility
  /// of the owner of that controller to persist and restore it, e.g. by using
  /// a [RestorableTextEditingController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  /// {@endtemplate}
  final String? restorationId;

  /// {@macro flutter.widgets.editableText.scribbleEnabled}
  final bool scribbleEnabled;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  final bool enableIMEPersonalizedLearning;

  /// {@macro flutter.widgets.editableText.contentInsertionConfiguration}
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  ///
  /// If not provided, will build a default menu based on the platform.

  /// Determine whether this text field can request the primary focus.
  ///
  /// Defaults to true. If false, the text field will not request focus
  /// when tapped, or when its context menu is displayed. If false it will not
  /// be possible to move the focus to the text field with tab key.
  final bool canRequestFocus;

  /// {@macro flutter.widgets.undoHistory.controller}
  final UndoHistoryController? undoController;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late InputState _inputState;

  late bool _showPlaceholder;

  @override
  void initState() {
    super.initState();
    _updateInputState();
    _showPlaceholder = widget.controller.text.isEmpty;
    widget.focusNode.addListener(_updateInputState);
    widget.controller.addListener(_onControllerUpdated);
  }

  void _updateInputState() {
    setState(() {
      if (widget.decoration.errorText != null) {
        _inputState = InputState.error;
      } else if (!widget.enabled) {
        _inputState = InputState.disabled;
      } else if (widget.focusNode.hasFocus) {
        _inputState = InputState.focused;
      } else {
        _inputState = InputState.enabled;
      }
    });
  }

  void _onControllerUpdated() {
    setState(() {
      _showPlaceholder = widget.controller.text.isEmpty;
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
        EditableText(
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          autofillHints: widget.autofillHints,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          textDirection: widget.textDirection,
          selectionControls: widget.selectionControls,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          clipBehavior: widget.clipBehavior,
          inputFormatters: widget.inputFormatters,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          dragStartBehavior: widget.dragStartBehavior,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          scribbleEnabled: widget.scribbleEnabled,
          keyboardAppearance: widget.keyboardAppearance ?? Brightness.light,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          magnifierConfiguration: widget.magnifierConfiguration ??
              TextMagnifierConfiguration.disabled,
          onTapOutside: widget.onTapOutside,
          showCursor: widget.showCursor,
          strutStyle: widget.strutStyle,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          undoController: widget.undoController,
          mouseCursor: widget.mouseCursor ??
              (widget.enabled
                  ? SystemMouseCursors.text
                  : SystemMouseCursors.forbidden),
          readOnly: !widget.enabled,
          cursorRadius: const Radius.circular(1),
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: theme?.textStyle?.call(_inputState) ??
              DefaultTextStyle.of(context).style,
          cursorColor: theme?.cursorColor.call(_inputState) ??
              InputDecorationThemeData.defaultCursorColor(
                _inputState,
              ),
          backgroundCursorColor:
              theme?.backgroundCursorColor.call(_inputState) ??
                  InputDecorationThemeData.defaultBackgroundCursorColor(
                    _inputState,
                  ),
          enableInteractiveSelection: true,
        ),
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
    widget.focusNode.removeListener(_updateInputState);
    widget.controller.removeListener(_onControllerUpdated);
    super.dispose();
  }
}
