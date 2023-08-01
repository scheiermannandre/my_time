import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_entry_form_screen_controller.g.dart';

/// State of the TimeEntryFormScreen.
@riverpod
class TimeEntryFormScreenController extends _$TimeEntryFormScreenController {
  /// Needed for checking if the widget is still mounted.
  final initial = Object();

  /// Needed for checking if the widget is still mounted.
  late Object current = initial;

  /// Returns true if the widget is still mounted.
  bool get mounted => current == initial;
  @override
  FutureOr<TimeEntryFormScreenState> build(
    String projectId,
    String? timeEntryId,
    bool isEdit,
    String invalidMessage,
    String languageCode,
  ) async {
    ref.onDispose(() => current = Object());
    var timeEntry = TimeEntryFormScreenState.generateDefaultEntry(projectId);
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

  /// Handles the tap on the save button
  Future<void> saveEntry(BuildContext context, {required bool isEdit}) async {
    final isFormValid = state.value!.formKey.currentState!.validate();

    if (isFormValid) {
      final data = state.value!.getEntry();
      state =
          AsyncData(state.value!.copyWith(value: const AsyncValue.loading()));
      final AsyncValue<bool> result;
      if (isEdit) {
        result = await AsyncValue.guard(
          () => ref.read(timeEntryFormServiceProvider).updateTimeEntry(data),
        );
      } else {
        result = await AsyncValue.guard(
          () => ref.read(timeEntryFormServiceProvider).addTimeEntry(data),
        );
      }
      if (result.hasValue && result.value!) {
        if (mounted) {
          context.pop();
        }
      } else {
        state = AsyncData(state.value!.copyWith(value: const AsyncData(null)));
        if (mounted) {
          await result.showAlertDialogOnError(context);
        }
      }
    }
  }

  Future<void> _deleteEntry(
    BuildContext context,
    TimeEntryModel entry,
    bool? deletePressed,
  ) async {
    if (deletePressed ?? false) {
      if (mounted) {
        context.pop();
      }
    }
  }

  /// Handles the tap on the delete button
  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    TimeEntryModel entry,
  ) async {
    {
      bool? deletePressed = false;
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _deleteEntry(context, entry, deletePressed);
        }
      }

      controller
        ..removeStatusListener(listener)
        ..addStatusListener(listener);
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
              await ref.read(timeEntryFormServiceProvider).deleteEntry(data);
          return result;
        },
      );
    }
  }
}

/// Provides the Time Entry for the Form.
final projectTimeEntryProvider =
    FutureProvider.autoDispose.family<TimeEntryModel, String>((ref, id) async {
  final timeEntriesRepository = ref.watch(timeEntryFormServiceProvider);
  return timeEntriesRepository.getEntryById(id);
});
