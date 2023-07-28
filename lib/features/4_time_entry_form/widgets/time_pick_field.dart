import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/global/globals.dart';

import 'package:flutter/material.dart';

class TimePickField extends StatelessWidget {
  final TextEditingController timeController;
  final String? Function(TimeOfDay time) validateTime;
  final String? Function()? validateField;

  final double? maxContentWidth;

  const TimePickField(
      {super.key,
      required this.timeController,
      this.maxContentWidth,
      required this.validateTime,
      this.validateField});

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 09, minute: 00),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              background: Colors.white,
              primary: GlobalProperties.primaryColor,
              onPrimary: Colors.black,
              onBackground: Colors.black,
              onSecondary: Colors.black,
              onError: Colors.black,
              onSurface: Colors.black,
              secondary: Colors.black,
              surface: Colors.white,
              error: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    GlobalProperties.secondaryColor, // button text color
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: GlobalProperties.backgroundColor,
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? GlobalProperties.primaryColor
                      : Colors.transparent),
              hourMinuteTextColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
              dialHandColor: GlobalProperties.backgroundColor,
              dialBackgroundColor: GlobalProperties.primaryColor,
              dialTextColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
            ),
          ),
          child: child!,
        );
      },
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
        onTap: () => _showTimePicker(context),
        controller: timeController,
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
    );
  }
}
