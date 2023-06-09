import 'package:catalyst_ui/catalyst_ui.dart';

/// {@template styleable_widget}
/// A widget that can be customised with custom styles.
/// {@template styleable_widget}
abstract class StyleableWidget extends StatelessWidget {
  /// {@macro styleable_widget}
  const StyleableWidget({required this.styles, super.key});

  /// The styles to apply to this widget.
  final List<dynamic> styles;
}

/// {@template styleable_stateful_widget}
/// A stateful widget that can be customised with custom styles.
/// {@template styleable_stateful_widget}
abstract class StyleableStatefulWidget extends StatefulWidget {
  /// {@macro styleable_stateful_widget}
  const StyleableStatefulWidget({required this.styles, super.key});

  /// The styles to apply to this widget.
  final List<dynamic> styles;
}
