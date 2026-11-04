import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../utils/display_regions.dart';
import 'adaptive_bar.dart';

/// Which panes of an [ArrangementView] are showing.
enum ArrangementPanes {
  /// Both panes, arranged by the view.
  both,

  /// Only the primary pane. The secondary pane stays mounted (offstage), so
  /// its state survives until it shows again.
  primary,

  /// Only the secondary pane. The primary pane stays mounted (offstage).
  secondary,
}

/// How an [ArrangementView] arranges its panes.
enum ArrangementStyle {
  /// The panes divide the area: side by side when it is wider than tall,
  /// stacked when it is taller than wide.
  split,

  /// The primary pane sits on top of the secondary pane, except when a fold
  /// divides the area, when each pane takes one side.
  overlay,
}

/// A layout container for two views — a primary and a secondary — that
/// arranges them by size, orientation and reserved regions such as the fold.
///
/// When a fold crosses the view, the panes resize so each one clears it
/// instead of rearranging. The tree is the same whichever panes show, so
/// pane state survives size changes, folding and unfolding.
///
/// An arrangement view lays out content only: keep navigation (routers, tab
/// shells) outside it.
class ArrangementView extends StatefulWidget {
  /// Creates a split arrangement.
  const ArrangementView.split({
    required this.primary,
    required this.secondary,
    this.axes = const {Axis.horizontal, Axis.vertical},
    this.primaryFraction = 0.4,
    this.panes = ArrangementPanes.both,
    super.key,
  }) : style = ArrangementStyle.split;

  /// Creates an overlay arrangement.
  const ArrangementView.overlay({
    required this.primary,
    required this.secondary,
    bool secondaryCollapsed = false,
    super.key,
  }) : style = ArrangementStyle.overlay,
       axes = const {Axis.horizontal, Axis.vertical},
       primaryFraction = 0.5,
       panes = secondaryCollapsed
           ? ArrangementPanes.primary
           : ArrangementPanes.both;

  /// The primary view: the leading (or top) pane, or the one on top in an
  /// overlay arrangement.
  final Widget primary;

  /// The secondary view.
  final Widget secondary;

  /// How the panes are arranged.
  final ArrangementStyle style;

  /// The axes a split arrangement may split along. With only
  /// [Axis.horizontal] the panes are always side by side.
  final Set<Axis> axes;

  /// The share of the area the primary pane takes in a split arrangement when
  /// no fold crosses it.
  final double primaryFraction;

  /// Which panes are showing.
  final ArrangementPanes panes;

  @override
  State<ArrangementView> createState() => _ArrangementViewState();
}

class _ArrangementViewState extends State<ArrangementView> {
  /// The view's rect in global coordinates, as of the last frame. Folds are
  /// reported globally, so this maps them into the view.
  Rect? _globalRect;

  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect != _globalRect) setState(() => _globalRect = rect);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    final media = MediaQuery.of(context);
    final edge = VerticalBarEdgeScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final origin = _globalRect?.topLeft ?? Offset.zero;
        final local = Offset.zero & size;
        final folds = DisplayRegions.dividers(
          media,
        ).map((f) => f.shift(-origin)).where((f) => f.overlaps(local));

        final axis = _axisFor(size, folds);
        final fold = folds
            .where(
              (f) => axis == Axis.horizontal
                  ? f.top <= 0 && f.bottom >= size.height
                  : f.left <= 0 && f.right >= size.width,
            )
            .firstOrNull;

        final split =
            widget.panes == ArrangementPanes.both &&
            (widget.style == ArrangementStyle.split || fold != null);

        return _ArrangementLayout(
          axis: axis,
          fold: fold,
          primaryFraction: widget.primaryFraction,
          panes: widget.panes,
          split: split,
          children: [
            // Only the pane along the vertical bar edge moves its controls to
            // the side; the other keeps them with its content.
            _pane(
              _primaryKey,
              HorizontalBarScope(
                enabled:
                    split &&
                    axis == Axis.horizontal &&
                    edge == VerticalBarEdge.right,
                child: widget.primary,
              ),
              visible: widget.panes != ArrangementPanes.secondary,
            ),
            _pane(
              _secondaryKey,
              HorizontalBarScope(
                enabled:
                    split &&
                    (axis == Axis.vertical || edge == VerticalBarEdge.left),
                child: widget.secondary,
              ),
              visible: widget.panes != ArrangementPanes.primary,
            ),
            if (split && fold == null)
              Container(color: context.colorScheme.borderSubtle),
          ],
        );
      },
    );
  }

  final GlobalKey _primaryKey = GlobalKey(
    debugLabel: 'ArrangementView.primary',
  );
  final GlobalKey _secondaryKey = GlobalKey(
    debugLabel: 'ArrangementView.secondary',
  );

  Widget _pane(Key key, Widget child, {required bool visible}) {
    return KeyedSubtree(
      key: key,
      child: Offstage(
        offstage: !visible,
        child: TickerMode(enabled: visible, child: child),
      ),
    );
  }

  Axis _axisFor(Size size, Iterable<Rect> folds) {
    if (widget.axes.length == 1) return widget.axes.single;
    // A fold decides the axis, so the panes fall on either side of it.
    for (final f in folds) {
      if (f.height >= size.height) return Axis.horizontal;
      if (f.width >= size.width) return Axis.vertical;
    }
    return size.width >= size.height ? Axis.horizontal : Axis.vertical;
  }
}

