import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Controls the height of a [TextField].
enum TextFieldSize {
  /// 40 px tall input.
  small,

  /// 48 px tall input (default).
  medium,

  /// 56 px tall input.
  large,
}

/// A styled single- or multi-line text input field.
///
/// Supports labels, placeholder text, helper/error messages, and leading and
/// trailing widgets. Either [controller] or [initialValue] may be provided,
/// not both.
class TextField extends StatefulWidget {
  /// Creates a text field.
  const TextField({
    super.key,
    this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.helper,
    this.error,
    this.leading,
    this.trailing,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.size = TextFieldSize.medium,
    this.focusNode,
    this.textInputAction,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints = const [],
  }) : assert(
         controller == null || initialValue == null,
         'Cannot provide both a controller and an initialValue.',
       );

  /// An optional label rendered above the input.
  final String? label;

  /// An optional controller for reading and writing text programmatically.
  final TextEditingController? controller;

  /// Initial text when no [controller] is provided.
  final String? initialValue;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing
  /// the text in the field.
  final void Function(String)? onSubmitted;

  /// Hint text shown when the field is empty.
  final String? placeholder;

  /// Helper text shown below the field in the default (non-error) state.
  final String? helper;

  /// When non-null, shows error styling with this message below the field.
  final String? error;

  /// An optional widget at the leading edge (e.g. an icon).
  final Widget? leading;

  /// An optional widget at the trailing edge (e.g. a clear button).
  final Widget? trailing;

  /// The keyboard type to use on mobile.
  final TextInputType? keyboardType;

  /// Whether to obscure the text (e.g. for passwords).
  final bool obscureText;

  /// Whether the field accepts input.
  final bool enabled;

  /// When `true`, text is visible but not editable.
  final bool readOnly;

  /// When `true`, appends a red asterisk to [label].
  final bool required;

  /// The height variant.
  final TextFieldSize size;

  /// An optional focus node for programmatic focus control.
  final FocusNode? focusNode;

  /// The action button shown on the software keyboard.
  final TextInputAction? textInputAction;

  /// Whether autocorrect is enabled.
  final bool autocorrect;

  /// Smart dashes behaviour on iOS.
  final SmartDashesType? smartDashesType;

  /// Smart quotes behaviour on iOS.
  final SmartQuotesType? smartQuotesType;

  /// Maximum number of lines. Pass `null` for unlimited.
  final int? maxLines;

  /// Minimum number of lines for a multi-line field.
  final int? minLines;

  /// When `true`, the field expands to fill its parent.
  final bool expands;

  /// Whether to auto-focus on first build.
  final bool autofocus;

  /// Controls platform keyboard capitalisation.
  final TextCapitalization textCapitalization;

  /// Input formatters applied on each change.
  final List<TextInputFormatter>? inputFormatters;

  /// Autofill hints passed to the platform autofill service.
  final Iterable<String>? autofillHints;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _isFocused = false;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: widget.initialValue ?? '',
      ));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _onFocusChange,
      );
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _internalFocusNode?.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;
    final errored = widget.error != null;

    final height = switch (widget.size) {
      TextFieldSize.small => Spacing.s10,
      TextFieldSize.medium => Spacing.s12,
      TextFieldSize.large => 56.0,
    };

    final Color borderColor;
    final List<BoxShadow> boxShadow;

    if (errored) {
      borderColor = cs.danger;
      boxShadow = [
        BoxShadow(
          color: cs.danger.withValues(alpha: 0.18),
          spreadRadius: 3,
        ),
      ];
    } else if (_isFocused) {
      borderColor = cs.brand;
      boxShadow = [
        BoxShadow(
          color: cs.brand.withValues(alpha: 0.20),
          spreadRadius: 3,
        ),
      ];
    } else {
      borderColor = cs.border;
      boxShadow = [];
    }

    return AnimatedSize(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text.rich(
              TextSpan(
                text: widget.label,
                style: typo.p3.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.text,
                ),
                children: widget.required
                    ? [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: cs.danger),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 6),
          ],
          AbsorbPointer(
            absorbing: !widget.enabled,
            child: AnimatedOpacity(
              opacity: widget.enabled ? 1 : 0.7,
              duration: motion.standard.duration,
              curve: motion.standard.curve,
              child: AnimatedContainer(
                duration: motion.standard.duration,
                curve: motion.standard.curve,
                height: (widget.expands || widget.maxLines != 1)
                    ? null
                    : height,
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: (widget.expands || widget.maxLines != 1) ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: widget.enabled ? cs.surface : cs.muted,
                  borderRadius: Radii.lgAll,
                  border: Border.all(color: borderColor),
                  boxShadow: boxShadow,
                ),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      IconTheme(
                        data: IconThemeData(color: cs.textMuted),
                        child: DefaultTextStyle(
                          style: TextStyle(color: cs.textMuted),
                          child: widget.leading!,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          if (widget.placeholder != null)
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _controller,
                              builder: (_, value, _) => value.text.isEmpty
                                  ? Text(
                                      widget.placeholder!,
                                      style: typo.body.copyWith(
                                        color: cs.textSubtle,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          IgnorePointer(
                            ignoring: widget.readOnly,
                            child: EditableText(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: widget.onChanged,
                              onSubmitted: widget.onSubmitted,
                              style: typo.body.copyWith(color: cs.text),
                              cursorColor: cs.brand,
                              backgroundCursorColor: cs.border,
                              selectionColor:
                                  cs.brand.withValues(alpha: 0.2),
                              keyboardType: widget.keyboardType,
                              obscureText: widget.obscureText,
                              readOnly: widget.readOnly || !widget.enabled,
                              textInputAction: widget.textInputAction,
                              autocorrect: widget.autocorrect,
                              smartDashesType: widget.smartDashesType,
                              smartQuotesType: widget.smartQuotesType,
                              maxLines: widget.maxLines,
                              minLines: widget.minLines,
                              expands: widget.expands,
                              autofocus: widget.autofocus,
                              textCapitalization: widget.textCapitalization,
                              inputFormatters: widget.inputFormatters,
                              autofillHints: widget.autofillHints,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      const SizedBox(width: 8),
                      IconTheme(
                        data: IconThemeData(color: cs.textMuted),
                        child: DefaultTextStyle(
                          style: TextStyle(color: cs.textMuted),
                          child: widget.trailing!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (widget.helper != null || errored) ...[
            const SizedBox(height: 6),
            Text(
              widget.error ?? widget.helper!,
              style: typo.caption.copyWith(
                color: errored ? cs.danger : cs.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
