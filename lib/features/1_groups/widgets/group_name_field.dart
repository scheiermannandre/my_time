import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/global/globals.dart';

/// Shows a Labeled Textfield for the group name.
class GroupNameField extends StatelessWidget {
  /// Constructor for the [GroupNameField].
  const GroupNameField({required this.groupNameController, super.key});

  /// Controller for the group name textfield.
  final TextEditingController groupNameController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.loc.addGroupScreenNameFieldLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextField(
          controller: groupNameController,
          cursorColor: GlobalProperties.shadowColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
          ),
        ),
      ],
    );
  }
}
