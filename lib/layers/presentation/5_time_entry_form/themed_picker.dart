import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

Future<TimeOfDay?> showThemedTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget dialog = TimePickerDialog(
    initialTime: initialTime,
  );
  return showDialog<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: theme,
        child: dialog,
      );
    },
  );
}

final theme = ThemeData.light().copyWith(
  timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? GlobalProperties.primaryColor
              : Colors.transparent),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.black
              : Colors.black),
      dialHandColor: Colors.white,
      dialBackgroundColor: GlobalProperties.primaryColor,
      dialTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.black
              : Colors.black),
      entryModeIconColor: Colors.black),
  textTheme: const TextTheme(
    labelSmall: TextStyle(
      color: Colors.black,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
      foregroundColor: MaterialStateColor.resolveWith(
          (states) => GlobalProperties.secondaryColor),
      overlayColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
    ),
  ),
);

Future<DateTime?> showThemedDatePicker({
  required BuildContext context,
  bool useRootNavigator = true,
  String? helpText,
}) async {
  DateTime? date = await showDatePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: GlobalProperties.primaryColor, // header background color
            onPrimary: Colors.black, // header text color
            onSurface: Colors.black, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  GlobalProperties.primaryColor, // button text color
            ),
          ),
        ),
        child: child as Widget,
      );
    },
    helpText: helpText,
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015),
    lastDate: DateTime(2100),
  );
  return date;
}
