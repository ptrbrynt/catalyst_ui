import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

/// Styles for [FormLayout]
enum FormLayoutStyle {
  /// Groups are displayed in a vertical column.
  ///
  /// Title and subtitle are displayed at the top, followed by the fields.
  stacked,

  /// Groups are displayed with the title and subtitle on the left side, and
  /// the fields on the right side.
  twoColumn,

  /// Similar to [twoColumn] except the fields are wrapped in a [Card].
  twoColumnWithCards,
}

/// Defines the contents of a single group in a [FormLayout].
@immutable
class FormLayoutGroup {
  /// Creates a [FormLayoutGroup]
  const FormLayoutGroup({
    required this.title,
    required this.fields,
    this.subtitle,
  });

  /// The title of the group, typically a [Text] widget
  final Widget title;

  /// The optionsl subtitle of the group, typically a [Text] widget
  final Widget? subtitle;

  /// The form fields to display in this group. Typically the following
  /// widgets are used (but any widget is supported):
  ///
  /// * [TextField]
  /// * [Radio]
  /// * [Checkbox]
  final List<Widget> fields;
}

/// Displays a series of [FormLayoutGroups] in a particular layout [style].
class FormLayout extends StatelessWidget {
  /// Creates a [FormLayout]
  const FormLayout({
    required this.style,
    required this.groups,
    required this.footerButtons,
    super.key,
  });

  /// How the [group]s will be laid out
  final FormLayoutStyle style;

  /// The [FormLayoutGroup]s to display
  final List<FormLayoutGroup> groups;

  /// [Widget]s to display at the end of the form.
  ///
  /// Typically [Button]s.
  final List<Widget> footerButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s8),
      decoration: BoxDecoration(
        color:
            style == FormLayoutStyle.twoColumnWithCards
                ? context.colorScheme.subtle
                : context.colorScheme.canvas,
        borderRadius: Radii.lgAll,
        border:
            style == FormLayoutStyle.twoColumnWithCards
                ? BoxBorder.all(color: context.colorScheme.border)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: Spacing.s8,
        children: [
          for (final group in groups) ...[
            _group(context, group),
            const Divider(),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: Spacing.s2,
            children: footerButtons,
          ),
        ],
      ),
    );
  }

  Widget _group(BuildContext context, FormLayoutGroup group) {
    final titles = Column(
      spacing: Spacing.s1,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(style: context.typography.h3, child: group.title),
        if (group.subtitle != null)
          DefaultTextStyle(
            style: context.typography.p3.copyWith(
              color: context.colorScheme.textMuted,
            ),
            child: group.subtitle!,
          ),
      ],
    );
    final fieldsColumn = Column(
      spacing: Spacing.s4,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: group.fields,
    );

    return switch (style) {
      FormLayoutStyle.stacked => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: Spacing.s8,
        children: [titles, fieldsColumn],
      ),
      FormLayoutStyle.twoColumn => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s4,
        children: [Expanded(child: titles), Expanded(child: fieldsColumn)],
      ),
      FormLayoutStyle.twoColumnWithCards => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s4,
        children: [
          Expanded(child: titles),
          Expanded(
            child: Card(
              padding: const EdgeInsets.all(Spacing.s8),
              tone: CardTone.surface,
              child: fieldsColumn,
            ),
          ),
        ],
      ),
    };
  }
}
