// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_time/layers/data/time_entries_repository.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    TimeEntryDTO timeEntry =
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

  void _deleteEntry(
      BuildContext context, TimeEntryDTO entry, bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    TimeEntryDTO entry,
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
        title: AppLocalizations.of(context)!.deleteEntryTitle,
        message: AppLocalizations.of(context)!.deleteEntryMessage,
        confirmBtnText:
            AppLocalizations.of(context)!.deleteEntryConfirmBtnLabel,
        cancelBtnText: AppLocalizations.of(context)!.deleteEntryCancelBtnLabel,
        onCanceled: () {
          Navigator.of(context).pop(false);
        },
        onConfirmed: () async {
          final data = state.value!.getEntry();

          final result =
              await ref.read(timeEntriesRepositoryProvider).deleteEntry(data);
          return result;
        },
        whenCompleted: (result, mounted) async {
          if (result) {
            ref.invalidate(projectTimeEntriesProvider(entry.projectId));
          }
          if (result && !mounted) {
            ref.invalidate(projectTimeEntryProvider(entry.id));
          }
        },
      );
    }
  }
}

final projectTimeEntryProvider =
    FutureProvider.autoDispose.family<TimeEntryDTO, String>((ref, id) async {
  final timeEntriesRepository = ref.watch(timeEntriesRepositoryProvider);
  return await timeEntriesRepository.getEntryById(id);
});
