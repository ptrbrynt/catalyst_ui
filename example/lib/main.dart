import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:example/routes.dart';
import 'package:example/theme.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp.router(
      builder: (context, child) => CatalystTheme(
        data: exampleTheme,
        child: child!,
      ),
      color: const Color(0xFFFF0000),
      routerConfig: router,
    );
  }
}
