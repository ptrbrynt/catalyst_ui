import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../../utils/display_regions.dart';
import '../atoms/button.dart';
import '../molecules/menu_button.dart';
import '../molecules/tooltip.dart';

/// The role of a [BarItem], which decides where it sits in a vertical bar.
///
/// Vertical bars reserve the top for navigation (Back, Close), followed by
/// prominent actions (Done), followed by everything else in its original
/// grouping.
enum BarItemRole {
  /// Primary navigation, such as Back or Close. Never overflows.
  navigation,

  /// A prominent action, such as Done or Save.
  prominent,

  /// Any other action. Items from the top bar come before items from the
  /// bottom bar, separated by a gap.
  top,

  /// An action that would sit in a bottom toolbar on other devices.
  bottom,
}

/// How a screen's bars give way when a vertical bar runs out of room.
enum BarCompression {
  /// Navigation-focused screens: toolbar items move into the overflow menu so
  /// the tab bar and primary destinations stay accessible. The default.
  navigation,

  /// Task-focused screens: the tab bar minimizes so the toolbar actions that
  /// are central to the task stay visible.
  task,
}

/// An action in a toolbar.
///
/// Every item has a [title] and, unless it is text-only, an [icon]. The title
/// is used for accessibility, tooltips and the overflow menu even when only
/// the icon is shown.
@immutable
class BarItem {
  /// Creates a bar item that runs [onPressed] or opens [menu] when tapped.
  const BarItem({
    required this.title,
    this.icon,
    this.onPressed,
    this.menu,
    this.role = BarItemRole.top,
    this.group = 0,
    this.groupPriority = 0,
    this.priority = 0,
    this.badge = false,
    this.selected = false,
    this.horizontal,
  });

  /// The item's title.
  final String title;

  /// The item's symbol. Items without one are text-only and stay in a
  /// horizontal bar (or the overflow menu, when bars are vertical).
  final IconData? icon;

  /// Called when the item is tapped.
  final VoidCallback? onPressed;

  /// When non-null, tapping the item opens this menu instead.
  final List<MenuItem>? menu;

  /// Where the item sits in a vertical bar.
  final BarItemRole role;

  /// Items with the same [group] (and [role]) are kept together.
  final int group;

  /// The visibility priority of the item's whole group. Lower priorities
  /// overflow first.
  final int groupPriority;

  /// The visibility priority of the item within its group. Lower priorities
  /// overflow first; between equal priorities, items overflow from the bottom.
  final int priority;

  /// Whether the item conveys status (such as an active filter). Badged items
  /// stay visible longer than unbadged items of the same priority.
  final bool badge;

  /// Whether the item is on, such as a panel it opens being open.
  final bool selected;

  /// How the item looks in a horizontal bar. Defaults to a circular icon
  /// button (or a text button for text-only items).
  final Widget? horizontal;

  bool get _vertical => icon != null;
}

/// Lays out [items] in a vertical bar of [extent] logical pixels.
///
/// Returns the items to show, in order, and the items that overflow, in
/// their original order. When anything overflows, room is kept for the
/// overflow button.
({List<BarItem> visible, List<BarItem> overflow}) layoutVerticalBar(
  List<BarItem> items,
  double extent, {
  bool hasExtraOverflow = false,
}) {
  final ordered = orderVerticalBarItems(items);
  final textOnly = items.where((i) => !i._vertical).toList();
  final removed = <BarItem>{};

  double heightOf(Iterable<BarItem> shown, {required bool withOverflow}) {
    var height = 0.0;
    BarItem? previous;
    for (final item in shown) {
      if (previous != null) height += _gapBetween(previous, item);
      height += VerticalToolbar.itemExtent;
      previous = item;
    }
    if (withOverflow) {
      if (previous != null) height += VerticalToolbar.groupGap;
      height += VerticalToolbar.itemExtent;
    }
    return height;
  }

  // Least important first; ties overflow from the bottom of the bar.
  final candidates =
      ordered.where((i) => i.role != BarItemRole.navigation).toList()..sort((
        a,
        b,
      ) {
        final group = a.groupPriority.compareTo(b.groupPriority);
        if (group != 0) return group;
        final item = a.priority.compareTo(b.priority);
        if (item != 0) return item;
        if (a.badge != b.badge) return a.badge ? 1 : -1;
        return ordered.indexOf(b).compareTo(ordered.indexOf(a));
      });

  bool fits() {
    final shown = ordered.where((i) => !removed.contains(i));
    final needsOverflow =
        removed.isNotEmpty || textOnly.isNotEmpty || hasExtraOverflow;
    return heightOf(shown, withOverflow: needsOverflow) <= extent;
  }

  for (final candidate in candidates) {
    if (fits()) break;
    removed.add(candidate);
  }

  return (
    visible: ordered.where((i) => !removed.contains(i)).toList(),
    overflow: items.where((i) => removed.contains(i) || !i._vertical).toList(),
  );
}

