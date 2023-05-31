import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration_theme.dart';

CatalystThemeData get exampleTheme => CatalystThemeData(
      textThemeData: const TextThemeData(
        defaultStyle: TextStyle(color: Color(0xFF000000)),
      ),
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
          color: state.contains(ButtonState.disabled)
              ? const Color(0xFFEEEEEE)
              : state.contains(ButtonState.pressed)
                  ? const Color(0xFFDDDDDD)
                  : state.contains(ButtonState.hover)
                      ? const Color(0xFFDDDDDD)
                      : const Color(0xFFFF0000),
          border: Border.all(
            width: 1,
            color: const Color(0xFF000000),
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            if (state.contains(ButtonState.enabled))
              const BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 2),
                color: Color(0x20000000),
              )
            else if (state.contains(ButtonState.pressed))
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
                        stops: state.contains(ButtonState.disabled)
                            ? [0.0, 0.0]
                            : state.contains(ButtonState.pressed)
                                ? [0.0, 1.0]
                                : [0.5, 1.0],
                      ),
                    ),
              ),
        },
      ),
      inputDecorationThemeData: InputDecorationThemeData(
        boxDecoration: (state) => BoxDecoration(
          border: Border.all(
            color: state.contains(InputState.error)
                ? const Color(0xFFFF0000)
                : state.contains(InputState.focused)
                    ? const Color(0xFF0000FF).withOpacity(0.5)
                    : state.contains(InputState.enabled)
                        ? const Color(0xFF000000).withOpacity(0.2)
                        : const Color(0xFF000000).withOpacity(0.1),
            width: 1.5,
          ),
          color: state.contains(InputState.disabled)
              ? const Color(0xFFEEEEEE).withOpacity(0.5)
              : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        placeholderStyle: (_) => TextStyle(
          color: const Color(0xFF000000).withOpacity(0.2),
        ),
        hintStyle: (_) => TextStyle(
          color: const Color(0xFF000000).withOpacity(0.5),
        ),
        errorStyle: (_) => const TextStyle(
            color: Color(0xFFFF0000), fontWeight: FontWeight.w500),
        leadingAddOnStyle: (_) => TextStyle(
          color: const Color(0xFF000000).withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        trailingAddOnStyle: (_) => TextStyle(
          color: const Color(0xFF000000).withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        trailingIconTheme: (_) => const IconThemeData(size: 16),
        leadingIconTheme: (_) => const IconThemeData(size: 16),
      ),
      dropdownThemeData: DropdownThemeData(
        maxDropdownWidth: 150,
        dropdownItemBuilder: (context, label) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(label),
          );
        },
        popupDecoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

enum AvatarStyles {
  circle,
  small,
  large,
}
