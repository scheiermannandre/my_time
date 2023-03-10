import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/themed_picker.dart';
import 'package:my_time/global/globals.dart';

class LabeledDateFormField extends StatelessWidget {
  final TextEditingController dateController;

  final String label;
  final String helpTextDate;
  final String helpTextTime;
  final String? Function(DateTime date) validateDate;

  const LabeledDateFormField(
      {super.key,
      required this.dateController,
      required this.label,
      required this.helpTextDate,
      required this.helpTextTime,
      required this.validateDate});

  void showDatePicker(BuildContext context) async {
    DateTime? date = await showThemedDatePicker(context: context);
    if (date == null) {
      return;
    }
    validateDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      maxContentWidth: Breakpoint.tablet,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  onTap: () => showDatePicker(context),
                  cursorColor: GlobalProperties.shadowColor,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: GlobalProperties.secondaryAccentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: GlobalProperties.secondaryAccentColor),
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