/// The order of [items] in a vertical bar: navigation, prominent, then the
/// top bar's groups and the bottom bar's groups, each in original order.
List<BarItem> orderVerticalBarItems(List<BarItem> items) {
  final vertical = items.where((i) => i._vertical).toList();
  return [
    for (final role in BarItemRole.values)
      ...vertical.where((i) => i.role == role),
  ];
}

double _gapBetween(BarItem previous, BarItem next) {
  if (previous.role == BarItemRole.bottom || next.role != BarItemRole.bottom) {
    if (previous.role == next.role && previous.group == next.group) {
      return VerticalToolbar.itemGap;
    }
    return VerticalToolbar.groupGap;
  }
  // The system leaves extra room between top-bar and bottom-bar items.
  return VerticalToolbar.sectionGap;
}

/// A vertical toolbar: [items] stacked top to bottom, with anything that
/// doesn't fit (plus text-only items and [overflow]) in a single overflow
/// menu at the end.
class VerticalToolbar extends StatelessWidget {
  /// Creates a vertical toolbar.
  const VerticalToolbar({
    required this.items,
    this.overflow = const [],
    super.key,
  });

  /// The height of each item.
  static const double itemExtent = 44;

  /// The gap between items in the same group.
  static const double itemGap = Spacing.s1;

  /// The gap between groups.
  static const double groupGap = Spacing.s3;

  /// The gap between top-bar items and bottom-bar items.
  static const double sectionGap = Spacing.s6;

  /// The items, in their original order.
  final List<BarItem> items;

  /// Extra entries for the overflow menu, such as actions from a screen's own
  /// "more" menu, so people find everything in one place.
  final List<MenuItem> overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = layoutVerticalBar(
          items,
          constraints.maxHeight,
          hasExtraOverflow: overflow.isNotEmpty,
        );
        final menu = [
          for (final item in layout.overflow) ..._menuEntries(item),
          if (layout.overflow.isNotEmpty && overflow.isNotEmpty)
            const MenuDivider(),
          ...overflow,
        ];
        final children = <Widget>[];
        BarItem? previous;
        for (final item in layout.visible) {
          if (previous != null) {
            children.add(SizedBox(height: _gapBetween(previous, item)));
          }
          children.add(_VerticalBarButton(item: item));
          previous = item;
        }
        if (menu.isNotEmpty) {
          if (previous != null) {
            children.add(const SizedBox(height: groupGap));
          }
          children.add(OverflowMenuButton(items: menu));
        }
        return Column(mainAxisSize: MainAxisSize.min, children: children);
      },
    );
  }

  static Iterable<MenuItem> _menuEntries(BarItem item) sync* {
    if (item.menu case final submenu?) {
      // Menus can't nest, so a menu item's entries join the overflow menu.
      yield const MenuDivider();
      yield* submenu;
      yield const MenuDivider();
    } else {
      yield MenuOption(
        label: item.title,
        icon: item.icon,
        onTap: item.onPressed,
      );
    }
  }
}

/// The single overflow menu of a bar. The ellipsis symbol is reserved for it.
class OverflowMenuButton extends StatelessWidget {
  /// Creates an overflow menu button.
  const OverflowMenuButton({required this.items, super.key});

  /// The overflowed actions.
  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return MenuButton(
      items: _tidy(items),
      build: (context, open) => _BarIconButton(
        icon: context.iconography.moreIcon,
        title: 'More',
        onPressed: open,
      ),
    );
  }

  // Drop leading, trailing and doubled dividers.
  static List<MenuItem> _tidy(List<MenuItem> items) {
    final result = <MenuItem>[];
    for (final item in items) {
      if (item is MenuDivider &&
          (result.isEmpty || result.last is MenuDivider)) {
        continue;
      }
      result.add(item);
    }
    while (result.isNotEmpty && result.last is MenuDivider) {
      result.removeLast();
    }
    return result;
  }
}