class _ArrangementLayout extends MultiChildRenderObjectWidget {
  const _ArrangementLayout({
    required this.axis,
    required this.fold,
    required this.primaryFraction,
    required this.panes,
    required this.split,
    required super.children,
  });

  final Axis axis;
  final Rect? fold;
  final double primaryFraction;
  final ArrangementPanes panes;
  final bool split;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderArrangement(
    axis: axis,
    fold: fold,
    primaryFraction: primaryFraction,
    panes: panes,
    split: split,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderArrangement renderObject,
  ) {
    renderObject
      ..axis = axis
      ..fold = fold
      ..primaryFraction = primaryFraction
      ..panes = panes
      ..split = split;
  }
}

class _ArrangementParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderArrangement extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ArrangementParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ArrangementParentData> {
  _RenderArrangement({
    required Axis axis,
    required Rect? fold,
    required double primaryFraction,
    required ArrangementPanes panes,
    required bool split,
  }) {
    _axis = axis;
    _fold = fold;
    _primaryFraction = primaryFraction;
    _panes = panes;
    _split = split;
  }

  late Axis _axis;
  Axis get axis => _axis;
  set axis(Axis value) {
    if (value == _axis) return;
    _axis = value;
    markNeedsLayout();
  }

  late Rect? _fold;
  Rect? get fold => _fold;
  set fold(Rect? value) {
    if (value == _fold) return;
    _fold = value;
    markNeedsLayout();
  }

  late double _primaryFraction;
  double get primaryFraction => _primaryFraction;
  set primaryFraction(double value) {
    if (value == _primaryFraction) return;
    _primaryFraction = value;
    markNeedsLayout();
  }

  late ArrangementPanes _panes;
  ArrangementPanes get panes => _panes;
  set panes(ArrangementPanes value) {
    if (value == _panes) return;
    _panes = value;
    markNeedsLayout();
  }

