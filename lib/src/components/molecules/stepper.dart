import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A horizontal step indicator showing progress through a multi-step flow.
///
/// Completed steps show a check mark; the active step shows its number
/// in an outlined circle; future steps are greyed out.
///
/// ```dart
/// Stepper(
///   current: 1,
///   steps: const ['Account', 'Details', 'Review'],
/// )
/// ```
class Stepper extends StatefulWidget {
  /// Creates a stepper.
  const Stepper({
    required this.current,
    required this.steps,
    super.key,
  });

  /// The zero-based index of the currently active step.
  final int current;

  /// The ordered list of step labels.
  final List<String> steps;

  @override
  State<Stepper> createState() => _StepperState();
}

class _StepperState extends State<Stepper> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.current;
  }

  @override
  void didUpdateWidget(Stepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current) {
      setState(() => _current = widget.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.steps.length; i++) ...[
          _buildItem(context, i),
          if (i < widget.steps.length - 1)
            Expanded(
              child: AnimatedContainer(
                duration: motion.micro.duration,
                curve: motion.micro.curve,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(
                    left: Spacing.s2,
                    right: Spacing.s2,
                    bottom: 18,
                  ),
                  decoration: BoxDecoration(
                    color:
                        i < _current
                            ? context.colorScheme.brand
                            : context.colorScheme.border,
                    borderRadius: Radii.pillAll,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildItem(BuildContext context, int i) {
    final motion = context.motion;
    final cs = context.colorScheme;
    final typo = context.typography;

    final isDone = i < _current;
    final isActive = i == _current;

    final indicatorFg =
        isDone
            ? cs.onBrand
            : isActive
            ? cs.brand
            : cs.textMuted;

    return Column(
      spacing: 6,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          style: TextStyle(
            fontFamily: typo.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: indicatorFg,
          ),
          child: AnimatedContainer(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.5,
                color: (isDone || isActive) ? cs.brand : cs.border,
              ),
              color:
                  isDone
                      ? cs.brand
                      : isActive
                      ? cs.surface
                      : cs.subtle,
            ),
            child: AnimatedSwitcher(
              duration: motion.micro.duration,
              switchInCurve: motion.micro.curve,
              switchOutCurve: motion.micro.curve,
              child:
                  isDone
                      ? Icon(LucideIcons.check, size: 14, color: indicatorFg)
                      : Text('${i + 1}'),
            ),
          ),
        ),
        AnimatedDefaultTextStyle(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          style: TextStyle(
            fontFamily: typo.fontFamily,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
            height: 1.2,
            color: (isActive || isDone) ? cs.text : cs.textMuted,
          ),
          child: Text(widget.steps[i]),
        ),
      ],
    );
  }
}