class _VerticalBarButton extends StatelessWidget {
  const _VerticalBarButton({required this.item});

  final BarItem item;

  @override
  Widget build(BuildContext context) {
    final menu = item.menu;
    final button = menu == null
        ? _BarIconButton(
            icon: item.icon!,
            title: item.title,
            onPressed: item.onPressed,
            badge: item.badge,
            selected: item.selected,
          )
        : MenuButton(
            items: menu,
            build: (context, open) => _BarIconButton(
              icon: item.icon!,
              title: item.title,
              onPressed: open,
              badge: item.badge,
            ),
          );
    return button;
  }
}

class _BarIconButton extends StatelessWidget {
  const _BarIconButton({
    required this.icon,
    required this.title,
    required this.onPressed,
    this.badge = false,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onPressed;
  final bool badge;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Tooltip(
      content: title,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Button.icon(
            icon: Icon(icon),
            onPressed: onPressed,
            semanticsLabel: title,
            elevated: true,
            shape: .circle,
            size: .small,
            variant: selected ? ButtonVariant.primary : ButtonVariant.secondary,
          ),
          if (badge)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: cs.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bar items shown horizontally in place, or, when bars are vertical, in the
/// vertical bar column along the [VerticalBarEdge].
///
/// Place this where the actions would go in a horizontal bar (for example in
/// an app bar's trailing row). When bars are vertical it renders nothing in
/// place and draws a [VerticalToolbar] in the column reserved by the nearest
/// [VerticalBarPage].
class BarActions extends StatelessWidget {
  /// Creates bar actions.
  const BarActions({
    required this.items,
    this.overflow = const [],
    this.compression = BarCompression.navigation,
    super.key,
  });

  /// The bar's items.
  final List<BarItem> items;

  /// Extra overflow menu entries.
  final List<MenuItem> overflow;

  /// How the bars give way when there isn't room for everything.
  final BarCompression compression;

  @override
  Widget build(BuildContext context) {
    final column = VerticalBarPage.columnOf(context);
    if (column == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Spacing.s2,
        children: [
          for (final item in items)
            if (item.role != BarItemRole.navigation)
              item.horizontal ?? _defaultHorizontal(item),
          if (overflow.isNotEmpty) OverflowMenuButton(items: overflow),
        ],
      );
    }
    return _VerticalBarPortal(
      column: column,
      compression: compression,
      child: VerticalToolbar(items: items, overflow: overflow),
    );
  }

  static Widget _defaultHorizontal(BarItem item) {
    final icon = item.icon;
    if (icon == null) {
      return Button(
        label: Text(item.title),
        onPressed: item.onPressed,
        size: .small,
        variant: ButtonVariant.secondary,
      );
    }
    return _VerticalBarButton(item: item);
  }
}

class _VerticalBarPortal extends StatefulWidget {
  const _VerticalBarPortal({
    required this.column,
    required this.compression,
    required this.child,
  });

  final VerticalBarColumn column;
  final BarCompression compression;
  final Widget child;

  @override
  State<_VerticalBarPortal> createState() => _VerticalBarPortalState();
}

class _VerticalBarPortalState extends State<_VerticalBarPortal> {
  final _controller = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    _controller.show();
    _requestCompression();
  }

  @override
  void didUpdateWidget(_VerticalBarPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.compression != widget.compression ||
        oldWidget.column != widget.column) {
      _requestCompression();
    }
  }

  /// Task-focused bars ask the tab bar to minimize; it stays minimized while
  /// any bar on screen is task-focused.
  void _requestCompression() {
    final compression = widget.column.tabBarCompression;
    if (compression == null) return;
    final task = widget.compression == BarCompression.task;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) compression.request(this, task: task);
    });
  }

  @override
  void dispose() {
    final compression = widget.column.tabBarCompression;
    if (compression != null) {
      // The shell may be rebuilding; update it after this frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        compression.request(this, task: false);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final column = widget.column;
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) => Positioned(
        left: column.edge == VerticalBarEdge.left ? 0 : null,
        right: column.edge == VerticalBarEdge.right ? 0 : null,
        top: column.top,
        bottom: column.bottom,
        // Centred on the system's control axis, which may sit off the
        // column's centre.
        width: column.axisInset * 2,
        child: Align(
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ),
    );
  }
}

