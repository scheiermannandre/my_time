import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/labeled_date_and_time_form_field.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/labeled_description_form_field.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_pick_field.dart';

class TimeEntryFormWidget extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController totalTimeController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;
  final String? Function(DateTime date) validateDate;
  final String? Function(TimeOfDay time) validateStartTime;
  final String? Function(TimeOfDay time) validateEndTime;
  final String? Function(TimeOfDay time) validateTotalTime;
  final Function() validateTotalTimePositive;
  final Function() init;
  final Function() onBtnTap;

  const TimeEntryFormWidget(
      {super.key,
      required this.dateController,
      required this.startTimeController,
      required this.endTimeController,
      required this.totalTimeController,
      required this.descriptionController,
      required this.formKey,
      required this.validateDate,
      required this.validateStartTime,
      required this.validateEndTime,
      required this.validateTotalTime,
      required this.validateTotalTimePositive,
      required this.init,
      required this.onBtnTap});

  @override
  Widget build(BuildContext context) {
    init();
    return Form(
      key: formKey,
      child: ResponsiveAlign(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledDateFormField(
                    validateDate: (date) => validateDate(date),
                    dateController: dateController,
                    label: "Date",
                    helpTextDate: "Start Date",
                    helpTextTime: "Start Time",
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  ResponsiveAlign(
                    maxContentWidth: Breakpoint.tablet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Start",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const Padding(padding: EdgeInsets.only(bottom: 12)),
                            TimePickField(
                                maxContentWidth: 100,
                                timeController: startTimeController,
                                helpTextTime: "Start Time",
                                validateTime: (time) =>
                                    validateStartTime(time)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("End",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const Padding(padding: EdgeInsets.only(bottom: 12)),
                            TimePickField(
                                maxContentWidth: 100,
                                timeController: endTimeController,
                                helpTextTime: "End Time",
                                validateTime: (time) => validateEndTime(time)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                            ),
                            TimePickField(
                              maxContentWidth: 100,
                              timeController: totalTimeController,
                              helpTextTime: "Total Time",
                              validateTime: (time) => validateTotalTime(time),
                              validateField: () => validateTotalTimePositive(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  LabeledDescriptionFormField(
                      controller: descriptionController),
                  Expanded(
                    child: NavBarSubmitButton(
                      isLoading: false,
                      btnText: "Save",
                      onBtnTap: onBtnTap,
                      align: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
