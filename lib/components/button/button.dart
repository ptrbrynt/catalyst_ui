import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';

export 'button_theme_data.dart';

/// {@template button}
/// A button.
/// {@endtemplate}
class Button extends StyleableStatefulWidget {
  /// {@macro button}
  const Button({
    this.label,
    this.icon,
    this.onPressed,
    super.styles = const [],
    super.key,
  });

  /// The label of the button.
  final String? label;

  /// The icon of the button.
  final Widget? icon;

  /// The callback that is called when the button is pressed.
  ///
  /// If this is null, the button will be disabled.
  final VoidCallback? onPressed;

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late ButtonState _buttonState;

  bool get enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _buttonState = enabled ? ButtonState.enabled : ButtonState.disabled;
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _buttonState = enabled ? ButtonState.enabled : ButtonState.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CatalystTheme.of(context)
        ?.data
        .buttonThemeData
        .forStyles(widget.styles);

    final iconPosition =
        theme?.iconPosition ?? ButtonThemeData.defaultIconPosition;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: enabled
          ? (_) => setState(() => _buttonState = ButtonState.hover)
          : null,
      onExit: enabled
          ? (_) => setState(() => _buttonState = ButtonState.enabled)
          : null,
      child: GestureDetector(
        onTapDown: enabled
            ? (_) => setState(() => _buttonState = ButtonState.pressed)
            : null,
        onTapUp: enabled
            ? (_) => setState(() => _buttonState = ButtonState.hover)
            : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: theme?.height,
          clipBehavior: Clip.antiAlias,
          decoration: theme?.decoration?.call(_buttonState),
          padding: theme?.padding?.call(_buttonState),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPosition == ButtonIconPosition.left &&
                  widget.icon != null)
                widget.icon!,
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: theme?.textStyle?.call(_buttonState),
                ),
              if (iconPosition == ButtonIconPosition.right &&
                  widget.icon != null)
                widget.icon!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Positions for the icon in a button.
enum ButtonIconPosition {
  /// The icon is on the left side of the label.
  left,

  /// The icon is on the right side of the label.
  right,
}
