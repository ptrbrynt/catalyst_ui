import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import 'spinner.dart';

// ── Variant system ───────────────────────────────────────────────────────────

/// The resolved visual properties for a single [ButtonVariant].
@immutable
class ButtonVariantStyle {
  /// Creates a button variant style.
  const ButtonVariantStyle({
    required this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
  });

  /// The text and icon colour.
  final Color foregroundColor;

  /// The fill colour. `null` renders a transparent background.
  final Color? backgroundColor;

  /// The border colour. `null` renders no border.
  final Color? borderColor;

  /// Optional box shadows (e.g. branded glow for primary buttons).
  final List<BoxShadow>? shadows;
}

/// Defines the visual appearance of a [Button].
///
/// Extend this class to create your own variants:
///
/// ```dart
/// class MyBrandVariant extends ButtonVariant {
///   const MyBrandVariant();
///
///   @override
///   ButtonVariantStyle resolve(CatalystColorScheme cs) {
///     return ButtonVariantStyle(
///       backgroundColor: cs.brand,
///       foregroundColor: cs.onBrand,
///       shadows: [BoxShadow(color: cs.brand.withValues(alpha: 0.35), ...)],
///     );
///   }
/// }
///
/// // Then use it:
/// Button(label: Text('Go'), variant: const MyBrandVariant(), onPressed: ...)
/// ```
///
/// Built-in variants are available as static constants on this class:
/// [ButtonVariant.primary], [ButtonVariant.secondary],
/// [ButtonVariant.tertiary], [ButtonVariant.ghost],
/// [ButtonVariant.destructive], [ButtonVariant.success].
@immutable
abstract class ButtonVariant {
  /// Const constructor for subclasses.
  const ButtonVariant();

  /// Solid brand fill; the default primary call-to-action.
  static const ButtonVariant primary = _PrimaryButtonVariant();

  /// Outlined button on a surface background; secondary actions.
  static const ButtonVariant secondary = _SecondaryButtonVariant();

  /// Subtle filled button with a light border; lower-priority actions.
  static const ButtonVariant tertiary = _TertiaryButtonVariant();

  /// No background or border; lowest-emphasis actions.
  static const ButtonVariant ghost = _GhostButtonVariant();

  /// Solid danger fill; irreversible or destructive actions.
  static const ButtonVariant destructive = _DestructiveButtonVariant();

  /// Solid success fill; confirmation or positive actions.
  static const ButtonVariant success = _SuccessButtonVariant();

  /// Resolves the visual style for this variant against [colorScheme].
  ButtonVariantStyle resolve(CatalystColorScheme colorScheme);
}

class _PrimaryButtonVariant extends ButtonVariant {
  const _PrimaryButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.brand,
      foregroundColor: cs.onBrand,
      shadows: [
        BoxShadow(
          offset: const Offset(0, 6),
          blurRadius: 18,
          color: cs.brand.withValues(alpha: 0.28),
        ),
      ],
    );
  }
}

class _SecondaryButtonVariant extends ButtonVariant {
  const _SecondaryButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.surface,
      foregroundColor: cs.text,
      borderColor: cs.border,
      shadows: const [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 12,
          color: Color.fromRGBO(15, 23, 42, 0.08),
        ),
      ],
    );
  }
}

class _TertiaryButtonVariant extends ButtonVariant {
  const _TertiaryButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.subtle,
      foregroundColor: cs.text,
      borderColor: cs.borderSubtle,
    );
  }
}

class _GhostButtonVariant extends ButtonVariant {
  const _GhostButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(foregroundColor: cs.text);
  }
}

class _DestructiveButtonVariant extends ButtonVariant {
  const _DestructiveButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.danger,
      foregroundColor: cs.onDanger,
    );
  }
}

class _SuccessButtonVariant extends ButtonVariant {
  const _SuccessButtonVariant();

  @override
  ButtonVariantStyle resolve(CatalystColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.success,
      foregroundColor: cs.onSuccess,
    );
  }
}

// ── Size ─────────────────────────────────────────────────────────────────────

/// Controls the height, padding, and font size of a [Button].
enum ButtonSize {
  /// 16px tall; 15 sp text; 20 px icons;
  link(height: null, horizontalPadding: 0, fontSize: 15, iconSize: 20, gap: 8),

  /// 36 px tall; 14 sp text; 16 px icons.
  small(height: 36, horizontalPadding: 14, fontSize: 14, iconSize: 16, gap: 6),

  /// 44 px tall; 15 sp text; 20 px icons.
  medium(height: 44, horizontalPadding: 16, fontSize: 15, iconSize: 20, gap: 8),

  /// 52 px tall; 16 sp text; 24 px icons (default).
  large(height: 52, horizontalPadding: 20, fontSize: 16, iconSize: 24, gap: 10),

  /// 60 px tall; 16 sp text; 28 px icons.
  extraLarge(
    height: 60,
    horizontalPadding: 20,
    fontSize: 16,
    iconSize: 28,
    gap: 10,
  );

