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
      buttonThemeData: ButtonThemeData(
        height: 36,
        decoration: (state) => BoxDecoration(
          color: switch (state) {
            ButtonState.enabled => const Color(0xFFFF0000),
            ButtonState.disabled => const Color(0xFFEEEEEE),
            ButtonState.pressed => const Color(0xFFDDDDDD),
            ButtonState.hover => const Color(0xFFDDDDDD),
          },
          border: Border.all(
            width: 1,
            color: const Color(0xFF000000),
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            if (state == ButtonState.enabled)
              const BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 2),
                color: Color(0x20000000),
              ),
            if (state == ButtonState.pressed)
              const BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 1),
                color: Color(0x20000000),
              ),
          ],
        ),
        padding: (_) => const EdgeInsets.symmetric(horizontal: 12),
        textStyle: (_) => const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        styles: {
          'circle': (base) => base.copyWith(
                decoration: (state) => const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF0000),
                ),
              ),
          'gradient': (base) => base.copyWith(
                decoration: (state) => base.decoration?.call(state)?.copyWith(
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xFFFF0000),
                          Color(0xFF0000FF),
                        ],
                        stops: switch (state) {
                          ButtonState.hover => [1.0, 0.0],
                          ButtonState.pressed => [0.0, 1.0],
                          ButtonState.disabled => [0.0, 0.0],
                          ButtonState.enabled => [0.0, 1.0],
                        },
                      ),
                    ),
              ),
        },
      ),
    );

enum AvatarStyles {
  circle,
  small,
  large,
}
