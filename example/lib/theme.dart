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
    );

enum AvatarStyles {
  circle,
  small,
  large,
}
