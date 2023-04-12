// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/layers/domain/time_entry.dart';

class TimeEntryFormScreenState {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController totalTimeController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TimeEntryDTO timeEntry;

  void setEntry(TimeEntryDTO value) {
    timeEntry = value;
    startDateController.text =
        value.startTime.toFormattedDateString(languageCode);
    endDateController.text = value.endTime.toFormattedDateString(languageCode);
    startTimeController.text = value.startTime.toFormattedTimeOfDayString();
    endTimeController.text = value.endTime.toFormattedTimeOfDayString();

    totalTimeController.text =
        value.endTime.difference(value.startTime).toFormattedString();
    descriptionController.text = value.description;
  }

  late String invalidMessage;
  final String languageCode;

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  TimeEntryFormScreenState({
    required this.invalidMessage,
    required this.languageCode,
    required this.timeEntry,
    required this.startDateController,
    required this.endDateController,
    required this.startTimeController,
    required this.endTimeController,
    required this.totalTimeController,
    required this.descriptionController,
    this.value = const AsyncValue.data(null),
  }) {
    setEntry(timeEntry);
  }

  static TimeEntryDTO generateDefaultEntry(String projectId) {
    DateTime startTime;
    DateTime endTime;
    Duration totalTime;
    DateTime now = DateTime.now();

    const int defaultWorkingTime = 8;
    totalTime = const Duration(hours: defaultWorkingTime);
    startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    endTime = startTime.add(const Duration(hours: defaultWorkingTime));
    return TimeEntryDTO(
      projectId: projectId,
      startTime: startTime,
      endTime: endTime,
      totalTime: totalTime,
      breakTime: Duration.zero,
      description: "",
    );
  }

  TimeEntryDTO getEntry() {
    timeEntry = timeEntry.copyWith(description: descriptionController.text);
    return timeEntry;
  }

  String? validateDate(DateTime date) {
    setEntry(
      timeEntry.copyWith(
        startTime: DateTime(date.year, date.month, date.day,
            timeEntry.startTime.hour, timeEntry.startTime.minute),
        endTime: DateTime(date.year, date.month, date.day,
            timeEntry.endTime.hour, timeEntry.endTime.minute),
        description: descriptionController.text,
      ),
    );
    formKey.currentState!.validate();
    return null;
  }

  String? validateStartTime(TimeOfDay time) {
    setEntry(
      timeEntry.copyWith(
        startTime: DateTime(timeEntry.startTime.year, timeEntry.startTime.month,
            timeEntry.startTime.day, time.hour, time.minute),
        description: descriptionController.text,
      ),
    );
    formKey.currentState!.validate();
    return null;
  }

  String? validateEndTime(TimeOfDay time) {
    setEntry(
      timeEntry.copyWith(
        endTime: DateTime(timeEntry.endTime.year, timeEntry.endTime.month,
            timeEntry.endTime.day, time.hour, time.minute),
        description: descriptionController.text,
      ),
    );

    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    TimeOfDay defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
    DateTime startTime = DateTime(now.year, now.month, now.day)
        .add(defaultStartTime.toDuration());
    DateTime endTime = startTime.add(time.toDuration());
    setEntry(
      timeEntry.copyWith(
        startTime: startTime,
        endTime: endTime,
        description: descriptionController.text,
      ),
    );

    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTimePositive() {
    if (timeEntry.totalTime.isNegative) {
      return invalidMessage;
    }
    return null;
  }

  TimeEntryFormScreenState copyWith({
    TimeEntryDTO? timeEntry,
    AsyncValue<void>? value,
  }) {
    return TimeEntryFormScreenState(
      startDateController: startDateController,
      endDateController: endDateController,
      startTimeController: startTimeController,
      endTimeController: endTimeController,
      totalTimeController: totalTimeController,
      descriptionController: descriptionController,
      timeEntry: timeEntry ?? this.timeEntry,
      invalidMessage: invalidMessage,
      languageCode: languageCode,
      value: value ?? this.value,
    );
  }
}
