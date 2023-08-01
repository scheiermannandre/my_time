import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/global/globals.dart';

/// Widget for the project name field.
class ProjectNameField extends StatelessWidget {
  /// Creates a [ProjectNameField].
  const ProjectNameField({required this.projectNameController, super.key});

  /// The controller for the project name field.
  final TextEditingController projectNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.loc.addProjectScreenNameFieldLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextField(
          controller: projectNameController,
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
