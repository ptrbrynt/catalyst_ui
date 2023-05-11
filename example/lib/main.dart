import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:example/badges/badges_example.dart';
import 'package:example/theme.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalystApp(
      theme: exampleTheme,
      child: Container(
        color: const Color(0xFFFFFFFF),
        alignment: Alignment.center,
        child: const BadgesExample(),
      ),
    );
  }
}
