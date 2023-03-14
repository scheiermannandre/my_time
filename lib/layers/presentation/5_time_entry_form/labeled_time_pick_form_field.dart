import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_pick_field.dart';

class LabeledTimePickFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(TimeOfDay time) validateTime;
  final String? Function()? validateField;

  final String helpText;

  const LabeledTimePickFormField(
      {super.key,
      required this.label,
      required this.controller,
      required this.helpText,
      required this.validateTime,
      this.validateField});

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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          TimePickField(
            maxContentWidth: 100,
            validateTime: (time) => validateTime(time),
            validateField: validateField,
            helpTextTime: helpText,
            timeController: controller,
          ),
        ],
      ),
    );
  }
}
