import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:example/theme.dart';

class AvatarsExample extends StatelessWidget {
  const AvatarsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
              styles: [AvatarStyles.small],
            ),
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
            ),
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
              styles: [AvatarStyles.large],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
              styles: [AvatarStyles.circle, AvatarStyles.small],
            ),
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
              styles: [AvatarStyles.circle],
            ),
            Avatar(
              NetworkImage('https://i.pravatar.cc/300'),
              styles: [AvatarStyles.circle, AvatarStyles.large],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Avatar(
              null,
              styles: [AvatarStyles.circle, AvatarStyles.small],
              child: Text('TW'),
            ),
            Avatar(
              null,
              styles: [AvatarStyles.circle],
              child: Text('TW'),
            ),
            Avatar(
              null,
              styles: [AvatarStyles.circle, AvatarStyles.large],
              child: Text('TW'),
            ),
          ],
        ),
      ],
    );
  }
}
