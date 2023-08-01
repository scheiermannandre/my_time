import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/global/globals.dart';

/// A Widget that shows a time picker.
class TimePickField extends StatelessWidget {
  /// Creates a TimePickField.
  const TimePickField({
    required this.timeController,
    required this.validateTime,
    super.key,
    this.maxContentWidth,
    this.validateField,
  });

  /// The controller for the time.
  final TextEditingController timeController;

  /// The validation of the time.
  final String? Function(TimeOfDay time) validateTime;

  /// The validation of the field.
  final String? Function()? validateField;

  /// The max content width.
  final double? maxContentWidth;

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await showTimePicker(
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
              hourMinuteColor: MaterialStateColor.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? GlobalProperties.primaryColor
                    : Colors.transparent,
              ),
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

  String? _validate() {
    if (validateField != null) {
      return validateField!();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      alignment: Alignment.centerLeft,
      maxContentWidth:
          maxContentWidth != null ? maxContentWidth! : Breakpoint.desktop,
      child: TextFormField(
        validator: (value) => _validate(),
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
