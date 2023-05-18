import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:example/dropdown/dropdown_example.dart';
import 'package:go_router/go_router.dart';

GoRouter get router => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Container(
            color: const Color(0xFFFFFFFF),
            alignment: Alignment.center,
            child: const DropdownExample(),
          ),
        ),
      ],
    );