/// The geometry of the vertical bar column on a page, in the coordinates of
/// the page's [Overlay].
@immutable
class VerticalBarColumn {
  /// Creates a vertical bar column.
  const VerticalBarColumn({
    required this.edge,
    required this.width,
    required this.top,
    required this.bottom,
    double? axisInset,
    this.tabBarCompression,
  }) : axisInset = axisInset ?? width / 2;

  /// Which edge the column runs along.
  final VerticalBarEdge edge;

  /// The width of the column, measured from the screen edge.
  final double width;

  /// How far from the screen edge controls are centred: the system's control
  /// axis, so they line up with the status bar and camera.
  final double axisInset;

  /// Where the toolbar starts.
  final double top;

  /// How much of the column's bottom is taken by other bars (the tab bar).
  final double bottom;

  /// Task-focused screens ask the tab bar to minimize through this.
  final TabBarCompression? tabBarCompression;

  @override
  bool operator ==(Object other) =>
      other is VerticalBarColumn &&
      other.edge == edge &&
      other.width == width &&
      other.axisInset == axisInset &&
      other.top == top &&
      other.bottom == bottom &&
      other.tabBarCompression == tabBarCompression;

  @override
  int get hashCode =>
      Object.hash(edge, width, axisInset, top, bottom, tabBarCompression);
}

/// Collects task-focused screens' requests to minimize the tab bar.
///
/// Owned by the tab shell; [minimized] is true while any bar on screen is
/// task-focused ([BarCompression.task]).
class TabBarCompression extends ChangeNotifier {
  final Set<Object> _taskBars = {};
  bool _disposed = false;

  /// Whether the tab bar should minimize.
  bool get minimized => _taskBars.isNotEmpty;