  late bool _split;
  bool get split => _split;
  set split(bool value) {
    if (value == _split) return;
    _split = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ArrangementParentData) {
      child.parentData = _ArrangementParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    final primary = firstChild!;
    final secondary = childAfter(primary)!;
    final divider = childAfter(secondary);
    final horizontal = _axis == Axis.horizontal;
    final total = horizontal ? size.width : size.height;

    if (!_split) {
      // One pane fills the area; in an overlay arrangement the primary sits
      // on top of the secondary.
      for (final child in [primary, secondary]) {
        child.layout(BoxConstraints.tight(size));
        (child.parentData! as _ArrangementParentData).offset = Offset.zero;
      }
      divider?.layout(BoxConstraints.tight(Size.zero));
      return;
    }

    final fold = _fold;
    final double primaryEnd;
    final double secondaryStart;
    if (fold != null) {
      // Each pane clears the fold.
      primaryEnd = (horizontal ? fold.left : fold.top).clamp(0, total);
      secondaryStart = (horizontal ? fold.right : fold.bottom).clamp(0, total);
    } else {
      primaryEnd = (total * _primaryFraction).roundToDouble();
      secondaryStart = primaryEnd + 1;
    }

    Size along(double extent) =>
        horizontal ? Size(extent, size.height) : Size(size.width, extent);
    Offset at(double position) =>
        horizontal ? Offset(position, 0) : Offset(0, position);

    primary.layout(BoxConstraints.tight(along(primaryEnd)));
    (primary.parentData! as _ArrangementParentData).offset = Offset.zero;
    secondary.layout(BoxConstraints.tight(along(total - secondaryStart)));
    (secondary.parentData! as _ArrangementParentData).offset = at(
      secondaryStart,
    );
    if (divider != null) {
      divider.layout(BoxConstraints.tight(along(secondaryStart - primaryEnd)));
      (divider.parentData! as _ArrangementParentData).offset = at(primaryEnd);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_split) {
      defaultPaint(context, offset);
      return;
    }
    // Paint the visible pane only; in an overlay arrangement the primary
    // paints last so it sits on top.
    for (final child in [childAfter(firstChild!)!, firstChild!]) {
      final data = child.parentData! as _ArrangementParentData;
      context.paintChild(child, data.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

/// A grid delegate like [SliverGridDelegateWithMaxCrossAxisExtent] that
/// prefers an even number of columns when [preferEven] is true, so the grid
/// divides cleanly across a fold.
///
/// An odd count rounds up to the next even count, unless that would make tiles
/// narrower than [minCrossAxisExtent]; then it rounds down instead, giving
/// fewer, wider tiles.
class SliverGridDelegateWithEvenColumns extends SliverGridDelegate {
  /// Creates the delegate.
  const SliverGridDelegateWithEvenColumns({
    required this.maxCrossAxisExtent,
    required this.preferEven,
    this.minCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.mainAxisExtent,
  });

  /// The largest a tile may be across the grid.
  final double maxCrossAxisExtent;

  /// Whether to use an even number of columns.
  final bool preferEven;

  /// The narrowest a tile may become when rounding up to an even count.
  /// Defaults to three quarters of [maxCrossAxisExtent].
  final double? minCrossAxisExtent;

  /// The gap between rows.
  final double mainAxisSpacing;

  /// The gap between columns.
  final double crossAxisSpacing;

  /// The tiles' width:height ratio, unless [mainAxisExtent] is set.
  final double childAspectRatio;

  /// A fixed tile height.
  final double? mainAxisExtent;

  /// The number of columns for a cross-axis extent of [extent].
  int columnsFor(double extent) {
    var count = (extent / (maxCrossAxisExtent + crossAxisSpacing)).ceil();
    if (count < 1) count = 1;
    if (!preferEven || count.isEven) return count;
    final minExtent = minCrossAxisExtent ?? maxCrossAxisExtent * 0.75;
    double tileWidth(int columns) =>
        (extent - crossAxisSpacing * (columns - 1)) / columns;
    if (count == 1 || tileWidth(count + 1) >= minExtent) return count + 1;
    return count - 1;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final count = columnsFor(constraints.crossAxisExtent);
    final usable = constraints.crossAxisExtent - crossAxisSpacing * (count - 1);
    final tileWidth = usable / count;
    final tileHeight = mainAxisExtent ?? tileWidth / childAspectRatio;
    return SliverGridRegularTileLayout(
      crossAxisCount: count,
      mainAxisStride: tileHeight + mainAxisSpacing,
      crossAxisStride: tileWidth + crossAxisSpacing,
      childMainAxisExtent: tileHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithEvenColumns oldDelegate) =>
      oldDelegate.maxCrossAxisExtent != maxCrossAxisExtent ||
      oldDelegate.preferEven != preferEven ||
      oldDelegate.minCrossAxisExtent != minCrossAxisExtent ||
      oldDelegate.mainAxisSpacing != mainAxisSpacing ||
      oldDelegate.crossAxisSpacing != crossAxisSpacing ||
      oldDelegate.childAspectRatio != childAspectRatio ||
      oldDelegate.mainAxisExtent != mainAxisExtent;
}

/// Whether a fold crosses the widget at [context] (as of the last layout).
///
/// Use it to decide [SliverGridDelegateWithEvenColumns.preferEven].
bool foldCrosses(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) {
    return DisplayRegions.dividers(MediaQuery.of(context)).isNotEmpty;
  }
  final rect = box.localToGlobal(Offset.zero) & box.size;
  return DisplayRegions.divides(MediaQuery.of(context), rect);
}
