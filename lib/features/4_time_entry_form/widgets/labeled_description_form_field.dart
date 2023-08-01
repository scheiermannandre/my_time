import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/global/globals.dart';

/// A [TextField] with a label.
class LabeledDescriptionFormField extends StatelessWidget {
  /// Creates a [LabeledDescriptionFormField].
  const LabeledDescriptionFormField({
    required this.controller,
    required this.label,
    super.key,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The label of the text field.
  final String label;

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      maxContentWidth: Breakpoint.tablet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          TextField(
            minLines: 10,
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            controller: controller,
            cursorColor: GlobalProperties.shadowColor,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
