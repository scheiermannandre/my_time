import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/standard_button.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/features/projects_groups/data/projects_repository.dart';
import 'package:my_time/features/projects_groups/domain/time_entry.dart';
import 'package:my_time/features/projects_groups/presentation/5_time_entry_form/labeled_date_and_time_form_field.dart';
import 'package:my_time/features/projects_groups/presentation/5_time_entry_form/labeled_description_form_field.dart';
import 'package:my_time/features/projects_groups/presentation/5_time_entry_form/time_pick_field.dart';
import 'package:my_time/global/globals.dart';

class TimeEntryForm extends ConsumerWidget {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String? id;
  late TimeEntry? timeEntry;

  late TimeEntry defaultEntry;

  // late DateTime startTime;
  // late DateTime endTime;
  // late Duration totalTime;

  TimeEntryForm(this.id, {super.key}) {
    timeEntry = null;
    id = id ?? "";
    DateTime startTime;
    DateTime endTime;
    Duration totalTime;
    DateTime now = DateTime.now();
    totalTime = const Duration(hours: 9);
    startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    endTime = startTime.add(const Duration(hours: 8));

    // if (id == null) {
    //   startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    //   endTime = startTime.add(const Duration(hours: 8));
    // } else {
    //   startTime = entry.startTime;
    //   endTime = entry.endTime;
    // }

    defaultEntry = TimeEntry("ToDo", startTime, endTime, totalTime);
  }

  void onBtnTap(BuildContext context) {
    bool isFormValid = formKey.currentState!.validate();
    if (isFormValid) {
      context.pop();
    }
    // if (selectedGroup == selectGroupText ||
    //     projectNameController.text.isEmpty) {
    //   return;
    // }
    // context.pop();
  }

  String? validateStartDate(DateTime date) {
    timeEntry!.startTime = DateTime(date.year, date.month, date.day,
        timeEntry!.startTime.hour, timeEntry!.startTime.minute);
    startDateController.text = timeEntry!.startTime.toFormattedDateString();
    timeEntry!.totalTime = timeEntry!.endTime.difference(timeEntry!.startTime);
    totalTimeController.text = timeEntry!.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateEndDate(DateTime date) {
    timeEntry!.endTime = DateTime(date.year, date.month, date.day,
        timeEntry!.endTime.hour, timeEntry!.endTime.minute);
    endDateController.text = date.toFormattedDateString();
    timeEntry!.totalTime = timeEntry!.endTime.difference(timeEntry!.startTime);
    totalTimeController.text = timeEntry!.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateStartTime(TimeOfDay time) {
    timeEntry!.startTime = DateTime(
        timeEntry!.startTime.year,
        timeEntry!.startTime.month,
        timeEntry!.startTime.day,
        time.hour,
        time.minute);
    startTimeController.text = time.toFormattedString();
    timeEntry!.totalTime = timeEntry!.endTime.difference(timeEntry!.startTime);
    totalTimeController.text = timeEntry!.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateEndTime(TimeOfDay time) {
    timeEntry!.endTime = DateTime(
        timeEntry!.endTime.year,
        timeEntry!.endTime.month,
        timeEntry!.endTime.day,
        time.hour,
        time.minute);
    endTimeController.text = time.toFormattedString();
    timeEntry!.totalTime = timeEntry!.endTime.difference(timeEntry!.startTime);
    totalTimeController.text = timeEntry!.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    TimeOfDay defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay resultingEndTime = defaultStartTime.add(time);
    timeEntry!.startTime = DateTime(now.year, now.month, now.day)
        .add(defaultStartTime.toDuration());
    timeEntry!.endTime = timeEntry!.startTime.add(time.toDuration());
    timeEntry!.totalTime = Duration(hours: time.hour, minutes: time.minute);

    startTimeController.text = defaultStartTime.toFormattedString();
    endTimeController.text = resultingEndTime.toFormattedString();
    startDateController.text = timeEntry!.startTime.toFormattedDateString();
    endDateController.text = timeEntry!.endTime.toFormattedDateString();
    totalTimeController.text = time.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTimePositive() {
    if (timeEntry!.totalTime.isNegative) {
      return "Total Time needs to be positive!";
    }
    return null;
  }

  void init(TimeEntry entry) {
    timeEntry = entry;

    startDateController.text = entry.startTime.toFormattedDateString();
    endDateController.text = entry.endTime.toFormattedDateString();
    startTimeController.text =
        entry.startTime.toFormattedTimeOfDayString();
    endTimeController.text = entry.endTime.toFormattedTimeOfDayString();

    totalTimeController.text = entry.endTime
        .difference(entry.startTime)
        .toFormattedString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TimeEntry entry = defaultEntry;
    final value = ref.watch(projectTimeEntryProvider(id!));
    String localId = id ?? "";
    if (id!.isEmpty) {
      entry = value.value ?? defaultEntry;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Project X",
          style: TextStyle(color: GlobalProperties.textAndIconColor),
        ),
        backgroundColor: GlobalProperties.backgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: GlobalProperties.textAndIconColor),
            onPressed: () => context.pop()),
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        child: ResponsiveAlign(
          alignment: Alignment.center,
          maxContentWidth: Breakpoint.desktop,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: StandardButton(
            text: "Save",
            width: Breakpoint.mobile,
            onPressed: () => onBtnTap(context),
          ),
        ),
      ),
      backgroundColor: GlobalProperties.backgroundColor,
      body: localId.isEmpty
          ? TimeEntryFormWidget(
              init: () => init(defaultEntry),
              formKey: formKey,
              startDateController: startDateController,
              startTimeController: startTimeController,
              endTimeController: endTimeController,
              totalTimeController: totalTimeController,
              descriptionController: descriptionController,
              validateStartDate: (date) => validateStartDate(date),
              validateStartTime: (time) => validateStartTime(time),
              validateEndTime: (time) => validateEndTime(time),
              validateTotalTime: (time) => validateTotalTime(time),
              validateTotalTimePositive: () => validateTotalTimePositive(),
            )
          : AsyncValueWidget(
              value: value,
              data: (entry) => entry == null
                  ? Center(
                      child: Text(
                        'TimeEntry could not be found!',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )
                  : TimeEntryFormWidget(
                      formKey: formKey,
                      init: () => init(entry),
                      startDateController: startDateController,
                      startTimeController: startTimeController,
                      endTimeController: endTimeController,
                      totalTimeController: totalTimeController,
                      descriptionController: descriptionController,
                      validateStartDate: (date) => validateStartDate(date),
                      validateStartTime: (time) => validateStartTime(time),
                      validateEndTime: (time) => validateEndTime(time),
                      validateTotalTime: (time) => validateTotalTime(time),
                      validateTotalTimePositive: () =>
                          validateTotalTimePositive(),
                    ),
            ),
    );
  }
}

class TimeEntryFormWidget extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController totalTimeController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;
  final String? Function(DateTime date) validateStartDate;
  final String? Function(TimeOfDay time) validateStartTime;
  final String? Function(TimeOfDay time) validateEndTime;
  final String? Function(TimeOfDay time) validateTotalTime;
  final Function() validateTotalTimePositive;
  final Function() init;

