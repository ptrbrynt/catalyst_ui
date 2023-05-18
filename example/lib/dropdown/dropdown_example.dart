import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration.dart';
import 'package:line_icons/line_icons.dart';

class DropdownExample extends StatefulWidget {
  const DropdownExample({super.key});

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  _ExampleItem? _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Input(
            decoration: const InputDecoration(
              trailingIcon: Icon(LineIcons.chevronDown),
            ),
            child: Dropdown<_ExampleItem>(
              items: _ExampleItem.values,
              itemLabelBuilder: (item) => item.label,
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ),
          Input(
            decoration: const InputDecoration(
              trailingIcon: Icon(LineIcons.chevronCircleDown),
              leadingAddOn: 'Hi',
              hintText: 'Pick an item',
            ),
            child: Dropdown<_ExampleItem>(
              items: _ExampleItem.values,
              itemLabelBuilder: (item) => item.label,
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _ExampleItem {
  item1("Item 1"),
  item2("Item 2"),
  item3("Item 3");

  const _ExampleItem(this.label);

  final String label;
}
