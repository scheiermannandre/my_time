// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/layers/data/time_entries_repository.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/layers/domain/time_entry.dart';
part 'time_entry_form_screen_controller.g.dart';

@riverpod
class TimeEntryFormScreenController extends _$TimeEntryFormScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<TimeEntryFormScreenState> build(
      String projectId, String? timeEntryid) {
    ref.onDispose(() => current = Object());
    return TimeEntryFormScreenState(projectId, timeEntryid);
  }

  void init({TimeEntryDTO? entry}) {
    entry ??= state.value!.defaultEntry;
    state.value!.timeEntry = entry;

    state.value!.startDateController.text =
        entry.startTime.toFormattedDateString();
    state.value!.endDateController.text = entry.endTime.toFormattedDateString();
    state.value!.startTimeController.text =
        entry.startTime.toFormattedTimeOfDayString();
    state.value!.endTimeController.text =
        entry.endTime.toFormattedTimeOfDayString();

    state.value!.totalTimeController.text =
        entry.endTime.difference(entry.startTime).toFormattedString();
    state.value!.descriptionController.text = entry.description;
  }

  void saveEntry(BuildContext context) async {
    bool isFormValid = state.value!.formKey.currentState!.validate();
    if (isFormValid) {
      final data = state.value!.getEntry();
      final result =
          await ref.read(timeEntriesRepositoryProvider).saveTimeEntry(data);
      if (result) {
        await ref.refresh(projectTimeEntriesProvider(data.projectId).future);
        if (mounted) {
          context.pop();
        }
      }
    }
  }

  void deleteEntry(BuildContext context, TimeEntryDTO entry) async {
    final data = state.value!.getEntry();

    final result =
        await ref.read(timeEntriesRepositoryProvider).deleteEntry(data);
    if (result) {
      await ref.refresh(projectTimeEntriesProvider(data.projectId).future);
      if (mounted) {
        context.pop();
      }
    }
  }
}

final projectTimeEntryProvider =
    FutureProvider.autoDispose.family<TimeEntryDTO?, String>((ref, id) async {
  final timeEntriesRepository = ref.watch(timeEntriesRepositoryProvider);
  return await timeEntriesRepository.getEntryById(id);
});

class TimeEntryFormScreenState {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TimeEntryDTO timeEntry;
  late TimeEntryDTO defaultEntry;

  TimeEntryFormScreenState(String projectId, String? timeEntryId) {
    timeEntryId = timeEntryId ?? "";
    DateTime startTime;
    DateTime endTime;
    Duration totalTime;
    DateTime now = DateTime.now();
    const int defaultWorkingTime = 8;
    totalTime = const Duration(hours: defaultWorkingTime);
    startTime = DateTime(now.year, now.month, now.day).add(totalTime);
    endTime = startTime.add(const Duration(hours: defaultWorkingTime));
    defaultEntry = TimeEntryDTO(
      projectId: projectId,
      startTime: startTime,
      endTime: endTime,
      totalTime: totalTime,
      breakTime: Duration.zero,
      description: "",
    );
  }
  TimeEntryDTO getEntry() {
    return timeEntry.copyWith(description: descriptionController.text);
  }

  String? validateDate(DateTime date) {
    timeEntry = timeEntry.copyWith(
        startTime: DateTime(date.year, date.month, date.day,
            timeEntry.startTime.hour, timeEntry.startTime.minute),
        endTime: DateTime(date.year, date.month, date.day,
            timeEntry.endTime.hour, timeEntry.endTime.minute));
    timeEntry = timeEntry.copyWith(
        totalTime: timeEntry.endTime.difference(timeEntry.startTime));

    startDateController.text = timeEntry.startTime.toFormattedDateString();
    totalTimeController.text = timeEntry.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateStartTime(TimeOfDay time) {
    timeEntry = timeEntry.copyWith(
      startTime: DateTime(timeEntry.startTime.year, timeEntry.startTime.month,
          timeEntry.startTime.day, time.hour, time.minute),
    );
    startTimeController.text = time.toFormattedString();
    timeEntry = timeEntry.copyWith(
        totalTime: timeEntry.endTime.difference(timeEntry.startTime));
    totalTimeController.text = timeEntry.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateEndTime(TimeOfDay time) {
    timeEntry = timeEntry.copyWith(
        endTime: DateTime(timeEntry.endTime.year, timeEntry.endTime.month,
            timeEntry.endTime.day, time.hour, time.minute));
    timeEntry = timeEntry.copyWith(
        totalTime: timeEntry.endTime.difference(timeEntry.startTime));
    endTimeController.text = time.toFormattedString();
    totalTimeController.text = timeEntry.totalTime.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    TimeOfDay defaultStartTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay resultingEndTime = defaultStartTime.add(time);
    timeEntry = timeEntry.copyWith(
        startTime: DateTime(now.year, now.month, now.day)
            .add(defaultStartTime.toDuration()));
    timeEntry =
        timeEntry.copyWith(endTime: timeEntry.startTime.add(time.toDuration()));
    timeEntry = timeEntry.copyWith(
        totalTime: Duration(hours: time.hour, minutes: time.minute));

    startTimeController.text = defaultStartTime.toFormattedString();
    endTimeController.text = resultingEndTime.toFormattedString();
    startDateController.text = timeEntry.startTime.toFormattedDateString();
    endDateController.text = timeEntry.endTime.toFormattedDateString();
    totalTimeController.text = time.toFormattedString();
    formKey.currentState!.validate();
    return null;
  }

  String? validateTotalTimePositive() {
    if (timeEntry.totalTime.isNegative) {
      return "Total Time needs to be positive!";
    }
    return null;
  }
}
