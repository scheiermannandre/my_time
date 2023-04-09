import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectNameField extends StatelessWidget {
  final TextEditingController projectNameController;

  const ProjectNameField({super.key, required this.projectNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.addProjectScreenNameFieldLabel,
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
