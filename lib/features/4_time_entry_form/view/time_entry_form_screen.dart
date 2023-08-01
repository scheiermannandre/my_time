import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

/// The screen of the TimeEntryForm.
class TimeEntryFormScreen extends HookConsumerWidget {
  /// Creates a TimeEntryFormScreen.
  const TimeEntryFormScreen({
    required this.isEdit,
    required this.timeEntryId,
    required this.projectId,
    required this.projectName,
    super.key,
  });

  /// The id of the time entry.
  final String? timeEntryId;

  /// The id of the project.
  final String projectId;

  /// The name of the project.
  final String projectName;

  /// Whether the time entry is edited or not.
  final bool isEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final invalidTotalTimeMessage = context.loc.invalidTotalTimeMessage;
    final provider = timeEntryFormScreenControllerProvider(
      projectId,
      timeEntryId,
      isEdit,
      invalidTotalTimeMessage,
      languageCode,
    );

    final controller = ref.watch(provider.notifier);
    final state = ref.watch(provider);
    final key = state.value != null ? state.value!.refreshIndicatorKey : null;
    late var entry = const AsyncValue<TimeEntryModel>.loading();
    if (isEdit) {
      entry = ref.watch(projectTimeEntryProvider(timeEntryId!));
      ref.listen<AsyncValue<void>>(
        projectTimeEntryProvider(timeEntryId!),
        (_, state) => state.showAlertDialogOnError(context),
      );
    }
    final sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: projectName,
        actions: [
          if (isEdit && entry.hasValue)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.showDeleteBottomSheet(
                context,
                sheetController,
                entry.value!,
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      body: !isEdit
          ? TimeEntryFormWidget(
              state: state.value,
              onBtnTap: () => controller.saveEntry(context, isEdit: isEdit),
            )
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              key: key,
              onRefresh: () async {
                await AsyncValue.guard(
                  () => ref
                      .refresh(projectTimeEntryProvider(timeEntryId!).future)
                      .timeout(const Duration(seconds: 5)),
                );
                return;
              },
              child: entry.when(
                data: (entry) => TimeEntryFormWidget(
                  state: state.value,
                  onBtnTap: () => controller.saveEntry(context, isEdit: isEdit),
                ),
                error: (error, stackTrace) => LoadingErrorWidget(
                  onRefresh: () =>
                      state.value!.refreshIndicatorKey.currentState?.show(),
                ),
                loading: () => const TimeEntryFormScreenLoadingState(),
              ),
            ),
    );
  }
}
