/// A flexible, theme-driven UI component library for Flutter.
///
/// No Material or Cupertino dependency. All design tokens — colours,
/// typography, spacing, radius, motion, and shadows — are fully
/// customisable via [CatalystThemeData]. Component variants (e.g.
/// [ButtonVariant], [ChipVariant], [BadgeVariant]) are abstract classes
/// that you can subclass to define your own styles.
///
/// ## Quick start
///
/// ```dart
/// import 'package:catalyst_ui/catalyst_ui.dart';
///
/// CatalystTheme(
///   data: CatalystThemeData.light(
///     fontFamily: 'Inter',
///     colorScheme: const CatalystColorScheme.light().copyWith(
///       brand: Color(0xFF7C3AED),
///       brandSoft: Color(0xFFEDE9FE),
///     ),
///   ),
///   child: MyApp(),
/// )
/// ```
///
/// ## Custom button variant
///
/// ```dart
/// class OutlineButtonVariant extends ButtonVariant {
///   const OutlineButtonVariant();
///
///   @override
///   ButtonVariantStyle resolve(CatalystColorScheme cs) => ButtonVariantStyle(
///     backgroundColor: Colors.transparent,
///     foregroundColor: cs.brand,
///     borderColor: cs.brand,
///   );
/// }
/// ```
library;

// Components
export 'src/components/atoms/atoms.dart';
export 'src/components/molecules/molecules.dart';
export 'src/components/organisms/organisms.dart';

// Theme
export 'src/theme/color_scheme.dart';
export 'src/theme/extensions.dart';
export 'src/theme/motion.dart';
export 'src/theme/shadows.dart';
export 'src/theme/theme.dart';
export 'src/theme/theme_data.dart';
export 'src/theme/typography.dart';

// Tokens
export 'src/tokens/tokens.dart';

// Utils
export 'src/utils/utils.dart';
