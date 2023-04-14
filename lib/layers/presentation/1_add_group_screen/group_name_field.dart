import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/global/globals.dart';

class GroupNameField extends StatelessWidget {
  final TextEditingController groupNameController;

  const GroupNameField({super.key, required this.groupNameController});
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
