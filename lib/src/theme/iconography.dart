import 'package:flutter/widgets.dart';

/// Defines common icons used throughout the component library.
///
/// Because Catalyst UI doesn't come with any pre-packaged icons, you will
/// need to supply your own (e.g. LucideIcons):
///
/// ```dart
/// Iconography(
///   checkIcon: LucideIcons.check,
///   backIcon: LucideIcons.chevronLeft,
///   // etc.
/// );
/// ```
class Iconography {
  /// Creates an [Iconography] set.
  const Iconography({
    required this.checkIcon,
    required this.backIcon,
    required this.forwardIcon,
    required this.expandIcon,
    required this.collapseIcon,
    required this.closeIcon,
    required this.removeIcon,
    required this.alertIcon,
  });

  /// Icon used as checkmarks in components such as Checkboxes
  final IconData checkIcon;

  /// Icon used in back buttons.
  ///
  /// Typically a left-facing chevron or arrow.
  final IconData backIcon;

  /// Icon used to indicate forward navigation.
  ///
  /// Typically a right-facing chevron.
  final IconData forwardIcon;

  /// Icon used to indicate an expandable component, such as a Select.
  ///
  /// Typically a downward chevron.
  final IconData expandIcon;

  /// Inverse of [expandIcon], used to indicate a collapsible component.
  ///
  /// Typically an upward chevron.
  final IconData collapseIcon;

  /// Icon used on close buttons.
  ///
  /// Typically an X
  final IconData closeIcon;

  /// Icon used on removable components such as removable Chips.
  ///
  /// Typically an X.
  final IconData removeIcon;

  /// Icon used in error states.
  final IconData alertIcon;
}
