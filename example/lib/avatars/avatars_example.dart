import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:example/theme.dart';

class AvatarsExample extends StatelessWidget {
  const AvatarsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Avatar.network(
              'https://i.pravatar.cc/300',
              styles: const [AvatarStyles.small],
            ),
            Avatar.network('https://i.pravatar.cc/300'),
            Avatar.network(
              'https://i.pravatar.cc/300',
              styles: const [AvatarStyles.large],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Avatar.network(
              'https://i.pravatar.cc/300',
              styles: const [AvatarStyles.circle, AvatarStyles.small],
            ),
            Avatar.network(
              'https://i.pravatar.cc/300',
              styles: const [AvatarStyles.circle],
            ),
            Avatar.network(
              'https://i.pravatar.cc/300',
              styles: const [AvatarStyles.circle, AvatarStyles.large],
            ),
          ],
        ),
      ],
    );
  }
}
