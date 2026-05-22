import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

/// The physical dimensions of a [CatalystSwitch] knob and track.
typedef SwitchDimens = ({double width, double height, double knob});

/// Controls the size of a [CatalystSwitch].
enum SwitchSize {
  /// 32 × 18 px track, 14 px knob.
  small((width: 32, height: 18, knob: 14)),

  /// 44 × 24 px track, 20 px knob (default).
  medium((width: 44, height: 24, knob: 20)),

  /// 52 × 30 px track, 26 px knob.
  large((width: 52, height: 30, knob: 26));

  const SwitchSize(this.dimens);

  /// The pixel dimensions for this size variant.
  final SwitchDimens dimens;
}

/// A toggleable on/off switch control.
///
/// Pass `null` for [onChanged] to render the switch as disabled.
///
/// ```dart
/// CatalystSwitch(
///   value: _isOn,
///   onChanged: (v) => setState(() => _isOn = v),
/// )
/// ```
class CatalystSwitch extends StatefulWidget {
  /// Creates a switch.
  const CatalystSwitch({
    required this.value,
    required this.onChanged,
    this.size = SwitchSize.medium,
    super.key,
  });

  /// Whether the switch is currently on.
  final bool value;

  /// Called when the user toggles the switch. Pass `null` to disable.
  final ValueChanged<bool>? onChanged;

  /// The size variant.
  final SwitchSize size;

  @override
  State<CatalystSwitch> createState() => _CatalystSwitchState();
}

class _CatalystSwitchState extends State<CatalystSwitch> {
  late final WidgetStatesController _controller;

  bool get _disabled => widget.onChanged == null;

  SwitchDimens get _dimens => widget.size.dimens;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController({
      if (_disabled) WidgetState.disabled,
    })..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(CatalystSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.update(WidgetState.disabled, _disabled);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;
    final states = _controller.value;
    final isPressed = states.contains(WidgetState.pressed);

    return MouseRegion(
      onEnter: (_) => _controller.update(WidgetState.hovered, true),
      onExit: (_) {
        _controller
          ..update(WidgetState.hovered, false)
          ..update(WidgetState.pressed, false);
      },
      cursor: _disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onChanged?.call(!widget.value),
        onTapDown: (_) => _controller.update(WidgetState.pressed, true),
        onTapUp: (_) => _controller.update(WidgetState.pressed, false),
        onTapCancel: () => _controller.update(WidgetState.pressed, false),
        child: AnimatedOpacity(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          opacity: _disabled ? 0.4 : 1,
          child: AnimatedContainer(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            width: _dimens.width,
            height: _dimens.height,
            decoration: BoxDecoration(
              borderRadius: CatalystRadius.pillAll,
              color: widget.value ? cs.brand : cs.textDisabled,
            ),
            alignment:
                widget.value ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: motion.micro.duration,
              curve: motion.micro.curve,
              width: _dimens.knob - (isPressed ? 2 : 0),
              height: _dimens.knob - (isPressed ? 2 : 0),
              margin: EdgeInsets.symmetric(horizontal: isPressed ? 4 : 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
