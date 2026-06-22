import 'dart:async';

import 'package:flutter/widgets.dart';

import '../components/molecules/snackbar.dart';
import '../theme/theme.dart';
import '../tokens/spacing.dart';

class _SnackbarHandlerScope extends InheritedWidget {
  const _SnackbarHandlerScope({
    required super.child,
    required this.state,
  });

  final SnackbarHandlerState state;

  @override
  bool updateShouldNotify(_SnackbarHandlerScope oldWidget) =>
      state != oldWidget.state;
}

/// A widget that manages [Snackbar] overlays for its subtree.
///
/// Place one [SnackbarHandler] near the root of your app (above the
/// [Overlay]). Show snackbars via `context.showSnackbar(...)` or
/// `SnackbarHandler.of(context).show(...)`.
class SnackbarHandler extends StatefulWidget {
  /// Creates a snackbar handler.
  const SnackbarHandler({required this.child, super.key});

  /// Returns the [SnackbarHandlerState] from the nearest ancestor handler.
  static SnackbarHandlerState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SnackbarHandlerScope>()!
        .state;
  }

  /// The subtree that can display snackbars via this handler.
  final Widget child;

  @override
  State<SnackbarHandler> createState() => SnackbarHandlerState();
}

/// State for [SnackbarHandler]. Use [show] to display a snackbar.
class SnackbarHandlerState extends State<SnackbarHandler>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  Timer? _hideTimer;
  Duration _pendingDuration = const Duration(seconds: 5);

  late final AnimationController _controller;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.2, 0, 0, 1),
      reverseCurve: const Cubic(0.4, 0, 1, 1),
    );
    _controller.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _hideTimer = Timer(_pendingDuration, _hide);
    } else if (status == AnimationStatus.dismissed) {
      _entry?.remove();
      _entry?.dispose();
      _entry = null;
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _animation.dispose();
    _controller.dispose();
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    super.dispose();
  }

  /// Shows [snackbar] for [duration], replacing any currently visible one.
  void show(
    BuildContext callerContext,
    Snackbar snackbar, [
    Duration duration = const Duration(seconds: 5),
  ]) {
    _hideTimer?.cancel();
    _hideTimer = null;
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    _controller.value = 0;
    _pendingDuration = duration;

    final themeData = Theme.of(callerContext);

    _entry = OverlayEntry(
      builder:
          (ctx) => Theme(
            data: themeData,
            child: Align(
              alignment: Alignment.bottomRight,
              child: FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1).animate(_animation),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(ctx).bottom,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.s4),
                        child: snackbar,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_entry!);
    unawaited(_controller.forward());
  }

  void _hide() {
    _hideTimer = null;
    if (_entry == null) return;
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return _SnackbarHandlerScope(
      state: this,
      child: widget.child,
    );
  }
}

/// Snackbar display helper on [BuildContext].
extension SnackbarContext on BuildContext {
  /// Displays [snackbar] for [duration] via the nearest
  /// [SnackbarHandler].
  void showSnackbar(
    Snackbar snackbar, [
    Duration duration = const Duration(seconds: 5),
  ]) {
    SnackbarHandler.of(this).show(this, snackbar, duration);
  }
}
