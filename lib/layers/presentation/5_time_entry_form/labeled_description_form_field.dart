import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';

class LabeledDescriptionFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const LabeledDescriptionFormField({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      alignment: Alignment.centerLeft,
      maxContentWidth: Breakpoint.tablet,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          TextField(
            minLines: 10,
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            controller: controller,
            cursorColor: GlobalProperties.shadowColor,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: GlobalProperties.secondaryAccentColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: GlobalProperties.secondaryAccentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
