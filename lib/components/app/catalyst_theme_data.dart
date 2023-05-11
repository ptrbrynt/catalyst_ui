// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalyst_ui/catalyst_ui.dart';

export 'theme_styles.dart';

@immutable
class CatalystThemeData {
  const CatalystThemeData({
    this.avatarThemeData = const AvatarThemeData(),
  });
  final AvatarThemeData avatarThemeData;

  @override
  bool operator ==(covariant CatalystThemeData other) {
    if (identical(this, other)) return true;

    return other.avatarThemeData == avatarThemeData;
  }

  @override
  int get hashCode => avatarThemeData.hashCode;
}
