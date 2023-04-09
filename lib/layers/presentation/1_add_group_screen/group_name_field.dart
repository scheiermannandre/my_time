import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupNameField extends StatelessWidget {
  final TextEditingController groupNameController;

  const GroupNameField({super.key, required this.groupNameController});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.addGroupScreenNameFieldLabel,
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
