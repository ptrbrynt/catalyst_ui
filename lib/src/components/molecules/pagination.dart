import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../atoms/button.dart';

/// A row of page-number buttons with optional ellipsis collapse.
///
/// Pages are zero-indexed. Distant pages are collapsed into `…`
/// separators; the first and last pages are always shown.
///
/// ```dart
/// Pagination(
///   currentPage: _page,
///   pageCount: 12,
///   onChanged: (p) => setState(() => _page = p),
/// )
/// ```
class Pagination extends StatefulWidget {
  /// Creates a pagination control.
  const Pagination({
    required this.currentPage,
    required this.pageCount,
    required this.onChanged,
    super.key,
  });

  /// The zero-based index of the currently active page.
  final int currentPage;

  /// The total number of pages minus one (the last valid index).
  final int pageCount;

  /// Called with the zero-based index of the newly selected page.
  final ValueChanged<int> onChanged;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late List<String> _pages;

  @override
  void initState() {
    super.initState();
    _rebuild();
  }

  @override
  void didUpdateWidget(Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage ||
        widget.pageCount != oldWidget.pageCount) {
      setState(_rebuild);
    }
  }

  void _rebuild() {
    final pages = <String>[];
    for (var i = 0; i <= widget.pageCount; i++) {
      if (i == 0 ||
          i == widget.pageCount ||
          (i - widget.currentPage).abs() <= 1) {
        pages.add('$i');
      } else if (pages.last != '...') {
        pages.add('...');
      }
    }
    _pages = pages;
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;

    return AnimatedSize(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: CatalystSpacing.s1,
        children: [
          Button.icon(
            icon: const Icon(LucideIcons.chevronLeft, size: 16),
            variant: ButtonVariant.ghost,
            size: ButtonSize.small,
            onPressed:
                widget.currentPage > 0
                    ? () => widget.onChanged(widget.currentPage - 1)
                    : null,
          ),
          for (final page in _pages)
            page == '...'
                ? SizedBox(
                  width: CatalystSpacing.s8,
                  child: Center(
                    child: Text(
                      '…',
                      style: TextStyle(
                        fontFamily: context.typography.fontFamily,
                        color: context.colorScheme.textMuted,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                : _buildPageButton(context, int.parse(page)),
          Button.icon(
            icon: const Icon(LucideIcons.chevronRight, size: 16),
            variant: ButtonVariant.ghost,
            size: ButtonSize.small,
            onPressed:
                widget.currentPage < widget.pageCount
                    ? () => widget.onChanged(widget.currentPage + 1)
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(BuildContext context, int p) {
    final isCurrent = p == widget.currentPage;
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        color: isCurrent ? cs.onBrand : cs.text,
        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
        fontSize: 13,
      ),
      child: MouseRegion(
        cursor: isCurrent ? MouseCursor.defer : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isCurrent ? null : () => widget.onChanged(p),
          child: AnimatedContainer(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            width: CatalystSpacing.s8,
            height: CatalystSpacing.s8,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: CatalystRadius.smAll,
              color: isCurrent ? cs.brand : null,
            ),
            child: Text('${p + 1}'),
          ),
        ),
      ),
    );
  }
}
