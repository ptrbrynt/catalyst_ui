import 'package:flutter/widgets.dart';

import 'showcases/atoms.dart';
import 'showcases/molecules.dart';
import 'showcases/organisms.dart';

class ComponentEntry {
  const ComponentEntry({
    required this.name,
    required this.category,
    required this.description,
    required this.build,
  });

  final String name;
  final String category;
  final String description;
  final Widget Function() build;
}

final List<ComponentEntry> registry = [
  // Atoms
  ComponentEntry(
    name: 'Avatar',
    category: 'Atoms',
    description: 'User avatar with initials or image',
    build: () => const AvatarShowcase(),
  ),
  ComponentEntry(
    name: 'AvatarStack',
    category: 'Atoms',
    description: 'Overlapping group of avatars',
    build: () => const AvatarStackShowcase(),
  ),
  ComponentEntry(
    name: 'Badge',
    category: 'Atoms',
    description: 'Status label with tone variants',
    build: () => const BadgeShowcase(),
  ),
  ComponentEntry(
    name: 'Button',
    category: 'Atoms',
    description: 'Interactive tap target with variants',
    build: () => const ButtonShowcase(),
  ),
  ComponentEntry(
    name: 'Checkbox',
    category: 'Atoms',
    description: 'Binary selection control',
    build: () => const CheckboxShowcase(),
  ),
  ComponentEntry(
    name: 'Chip',
    category: 'Atoms',
    description: 'Toggleable tag or filter',
    build: () => const ChipShowcase(),
  ),
  ComponentEntry(
    name: 'Divider',
    category: 'Atoms',
    description: 'Visual separator',
    build: () => const DividerShowcase(),
  ),
  ComponentEntry(
    name: 'ProgressBar',
    category: 'Atoms',
    description: 'Determinate progress indicator',
    build: () => const ProgressBarShowcase(),
  ),
  ComponentEntry(
    name: 'Radio',
    category: 'Atoms',
    description: 'Single-choice selection control',
    build: () => const RadioShowcase(),
  ),
  ComponentEntry(
    name: 'Slider',
    category: 'Atoms',
    description: 'Continuous value selector',
    build: () => const SliderShowcase(),
  ),
  ComponentEntry(
    name: 'Spinner',
    category: 'Atoms',
    description: 'Indeterminate loading indicator',
    build: () => const SpinnerShowcase(),
  ),
  ComponentEntry(
    name: 'StatusDot',
    category: 'Atoms',
    description: 'Presence or status indicator',
    build: () => const StatusDotShowcase(),
  ),
  ComponentEntry(
    name: 'Switch',
    category: 'Atoms',
    description: 'Toggle on/off control',
    build: () => const SwitchShowcase(),
  ),
  // Molecules
  ComponentEntry(
    name: 'ActionTile',
    category: 'Molecules',
    description: 'Icon-driven list item with action',
    build: () => const ActionTileShowcase(),
  ),
  ComponentEntry(
    name: 'Alert',
    category: 'Molecules',
    description: 'Contextual feedback banner',
    build: () => const AlertShowcase(),
  ),
  ComponentEntry(
    name: 'Breadcrumb',
    category: 'Molecules',
    description: 'Hierarchical navigation path',
    build: () => const BreadcrumbShowcase(),
  ),
  ComponentEntry(
    name: 'Card',
    category: 'Molecules',
    description: 'Elevated content container',
    build: () => const CardShowcase(),
  ),
  ComponentEntry(
    name: 'ListItem',
    category: 'Molecules',
    description: 'Row in a list',
    build: () => const ListItemShowcase(),
  ),
  ComponentEntry(
    name: 'Pagination',
    category: 'Molecules',
    description: 'Page navigation controls',
    build: () => const PaginationShowcase(),
  ),
  ComponentEntry(
    name: 'SegmentedControl',
    category: 'Molecules',
    description: 'Inline option picker',
    build: () => const SegmentedControlShowcase(),
  ),
  ComponentEntry(
    name: 'Select',
    category: 'Molecules',
    description: 'Dropdown selection field',
    build: () => const SelectShowcase(),
  ),
  ComponentEntry(
    name: 'MultiSelect',
    category: 'Molecules',
    description: 'Multi-value dropdown selection field',
    build: () => const MultiSelectShowcase(),
  ),
  ComponentEntry(
    name: 'Snackbar',
    category: 'Molecules',
    description: 'Transient notification toast',
    build: () => const SnackbarShowcase(),
  ),
  ComponentEntry(
    name: 'Stepper',
    category: 'Molecules',
    description: 'Multi-step progress indicator',
    build: () => const StepperShowcase(),
  ),
  ComponentEntry(
    name: 'Tabs',
    category: 'Molecules',
    description: 'Horizontal tab navigation',
    build: () => const TabsShowcase(),
  ),
  ComponentEntry(
    name: 'TextField',
    category: 'Molecules',
    description: 'Text input field',
    build: () => const TextFieldShowcase(),
  ),
  ComponentEntry(
    name: 'Tooltip',
    category: 'Molecules',
    description: 'Contextual label on hover/press',
    build: () => const TooltipShowcase(),
  ),
  ComponentEntry(
    name: 'ValueRow',
    category: 'Molecules',
    description: 'Label–value display pair',
    build: () => const ValueRowShowcase(),
  ),
  // Organisms
  ComponentEntry(
    name: 'AppBar',
    category: 'Organisms',
    description: 'Top application bar',
    build: () => const AppBarShowcase(),
  ),
  ComponentEntry(
    name: 'BottomNav',
    category: 'Organisms',
    description: 'Bottom tab navigation bar',
    build: () => const BottomNavShowcase(),
  ),
  ComponentEntry(
    name: 'BottomSheet',
    category: 'Organisms',
    description: 'Slide-up overlay panel',
    build: () => const BottomSheetShowcase(),
  ),
  ComponentEntry(
    name: 'Drawer',
    category: 'Organisms',
    description: 'Side panel overlay',
    build: () => const DrawerShowcase(),
  ),
  ComponentEntry(
    name: 'EmptyState',
    category: 'Organisms',
    description: 'Empty content placeholder',
    build: () => const EmptyStateShowcase(),
  ),
  ComponentEntry(
    name: 'ErrorState',
    category: 'Organisms',
    description: 'Error feedback screen',
    build: () => const ErrorStateShowcase(),
  ),
  ComponentEntry(
    name: 'FormLayout',
    category: 'Organisms',
    description: 'Structured form container',
    build: () => const FormLayoutShowcase(),
  ),
  ComponentEntry(
    name: 'Modal',
    category: 'Organisms',
    description: 'Centred dialog overlay',
    build: () => const ModalShowcase(),
  ),
  ComponentEntry(
    name: 'RadioGroup',
    category: 'Organisms',
    description: 'Group of radio options',
    build: () => const RadioGroupShowcase(),
  ),
  ComponentEntry(
    name: 'SideNav',
    category: 'Organisms',
    description: 'Vertical navigation rail',
    build: () => const SideNavShowcase(),
  ),
  ComponentEntry(
    name: 'TopBar',
    category: 'Organisms',
    description: 'Horizontal navigation bar',
    build: () => const TopBarShowcase(),
  ),
];
