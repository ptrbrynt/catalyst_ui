import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

import 'pages/home.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => WidgetsApp(
        debugShowCheckedModeBanner: false,
        color: const Color(0xFF6366F1),
        builder: (context, child) => CatalystProvider(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          child: child!,
        ),
        onGenerateRoute: (settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            final args = settings.arguments;
            if (args is Widget) return args;
            return const HomePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: const Cubic(0.2, 0, 0, 1))).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        ),
        initialRoute: '/',
      ),
    );
  }
}
