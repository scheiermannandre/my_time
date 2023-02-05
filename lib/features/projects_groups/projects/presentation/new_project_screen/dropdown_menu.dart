import 'package:flutter/material.dart';
import 'package:my_time/features/projects_groups/projects/presentation/new_project_screen/styled_text_form_field.dart';
import 'package:my_time/global/globals.dart';

class DropDownMenuTextFormField extends StatefulWidget {
  final List<String> items;
  final TextEditingController dropDownSelectionController;
  final String label;
  final Function(String?)? validator;
  final Function(String?)? onSaved;

  const DropDownMenuTextFormField(
      {super.key,
      required this.items,
      required this.dropDownSelectionController,
      required this.label,
      this.onSaved,
      this.validator});

  @override
  State<DropDownMenuTextFormField> createState() =>
      _DropDownMenuTextFormFieldState();
}

class _DropDownMenuTextFormFieldState extends State<DropDownMenuTextFormField> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          padding: const EdgeInsets.only(top: 52),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: GlobalProperties.secondaryAccentColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          duration: const Duration(milliseconds: 200),
          height: !expand ? 0 : 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          widget.dropDownSelectionController.text =
                              widget.items[index];
                          expand = !expand;
                        });
                      },
                      contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      title: Text(
                        widget.items[index],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        StyledTextFormField(
          controller: widget.dropDownSelectionController,
          label: widget.label,
          readOnly: true,
          focusNode: AlwaysDisabledFocusNode(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                expand = !expand;
              });
            },
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
          ),
          onSaved: (newValue) => widget.onSaved!(newValue),
          validator: (value) => widget.validator!(value),
          onTap: () {
            setState(() {
              expand = !expand;
            });
          },
        ),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
