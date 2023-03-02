import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/features/projects_groups/presentation/5_time_entry_form/themed_picker.dart';
import 'package:my_time/global/globals.dart';

class TimePickField extends StatelessWidget {
  final TextEditingController timeController;
  final String? Function(TimeOfDay time) validateTime;
  final String? Function()? validateField;

  final String helpTextTime;
  final double? maxContentWidth;

  const TimePickField(
      {super.key,
      required this.timeController,
      required this.helpTextTime,
      this.maxContentWidth,
      required this.validateTime,
      this.validateField});

  void showTimePicker(BuildContext context) async {
    TimeOfDay? time = await showThemedTimePicker(
      context: context,
      helpText: helpTextTime,
      initialTime: const TimeOfDay(hour: 09, minute: 00),
    );
    if (time == null) {
      return;
    }
    validateTime(time);
  }

  String? validate() {
    if (validateField != null) {
      return validateField!();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      alignment: Alignment.centerLeft,
      maxContentWidth: maxContentWidth != null
          ? maxContentWidth as double
          : Breakpoint.desktop,
      child: TextFormField(
        validator: (value) => validate(),
        readOnly: true,
        onTap: () => showTimePicker(context),
        controller: timeController,
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
    );
  }
}