  const ButtonSize({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.gap,
  });

  /// The total height of the button in logical pixels.
  final double? height;

  /// Horizontal padding inside the button.
  final double horizontalPadding;

  /// The font size of the label text.
  final double fontSize;

  /// The size of leading/trailing icons.
  final double iconSize;

  /// The spacing between adjacent children (icon ↔ label).
  final double gap;
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A pressable button supporting labels, icons, loading states, and
/// user-defined visual variants.
///
/// Pass `null` for [onPressed] to disable the button.
///
/// ```dart
/// Button(
///   label: const Text('Save'),
///   variant: ButtonVariant.primary,
///   onPressed: _handleSave,
/// )
/// ```
///
/// Use [Button.icon] for a square icon-only button.
class Button extends StatefulWidget {
  /// Creates a labelled button.
  const Button({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.loading = false,
    this.elevated = false,
    this.fullWidth = false,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    super.key,
  }) : _isSquare = false;

  /// Creates a square icon-only button.
  const Button.icon({
    required Widget icon,
    required this.onPressed,
    this.loading = false,
    this.elevated = false,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    super.key,
  }) : label = icon,
       fullWidth = false,
       leadingIcon = null,
       trailingIcon = null,
       _isSquare = true;

  /// The visual variant. Defaults to [ButtonVariant.primary].
  final ButtonVariant variant;

  /// The size variant. Defaults to [ButtonSize.large].
  final ButtonSize size;

  /// The primary content, typically a [Text] widget.
  final Widget label;

  /// An optional icon placed to the left of [label].
  final Widget? leadingIcon;

  /// An optional icon placed to the right of [label].
  final Widget? trailingIcon;

  /// Shows a [Spinner] and ignores taps when `true`.
  final bool loading;

  /// Adds a drop shadow beneath the button when `true`.
  final bool elevated;

  /// Stretches the button to fill available width when `true`.
  final bool fullWidth;

  /// Called when tapped. Pass `null` to disable.
  final VoidCallback? onPressed;

  final bool _isSquare;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController({
      if (widget.onPressed == null) WidgetState.disabled,
    })..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.update(WidgetState.disabled, widget.onPressed == null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.variant.resolve(context.colorScheme);
    final states = _controller.value;
    final isDisabled = states.contains(WidgetState.disabled);
    final isPressed = states.contains(WidgetState.pressed);

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontSize: widget.size.fontSize,
        fontWeight: FontWeight.w500,
        height: 1,
        color: style.foregroundColor,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: style.foregroundColor,
          size: widget.size.iconSize,
        ),
        child: GestureDetector(
          onTapDown: (_) => _controller.update(WidgetState.pressed, true),
          onTapUp: (_) => _controller.update(WidgetState.pressed, false),
          onTapCancel: () => _controller.update(WidgetState.pressed, false),
          onTap: (widget.loading || isDisabled) ? null : widget.onPressed,
          child: MouseRegion(
            onEnter: (_) => _controller.update(WidgetState.hovered, true),
            onExit: (_) => _controller.update(WidgetState.hovered, false),
            cursor:
                isDisabled || widget.loading
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
            child: Focus(
              onFocusChange: (f) => _controller.update(WidgetState.focused, f),
              child: _buildContainer(style, isDisabled, isPressed),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(
    ButtonVariantStyle style,
    bool isDisabled,
    bool isPressed,
  ) {
    final motion = context.motion;
    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      clipBehavior: Clip.antiAlias,
      height: widget.size.height,
      width: widget._isSquare ? widget.size.height : null,
      decoration: BoxDecoration(
        borderRadius: CatalystRadius.lgAll,
        boxShadow: widget.elevated ? (style.shadows ?? []) : null,
        border:
            style.borderColor != null
                ? Border.all(color: style.borderColor!)
                : null,
        color: style.backgroundColor?.withAlpha(isDisabled ? 20 : 255),
      ),
      padding:
          widget._isSquare
              ? null
              : EdgeInsets.symmetric(horizontal: widget.size.horizontalPadding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: widget.loading ? 0 : 1,
            duration: motion.standard.duration,
            curve: motion.standard.curve,
            child: _buildContent(),
          ),
          AnimatedOpacity(
            opacity: widget.loading ? 1 : 0,
            duration: motion.standard.duration,
            curve: motion.standard.curve,
            child: Spinner(
              color: style.foregroundColor,
              size: widget.size.iconSize,
            ),
          ),
        ],
      ),
    ).withBrightness(isPressed && !isDisabled ? 0.92 : 1);
  }

  Widget _buildContent() {
    final halfGap = widget.size.gap / 2;
    return AnimatedSize(
      duration: context.motion.standard.duration,
      reverseDuration: context.motion.standard.duration,
      curve: context.motion.standard.curve,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (widget.leadingIcon != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: halfGap),
              child: widget.leadingIcon,
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: halfGap),
            child: widget.label,
          ),
          if (widget.trailingIcon != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: halfGap),
              child: widget.trailingIcon,
            ),
        ],
      ),
    );
  }
}