  const TimeEntryFormWidget(
      {super.key,
      required this.startDateController,
      required this.startTimeController,
      required this.endTimeController,
      required this.totalTimeController,
      required this.descriptionController,
      required this.formKey,
      required this.validateStartDate,
      required this.validateStartTime,
      required this.validateEndTime,
      required this.validateTotalTime,
      required this.validateTotalTimePositive,
      required this.init});

  @override
  Widget build(BuildContext context) {
    init();
    return Form(
      key: formKey,
      child: ResponsiveAlign(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledDateAndTimeFormField(
                validateDate: (date) => validateStartDate(date),
                validateTime: (time) => validateStartTime(time),
                dateController: startDateController,
                timeController: startTimeController,
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
                            validateTime: (time) => validateStartTime(time)),
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
                            helpTextTime: "TEST",
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
              //const Padding(padding: EdgeInsets.only(bottom: 16)),
              // LabeledDateAndTimeFormField(
              //   validateDate: (date) => validateEndDate(date),
              //   validateTime: (time) => validateEndTime(time),
              //   dateController: endDateController,
              //   timeController: endTimeController,
              //   label: "End",
              //   helpTextDate: "End Date",
              //   helpTextTime: "End Time",
              // ),
              // const Padding(padding: EdgeInsets.only(bottom: 16)),
              // LabeledTimePickFormField(
              //   validateTime: (time) => validateTotalTime(time),
              //   validateField: () => validateTotalTimePositive(),
              //   controller: totalTimeController,
              //   label: "Start Time",
              //   helpText: "Start Time",
              // ),
              // const Padding(padding: EdgeInsets.only(bottom: 16)),
              // LabeledTimePickFormField(
              //   validateTime: (time) => validateTotalTime(time),
              //   validateField: () => validateTotalTimePositive(),
              //   controller: totalTimeController,
              //   label: "End Time",
              //   helpText: "End Time",
              // ),
              // const Padding(padding: EdgeInsets.only(bottom: 16)),
              // LabeledTimePickFormField(
              //   validateTime: (time) => validateTotalTime(time),
              //   validateField: () => validateTotalTimePositive(),
              //   controller: totalTimeController,
              //   label: "Total Time",
              //   helpText: "Total Time",
              // ),
              const Padding(padding: EdgeInsets.only(bottom: 16)),
              LabeledDescriptionFormField(controller: descriptionController),
            ],
          ),
        ),
      ),
    );
  }
}
