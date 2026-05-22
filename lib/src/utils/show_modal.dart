import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import '../tokens/spacing.dart';

/// Displays a modal dialog centred on screen with a fade + scale transition.
///
/// Returns the value passed to `Navigator.pop`, or `null` if dismissed.
Future<T?> showCatalystModal<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  final themeData = CatalystTheme.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierColor: const Color.fromRGBO(11, 13, 18, 0.45),
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 300),
    useRootNavigator: useRootNavigator,
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: const Cubic(0.2, 0, 0, 1),
        reverseCurve: const Cubic(0.4, 0, 1, 1),
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (context, _, _) => CatalystTheme(
      data: themeData,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(CatalystSpacing.s4),
            child: builder(context),
          ),
        ),
      ),
    ),
  );
}

/// Displays a bottom sheet sliding up from the bottom of the screen.
///
/// When [draggable] is `true` (the default) the sheet can be dismissed by
/// dragging downward. Returns the value passed to `Navigator.pop`.
Future<T?> showCatalystBottomSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  bool draggable = true,
}) {
  final themeData = CatalystTheme.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierColor: const Color.fromRGBO(11, 13, 18, 0.45),
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 300),
    useRootNavigator: useRootNavigator,
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: const Cubic(0.2, 0, 0, 1),
        reverseCurve: const Cubic(0.4, 0, 1, 1),
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 4),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (context, _, _) => CatalystTheme(
      data: themeData,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: draggable
            ? _DraggableSheet(child: builder(context))
            : builder(context),
      ),
    ),
  );
}

/// Displays a drawer panel sliding in from the right edge.
///
/// Returns the value passed to `Navigator.pop`.
Future<T?> showCatalystDrawer<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  final themeData = CatalystTheme.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierColor: const Color.fromRGBO(11, 13, 18, 0.45),
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 300),
    useRootNavigator: useRootNavigator,
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: const Cubic(0.2, 0, 0, 1),
        reverseCurve: const Cubic(0.4, 0, 1, 1),
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(4, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (context, _, _) => CatalystTheme(
      data: themeData,
      child: Align(
        alignment: Alignment.centerRight,
        child: builder(context),
      ),
    ),
  );
}

class _DraggableSheet extends StatefulWidget {
  const _DraggableSheet({required this.child});
  final Widget child;

  @override
  State<_DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<_DraggableSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _snapBack;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _snapBack = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _snapBack.dispose();
    super.dispose();
  }

  void _onUpdate(DragUpdateDetails d) {
    if (d.delta.dy > 0) setState(() => _offset += d.delta.dy);
  }

  void _onEnd(DragEndDetails d) {
    if (_offset > 120 || d.velocity.pixelsPerSecond.dy > 500) {
      Navigator.of(context).pop();
      return;
    }
    final start = _offset;
    final anim =
        Tween<double>(begin: start, end: 0).animate(
          CurvedAnimation(parent: _snapBack, curve: Curves.easeOut),
        );
    void listener() {
      if (mounted) setState(() => _offset = anim.value);
    }
    anim.addListener(listener);
    unawaited(
      _snapBack.forward(from: 0).then((_) {
        anim.removeListener(listener);
        if (mounted) {
          setState(() => _offset = 0);
          _snapBack.reset();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: Transform.translate(
        offset: Offset(0, _offset),
        child: widget.child,
      ),
    );
  }
}
