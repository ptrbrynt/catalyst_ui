import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration.dart';
import 'package:line_icons/line_icons.dart';

class InputsExample extends StatelessWidget {
  const InputsExample({super.key});

  EditableText _editableText(BuildContext context) => EditableText(
        controller: TextEditingController(),
        focusNode: FocusNode(),
        style: DefaultTextStyle.of(context).style,
        cursorColor: const Color(0xFF000000).withOpacity(0.5),
        backgroundCursorColor: const Color(0xFF000000).withOpacity(0.2),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Input(
            decoration: const InputDecoration(
              leadingIcon: Icon(LineIcons.moneyCheck),
              labelText: 'Price',
              placeholderText: '0.00',
              hintText: 'Enter a price',
              helpText: 'Must be a valid price',
              trailingIcon: Icon(LineIcons.moon),
            ),
            editableText: _editableText(context),
          ),
          const SizedBox(height: 20),
          Input(
            decoration: const InputDecoration(
              labelText: 'Price',
              leadingAddOn: '\$',
              trailingAddOn: 'USD',
              placeholderText: '0.00',
              hintText: 'Enter a price',
              helpText: 'Must be a valid price',
              errorText: 'Invalid price',
            ),
            editableText: _editableText(context),
          ),
          const SizedBox(height: 20),
          Input(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Price',
              leadingAddOn: '\$',
              trailingAddOn: 'USD',
              placeholderText: '0.00',
              hintText: 'Enter a price',
              helpText: 'Must be a valid price',
            ),
            editableText: _editableText(context),
          ),
        ],
      ),
    );
  }
}
