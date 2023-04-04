import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_controller.dart';
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
    final entry = ref.watch(projectTimeEntryProvider(timeEntryId!));
    String localId = timeEntryId ?? "";
    return Scaffold(
      appBar: CustomAppBar(
        title: projectName,
        actions: [
          entry.value != null
              ? IconButton(
                  icon: const Icon(Icons.delete,
                      color: GlobalProperties.textAndIconColor),
                  onPressed: () =>
                      controller.deleteEntry(context, entry.value!))
              : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavBarSubmitButton(
        isLoading: false,
        btnText: "Save",
        onBtnTap: () => controller.saveEntry(context),
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
            )
          : AsyncValueWidget(
              value: entry,
              data: (entry) => entry == null
                  ? Center(
                      child: Text(
                        'TimeEntry could not be found!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
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
                      validateEndTime: (time) => state.validateEndTime(time),
                      validateTotalTime: (time) =>
                          state.validateTotalTime(time),
                      validateTotalTimePositive: () =>
                          state.validateTotalTimePositive(),
                    ),
            ),
    );
  }
}
