import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class ProjectNameField extends StatelessWidget {
  final TextEditingController projectNameController;

  const ProjectNameField({super.key, required this.projectNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Project Name",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
