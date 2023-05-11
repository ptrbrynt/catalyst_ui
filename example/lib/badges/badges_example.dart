import 'package:catalyst_ui/catalyst_ui.dart';

class BadgesExample extends StatelessWidget {
  const BadgesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Badge(
          child: Text("Badge"),
        ),
        SizedBox(height: 12),
        Badge(
          styles: ['error'],
          child: Text("Badge"),
        ),
        SizedBox(height: 12),
        Badge(
          styles: ['pill'],
          child: Text("Badge"),
        ),
        SizedBox(height: 12),
        Badge(
          styles: ['pill', 'error'],
          child: Text("Badge"),
        ),
      ],
    );
  }
}
