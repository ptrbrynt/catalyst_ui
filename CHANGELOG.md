# 0.8.0

- **Breaking:** `VerticalBarPage.cornerClearance`'s second argument is now the distance from the screen edge to the control's centre (`axisInset`), not the column width
- Add `VerticalBarEdgeScope.axisInset`: how far from the edge the system centres its own vertical bar controls. Vertical toolbars centre on it, so they line up with the status bar (and, on iPhone Duo's outer display, the camera); without it they centre in the column as before
- Add `VerticalBarColumn.axisInset` and `VerticalBarPage.axisInset()`, for placing other controls (such as a vertical tab bar) on the same axis

# 0.7.1

- Fix broken `README.md`

# 0.7.0

- **Breaking:** `Iconography` now requires `moreIcon`, used for a bar's overflow menu
- Add iPhone Duo support (iOS 27.1), all constraint-driven and inert on other devices:
  - `VerticalBarEdge`, `VerticalBarEdgeScope`, `DisplayRegions` and `AvoidOcclusions` for the hardware bar side, corner radii and reserved display regions
  - `BarItem`, `VerticalToolbar`, `VerticalBarColumn`, `VerticalBarPage`, `OverflowMenuButton`, `TabBarCompression`, `VerticalTabBarReservation` and `HorizontalBarScope` for adaptive horizontal/vertical bars
  - `VerticalTabBar`, the tab bar's vertical form
  - `ArrangementView`, a two-pane split/overlay view that clears the fold, and `SliverGridDelegateWithEvenColumns`
  - `AppBar` gains `items`, `overflow` and compression, and avoids occlusions
  - `MenuButton`, `Select`, `MultiSelect`, `Tooltip` and snackbars avoid reserved regions and the fold
- Fix `AppBar` trailing actions moving to the leading side when there is no leading widget
- Fix `Button`'s hidden loading spinner animating while not loading

# 0.6.0

- **Breaking:** `AppBarAction` is now an abstract class with a concrete `AppBarButton` taking its place. Any widget can now be used as an app bar action.

# 0.5.0

- **Breaking:** Remove `StatCard` — too specific a use-case for a general-purpose component library

# 0.4.2

- Fix `Slider` touch target not registering taps/drags in the padded hit area around the thumb

# 0.4.1

- Fix layout bug in `MultiSelect`

# 0.4.0

- Add `MultiSelect`

# 0.3.0

- Add `DatePicker` and `TimePicker`

# 0.2.7

- Fix Snackbar being obscured by software keyboard

# 0.2.6

- Improve bottom nav tap target size

# 0.2.5

- Replace `AppBar.trailing` with `AppBar.actions` for more consistent design

# 0.2.4

- Reduce minimum tap target size to 44
- Support circular icon buttons

# 0.2.3

- Increase default AppBar text size to 20

# 0.2.2

- Fix sizes of various components to improve accessibility

# 0.2.1

- More accessibility fixes

# 0.2.0

- Fix touch-target-related accessibility issues

# 0.1.11-beta

- Fix more accessibility issues

# 0.1.10-beta

- Fix accessibility issues

# 0.1.9-beta

- Fix callback bug on Slider

# 0.1.8-beta

- Increase height of `BottomNav`

# 0.1.7-beta

- Add ViewInsets to `BottomSheet` bottom padding

# 0.1.6-beta

- Increase `Slider` touch target with invisible vertical hit slop

# 0.1.5-beta

- Auto-determine `MenuButton` dropdown alignment from available screen space

# 0.1.4-beta

- `Card` default tone is now `.surface`
- Add `.antialias` clip behavior to `Card`

# 0.1.3-beta

- Add `IgnorePointer` to `TextField` in read-only mode to ensure the whole widget can be tapped (e.g. when wrapped in a `GestureDetector`)

# 0.1.2-beta

- Add `isDestructive` property to `MenuOption`s

# 0.1.1-beta

- Add start/end scale and min/max selectable bounds to Slider

# 0.1.0-beta

Initial public beta release.
