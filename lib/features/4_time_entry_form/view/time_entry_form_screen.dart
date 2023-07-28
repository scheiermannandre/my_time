import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeEntryFormScreen extends HookConsumerWidget {
  final String? timeEntryId;
  final String projectId;
  final String projectName;
  final bool isEdit;

  const TimeEntryFormScreen({
    super.key,
    required this.isEdit,
    required this.timeEntryId,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final invalidTotalTimeMessage = context.loc.invalidTotalTimeMessage;
    final provider = timeEntryFormScreenControllerProvider(
        projectId, timeEntryId, isEdit, invalidTotalTimeMessage, languageCode);

    final controller = ref.watch(provider.notifier);
    final state = ref.watch(provider);
    final key = state.value != null ? state.value!.refreshIndicatorKey : null;
    late AsyncValue<TimeEntryModel> entry = const AsyncValue.loading();
    if (isEdit) {
      entry = ref.watch(projectTimeEntryProvider(timeEntryId!));
      ref.listen<AsyncValue>(
        projectTimeEntryProvider(timeEntryId!),
        (_, state) => state.showAlertDialogOnError(context),
      );
    }
    final AnimationController sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: projectName,
        actions: [
          isEdit && entry.hasValue
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.showDeleteBottomSheet(
                    context,
                    sheetController,
                    entry.value!,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: !isEdit
          ? TimeEntryFormWidget(
              state: state.value,
              onBtnTap: () => controller.saveEntry(context),
            )
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              key: key,
              onRefresh: () async {
                await AsyncValue.guard(() => ref
                    .refresh(projectTimeEntryProvider(timeEntryId!).future)
                    .timeout(const Duration(seconds: 5)));
                return;
              },
              child: entry.when(
                  data: (entry) => TimeEntryFormWidget(
                        state: state.value!,
                        onBtnTap: () => controller.saveEntry(context),
                      ),
                  error: (error, stackTrace) => LoadingErrorWidget(
                      onRefresh: () => state
                          .value!.refreshIndicatorKey.currentState
                          ?.show()),
                  loading: () => const TimeEntryFormScreenLoadingState()),
            ),
    );
  }
}
