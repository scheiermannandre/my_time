import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_entry_form_screen_controller.g.dart';

@riverpod
class TimeEntryFormScreenController extends _$TimeEntryFormScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<TimeEntryFormScreenState> build(
      String projectId,
      String? timeEntryId,
      bool isEdit,
      String invalidMessage,
      String languageCode) async {
    ref.onDispose(() => current = Object());
    TimeEntryModel timeEntry =
        TimeEntryFormScreenState.generateDefaultEntry(projectId);
    if (isEdit) {
      final entry =
          await ref.read(projectTimeEntryProvider(timeEntryId!).future);
      timeEntry = entry;
    }

    return TimeEntryFormScreenState(
      timeEntry: timeEntry,
      invalidMessage: invalidMessage,
      languageCode: languageCode,
      startDateController: TextEditingController(),
      endDateController: TextEditingController(),
      startTimeController: TextEditingController(),
      endTimeController: TextEditingController(),
      totalTimeController: TextEditingController(),
      descriptionController: TextEditingController(),
    );
  }

  void saveEntry(BuildContext context) async {
    bool isFormValid = state.value!.formKey.currentState!.validate();

    if (isFormValid) {
      final data = state.value!.getEntry();
      state =
          AsyncData(state.value!.copyWith(value: const AsyncValue.loading()));
      final result = await AsyncValue.guard(
          () => ref.read(timeEntryFormRepositoryProvider).saveTimeEntry(data));

      if (result.hasValue && result.value!) {
        if (mounted) {
          context.pop();
        }
      } else {
        state = AsyncData(state.value!.copyWith(value: const AsyncData(null)));
        if (mounted) {
          result.showAlertDialogOnError(context);
        }
      }
    }
  }

  void _deleteEntry(
      BuildContext context, TimeEntryModel entry, bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    TimeEntryModel entry,
  ) async {
    {
      bool? deletePressed = false;
      listener(status) {
        if (status == AnimationStatus.dismissed) {
          _deleteEntry(context, entry, deletePressed);
        }
      }

      controller.removeStatusListener(listener);
      controller.addStatusListener(listener);
      deletePressed = await openBottomSheet(
        context: context,
        bottomSheetController: controller,
        title: context.loc.deleteEntryTitle,
        message: context.loc.deleteEntryMessage,
        confirmBtnText: context.loc.deleteEntryConfirmBtnLabel,
        cancelBtnText: context.loc.deleteEntryCancelBtnLabel,
        onCanceled: () {
          Navigator.of(context).pop(false);
        },
        onConfirmed: () async {
          final data = state.value!.getEntry();

          final result =
              await ref.read(timeEntryFormRepositoryProvider).deleteEntry(data);
          return result;
        },
      );
    }
  }
}

final projectTimeEntryProvider =
    FutureProvider.autoDispose.family<TimeEntryModel, String>((ref, id) async {
  final timeEntriesRepository = ref.watch(timeEntryFormRepositoryProvider);
  return await timeEntriesRepository.getEntryById(id);
});
