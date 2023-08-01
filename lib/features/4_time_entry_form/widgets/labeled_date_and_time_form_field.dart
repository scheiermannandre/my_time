import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/global/globals.dart';

/// A labeled date form field.
class LabeledDateFormField extends StatelessWidget {
  /// Creates a LabeledDateFormField.
  const LabeledDateFormField({
    required this.dateController,
    required this.label,
    required this.validateDate,
    super.key,
  });

  /// The controller for the date.
  final TextEditingController dateController;

  /// The label of the date.
  final String label;

  /// The validation of the date.
  final String? Function(DateTime date) validateDate;

  Future<void> _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      builder: (context, child) {
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
            datePickerTheme: DatePickerThemeData(
              backgroundColor: GlobalProperties.backgroundColor,
              todayForegroundColor: MaterialStateColor.resolveWith(
                (states) => GlobalProperties.secondaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );

    if (date == null) {
      return;
    }
    validateDate(date);
  }

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
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  onTap: () => _showDatePicker(context),
                  cursorColor: GlobalProperties.shadowColor,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
