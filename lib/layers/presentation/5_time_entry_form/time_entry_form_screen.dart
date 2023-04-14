import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_loading_state.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_widget.dart';

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
    late AsyncValue<TimeEntryDTO> entry = const AsyncValue.loading();
    if (isEdit) {
      entry = ref.watch(projectTimeEntryProvider(timeEntryId!));
      ref.listen<AsyncValue>(
        projectTimeEntryProvider(timeEntryId!),
        (_, state) => state.showAlertDialogOnError(context),
      );
    }
    print(entry);
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
                  data: (entry) => entry == null
                      ? NoItemsFoundWidget(
                          btnLabel: context.loc.noEntryFoundBtnLabel,
                          onBtnTap: () => state
                              .value!.refreshIndicatorKey.currentState
                              ?.show(),
                          title: context.loc.noEntryFoundTitle,
                          description: context.loc.noEntryFoundDescription,
                          icon: Icons.refresh,
                        )
                      : TimeEntryFormWidget(
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
