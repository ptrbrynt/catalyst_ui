/// A function which takes a theme and returns a modified theme.
typedef Style<T> = T Function(T base);

/// {@template styleable}
/// Can be extended to create a theme which can be customized with styles.
/// {@endtemplate}
abstract class Styleable<T> {
  /// {@macro styleable}
  const Styleable({
    required this.styles,
  });

  /// Defines the styles which can be applied to this theme.
  final Map<dynamic, Style<T>> styles;

  /// Returns a new instance of this theme with the given styles applied.
  T forStyles(List<dynamic> styles) {
    var styled = this as T;
    for (final style in styles) {
      if (this.styles.containsKey(style)) {
        styled = this.styles[style]!(styled);
      }
    }
    return styled;
  }
}