  /// Records whether the bar identified by [owner] is task-focused.
  void request(Object owner, {required bool task}) {
    if (_disposed) return;
    final changed = task ? _taskBars.add(owner) : _taskBars.remove(owner);
    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// The space a tab bar takes at the bottom of the vertical bar column, and
/// how screens ask it to minimize. Provided by the tab shell.
class VerticalTabBarReservation extends InheritedWidget {
  /// Creates a tab bar reservation.
  const VerticalTabBarReservation({
    required this.extent,
    required this.compression,
    required super.child,
    super.key,
  });

  /// The height the tab bar occupies at the bottom of the column.
  final double extent;

  /// Task-focused screens ask the tab bar to minimize through this.
  final TabBarCompression compression;

  /// The nearest reservation, if any.
  static VerticalTabBarReservation? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VerticalTabBarReservation>();

  @override
  bool updateShouldNotify(VerticalTabBarReservation oldWidget) =>
      extent != oldWidget.extent || compression != oldWidget.compression;
}

/// Wraps a page so that, when bars are vertical, its content stays clear of
/// the vertical bar column and its [BarActions] draw into that column.
///
/// When bars are horizontal this does nothing.
class VerticalBarPage extends StatelessWidget {
  /// Creates a vertical bar page.
  const VerticalBarPage({required this.child, super.key});

  /// The page.
  final Widget child;

  /// The column for [BarActions] under [context], or null when bars are
  /// horizontal there.
  static VerticalBarColumn? columnOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_VerticalBarColumnScope>()
      ?.column;

  /// The width of the vertical bar column along [edge]: the system's own
  /// column (which holds the camera and status bar), or at least
  /// [VerticalBarEdge.barExtent], so controls keep a margin from the edge of
  /// the display.
  static double columnWidth(MediaQueryData media, VerticalBarEdge edge) {
    final systemInset = edge == VerticalBarEdge.left
        ? media.padding.left
        : media.padding.right;
    return math.max(systemInset, VerticalBarEdge.barExtent);
  }

  /// How far from the screen edge the controls in the column along [edge]
  /// are centred: the axis the system reports through
  /// [VerticalBarEdgeScope.axisInset], or the middle of the column.
  ///
  /// Wrap a control in a box twice this wide, anchored to the edge, and
  /// centre it there to line it up with the system's own controls.
  static double axisInset(BuildContext context, VerticalBarEdge edge) {
    final width = columnWidth(MediaQuery.of(context), edge);
    final reported = VerticalBarEdgeScope.maybeOf(context)?.axisInset;
    if (reported == null) return width / 2;
    // Keep a whole control inside the column.
    const half = VerticalToolbar.itemExtent / 2;
    return reported.clamp(half, width - half);
  }

  /// How far from the top (or bottom) of the display the first (or last)
  /// control, centred [axisInset] from the screen edge, must sit to stay
  /// inside a rounded corner of [radius] with a small gap: the control's curve
  /// follows the display's, rather than running into it.
  static double cornerClearance(double radius, double axisInset) {
    const controlRadius = VerticalToolbar.itemExtent / 2;
    const gap = Spacing.s2;
    final reach = radius - controlRadius - gap;
    final inset = radius - axisInset;
    if (radius <= 0 || inset <= 0) return 0;
    if (reach <= inset) return radius - controlRadius;
    final center = radius - math.sqrt(reach * reach - inset * inset);
    return math.max(0, center - controlRadius);
  }

  /// The space to leave below the last control in the column along [edge].
  static double bottomInset(MediaQueryData media, BuildContext context) {
    final scope = VerticalBarEdgeScope.maybeOf(context);
    final edge = scope?.edge ?? VerticalBarEdge.none;
    return math.max(
      media.padding.bottom + Spacing.s2,
      cornerClearance(scope?.bottomCornerRadius ?? 0, axisInset(context, edge)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final edge = VerticalBarEdgeScope.of(context);
    final column = edge.isVertical ? _column(context, edge) : null;
    final width = column?.width ?? 0;

    // The same structure whether bars are vertical or not, so the page keeps
    // its state when the device rotates or opens and bars change direction.
    return _VerticalBarColumnScope(
      column: column,
      child: Padding(
        padding: switch (edge) {
          VerticalBarEdge.left => EdgeInsets.only(left: width),
          VerticalBarEdge.right => EdgeInsets.only(right: width),
          VerticalBarEdge.none => EdgeInsets.zero,
        },
        child: MediaQuery.removePadding(
          context: context,
          removeLeft: edge == VerticalBarEdge.left,
          removeRight: edge == VerticalBarEdge.right,
          child: child,
        ),
      ),
    );
  }

  VerticalBarColumn _column(BuildContext context, VerticalBarEdge edge) {
    final media = MediaQuery.of(context);
    final reservation = VerticalTabBarReservation.maybeOf(context);
    // The system reserves the column in the safe area (it holds the camera
    // and status bar); bars go in the same column, below them.
    final width = columnWidth(media, edge);
    final columnRect = edge == VerticalBarEdge.left
        ? Rect.fromLTWH(0, 0, width, media.size.height)
        : Rect.fromLTWH(media.size.width - width, 0, width, media.size.height);
    var top = media.padding.top;
    for (final occlusion in DisplayRegions.occlusions(media)) {
      if (occlusion.overlaps(columnRect) &&
          occlusion.center.dy < media.size.height / 2) {
        top = math.max(top, occlusion.bottom);
      }
    }
    final scope = VerticalBarEdgeScope.maybeOf(context);
    final axis = axisInset(context, edge);
    return VerticalBarColumn(
      edge: edge,
      width: width,
      axisInset: axis,
      top: math.max(
        top + Spacing.s2,
        cornerClearance(scope?.topCornerRadius ?? 0, axis),
      ),
      bottom: reservation != null
          ? bottomInset(media, context) + reservation.extent
          : bottomInset(media, context),
      tabBarCompression: reservation?.compression,
    );
  }
}

class _VerticalBarColumnScope extends InheritedWidget {
  const _VerticalBarColumnScope({required this.column, required super.child});

  final VerticalBarColumn? column;

  @override
  bool updateShouldNotify(_VerticalBarColumnScope oldWidget) =>
      column != oldWidget.column;
}

/// Hides the vertical bar column from a subtree, so its [BarActions] stay
/// horizontal next to the content they affect — for example the leading pane
/// of a two-pane layout, whose controls belong above that pane rather than
/// on the side.
class HorizontalBarScope extends StatelessWidget {
  /// Creates a horizontal bar scope.
  const HorizontalBarScope({
    required this.child,
    this.enabled = true,
    super.key,
  });

  /// Whether to keep the subtree's bars horizontal. Toggle this rather than
  /// adding or removing the scope, so the subtree keeps its state.
  final bool enabled;

  /// The subtree.
  final Widget child;

  @override
  Widget build(BuildContext context) => _VerticalBarColumnScope(
    column: enabled ? null : VerticalBarPage.columnOf(context),
    child: child,
  );
}
