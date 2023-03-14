import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_widget.dart';
import 'package:my_time/global/globals.dart';

class TimeEntryFormScreen extends ConsumerWidget {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String? id;
  final String projectName;
  late TimeEntry? timeEntry;

  late TimeEntry defaultEntry;
  TimeEntryFormScreen(
    this.id, {
    super.key,
    required this.projectName,
  }) {
    timeEntry = null;
    id = id ?? "";
    DateTime startTime;
    DateTime endTime;
    Duration totalTime;
    DateTime now = DateTime.now();
    totalTime = const Duration(hours: 9);
    startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    endTime = startTime.add(const Duration(hours: 8));
    defaultEntry = TimeEntry("id", startTime, endTime, totalTime);
  }

  void onBtnTap(BuildContext context) {
    bool isFormValid = formKey.currentState!.validate();
    if (isFormValid) {
      context.pop();
    }
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
    startTimeController.text = entry.startTime.toFormattedTimeOfDayString();
    endTimeController.text = entry.endTime.toFormattedTimeOfDayString();

    totalTimeController.text =
        entry.endTime.difference(entry.startTime).toFormattedString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(projectTimeEntryProvider(id!));
    String localId = id ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectName,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
        ),
        backgroundColor: GlobalProperties.backgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: GlobalProperties.textAndIconColor),
            onPressed: () => context.pop()),
      ),
      bottomNavigationBar: NavBarSubmitButton(
        isLoading: false,
        btnText: "Save",
        onBtnTap: () => onBtnTap(context),
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
