import 'package:catalyst_ui/catalyst_ui.dart';

CatalystThemeData get exampleTheme => CatalystThemeData(
      avatarThemeData: AvatarThemeData(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(width: 2),
        shape: BoxShape.rectangle,
        backgroundColor: const Color(0xFF000000),
        styles: {
          AvatarStyles.circle: (base) => base.copyWith(shape: BoxShape.circle),
          AvatarStyles.small: (base) => base.copyWith(
                size: AvatarThemeData.defaultSize / 2,
              ),
          AvatarStyles.large: (base) => base.copyWith(
                size: AvatarThemeData.defaultSize * 2,
              ),
        },
      ),
      badgeThemeData: BadgeThemeData(
        backgroundColor: const Color(0x20000000),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(color: Color(0xFF000000), fontSize: 12),
        outlined: true,
        styles: {
          'error': (base) => base.copyWith(
                backgroundColor: const Color(0xFFFF0000),
                textStyle: base.textStyle.copyWith(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
          'pill': (base) => base.copyWith(
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                textStyle: base.textStyle.copyWith(fontSize: 16),
              ),
        },
      ),
    );

enum AvatarStyles {
  circle,
  small,
  large,
}
