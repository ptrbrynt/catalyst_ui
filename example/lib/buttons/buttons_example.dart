import 'package:catalyst_ui/catalyst_ui.dart';

class ButtonsExample extends StatelessWidget {
  const ButtonsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          label: 'Button',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        Button(
          styles: const ['gradient'],
          label: 'Gradient',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        const Button(
          label: 'disabled',
        ),
        const SizedBox(height: 16),
        Button(
          icon: const Text('C'),
          styles: const ['circle'],
          onPressed: () {},
        ),
      ],
    );
  }
}
