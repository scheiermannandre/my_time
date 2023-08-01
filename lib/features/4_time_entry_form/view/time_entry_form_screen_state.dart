import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

/// The state of the TimeEntryFormScreen.
class TimeEntryFormScreenState {
  /// Creates a TimeEntryFormScreenState.
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
    _setEntry(timeEntry);
  }

  /// The key of the RefreshIndicator.
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  /// The controller of the start date field.
  final TextEditingController startDateController;

  /// The controller of the end date field.
  final TextEditingController endDateController;

  /// The controller of the start time field.
  final TextEditingController startTimeController;

  /// The controller of the end time field.
  final TextEditingController endTimeController;

  /// The controller of the total time field.
  final TextEditingController totalTimeController;

  /// The controller of the description field.
  final TextEditingController descriptionController;

  /// The key of the form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// The time entry.
  late TimeEntryModel timeEntry;

  /// The invalid message.
  late String invalidMessage;

  /// The language code.
  final String languageCode;

  /// The value of the async value.

  final AsyncValue<void> value;

  /// Returns true if the form is loading.
  bool get isLoading => value.isLoading;

  void _setEntry(TimeEntryModel value) {
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

  /// Generates a default time entry.
  static TimeEntryModel generateDefaultEntry(String projectId) {
    DateTime startTime;
    DateTime endTime;
    Duration totalTime;
    final now = DateTime.now();

    const defaultWorkingTime = 8;
    totalTime = const Duration(hours: defaultWorkingTime);
    startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    endTime = startTime.add(const Duration(hours: defaultWorkingTime));
    return TimeEntryModel(
      projectId: projectId,
      startTime: startTime,
      endTime: endTime,
      totalTime: totalTime,
      breakTime: Duration.zero,
      description: '',
    );
  }

  /// Returns the time entry.
  TimeEntryModel getEntry() =>
      timeEntry.copyWith(description: descriptionController.text);

  /// Validates the start date.
  String? validateDate(DateTime date) {
    _setEntry(
      timeEntry.copyWith(
        startTime: DateTime(
          date.year,
          date.month,
          date.day,
          timeEntry.startTime.hour,
          timeEntry.startTime.minute,
        ),
        endTime: DateTime(
          date.year,
          date.month,
          date.day,
          timeEntry.endTime.hour,
          timeEntry.endTime.minute,
        ),
        description: descriptionController.text,
      ),
    );
    formKey.currentState!.validate();
    return null;
  }

  /// Validates the end date.
  String? validateStartTime(TimeOfDay time) {
    _setEntry(
      timeEntry.copyWith(
        startTime: DateTime(
          timeEntry.startTime.year,
          timeEntry.startTime.month,
          timeEntry.startTime.day,
          time.hour,
          time.minute,
        ),
        description: descriptionController.text,
      ),
    );
    formKey.currentState!.validate();
    return null;
  }

  /// Validates the end date.
  String? validateEndTime(TimeOfDay time) {
    _setEntry(
      timeEntry.copyWith(
        endTime: DateTime(
          timeEntry.endTime.year,
          timeEntry.endTime.month,
          timeEntry.endTime.day,
          time.hour,
          time.minute,
        ),
        description: descriptionController.text,
      ),
    );

    formKey.currentState!.validate();
    return null;
  }

  /// Validates the total time.
  String? validateTotalTime(TimeOfDay time) {
    final now = DateTime.now();
    const defaultStartTime = TimeOfDay(hour: 9, minute: 0);
    final startTime = DateTime(now.year, now.month, now.day)
        .add(defaultStartTime.toDuration());
    final endTime = startTime.add(time.toDuration());
    _setEntry(
      timeEntry.copyWith(
        startTime: startTime,
        endTime: endTime,
        description: descriptionController.text,
      ),
    );

    formKey.currentState!.validate();
    return null;
  }

  /// Validates the total time.
  String? validateTotalTimePositive() {
    if (timeEntry.totalTime.isNegative) {
      return invalidMessage;
    }
    return null;
  }

  /// Copy Method, so that the [TimeEntryFormScreenState] can be updated and
  /// still be immutable.
  TimeEntryFormScreenState copyWith({
    TimeEntryModel? timeEntry,
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
