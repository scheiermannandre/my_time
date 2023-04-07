import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_loading_state.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_widget.dart';
import 'package:my_time/global/globals.dart';

class TimeEntryFormScreen extends ConsumerWidget {
  final String? timeEntryId;
  final String projectId;
  final String projectName;

  const TimeEntryFormScreen({
    super.key,
    required this.timeEntryId,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
        timeEntryFormScreenControllerProvider(projectId, timeEntryId).notifier);
    final state = ref
        .watch(timeEntryFormScreenControllerProvider(projectId, timeEntryId))
        .value;
    var entry = ref.watch(projectTimeEntryProvider(timeEntryId!));
    String localId = timeEntryId ?? "";
    return Scaffold(
      appBar: CustomAppBar(
        title: projectName,
        actions: [
          entry.hasValue && !entry.hasError
              ? IconButton(
                  icon: const Icon(Icons.delete,
                      color: GlobalProperties.textAndIconColor),
                  onPressed: () =>
                      controller.deleteEntry(context, entry.value!))
              : const SizedBox.shrink(),
        ],
      ),
      backgroundColor: GlobalProperties.backgroundColor,
      body: localId.isEmpty
          ? TimeEntryFormWidget(
              init: () => controller.init(),
              formKey: state!.formKey,
              dateController: state.startDateController,
              startTimeController: state.startTimeController,
              endTimeController: state.endTimeController,
              totalTimeController: state.totalTimeController,
              descriptionController: state.descriptionController,
              validateDate: (date) => state.validateDate(date),
              validateStartTime: (time) => state.validateStartTime(time),
              validateEndTime: (time) => state.validateEndTime(time),
              validateTotalTime: (time) => state.validateTotalTime(time),
              validateTotalTimePositive: () =>
                  state.validateTotalTimePositive(),
              onBtnTap: () => controller.saveEntry(context),
            )
          : RefreshIndicator(
              color: GlobalProperties.secondaryAccentColor,
              key: ref
                  .read(timeEntryFormScreenControllerProvider(
                      projectId, timeEntryId))
                  .value!
                  .refreshIndicatorKey,
              onRefresh: () async {
                await AsyncValue.guard(() => ref
                    .refresh(projectTimeEntryProvider(timeEntryId!).future)
                    .timeout(const Duration(seconds: 5)));
                return;
              },
              child: entry.when(
                  data: (entry) => entry == null
                      ? NoItemsFoundWidget(
                          btnLabel: "Refresh",
                          onBtnTap: () =>
                              state!.refreshIndicatorKey.currentState?.show(),
                          title: "Entry not found",
                          description: "Please refresh the screen",
                          icon: Icons.refresh,
                        )
                      : TimeEntryFormWidget(
                          formKey: state!.formKey,
                          init: () => controller.init(entry: entry),
                          dateController: state.startDateController,
                          startTimeController: state.startTimeController,
                          endTimeController: state.endTimeController,
                          totalTimeController: state.totalTimeController,
                          descriptionController: state.descriptionController,
                          validateDate: (date) => state.validateDate(date),
                          validateStartTime: (time) =>
                              state.validateStartTime(time),
                          validateEndTime: (time) =>
                              state.validateEndTime(time),
                          validateTotalTime: (time) =>
                              state.validateTotalTime(time),
                          validateTotalTimePositive: () =>
                              state.validateTotalTimePositive(),
                          onBtnTap: () => controller.saveEntry(context),
                        ),
                  error: (error, stackTrace) => LoadingErrorWidget(
                      onRefresh: () =>
                          state!.refreshIndicatorKey.currentState?.show()),
                  loading: () => const TimeEntryFormScreenLoadingState()),
            ),
    );
  }
}
