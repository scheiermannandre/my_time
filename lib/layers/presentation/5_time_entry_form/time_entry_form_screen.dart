import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_widget.dart';
import 'package:my_time/global/globals.dart';

class TimeEntryFormScreen extends ConsumerWidget {

  late String? id;
  final String projectName;

  TimeEntryFormScreen(
    this.id, {
    super.key,
    required this.projectName,
  });

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(timeEntryFormScreenControllerProvider(id).notifier);
    final state = ref.watch(timeEntryFormScreenControllerProvider(id)).value;
    final value = ref.watch(projectTimeEntryProvider(id!));
    String localId = id ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectName,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
        ),
        backgroundColor: GlobalProperties.backgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: GlobalProperties.textAndIconColor),
            onPressed: () => context.pop()),
      ),
      bottomNavigationBar: NavBarSubmitButton(
        isLoading: false,
        btnText: "Save",
        onBtnTap: () => controller.onBtnTap(context),
      ),
      backgroundColor: GlobalProperties.backgroundColor,
      body: localId.isEmpty
          ? TimeEntryFormWidget(
              init: () => controller.init(),
              formKey: state!.formKey,
              startDateController: state.startDateController,
              startTimeController: state.startTimeController,
              endTimeController: state.endTimeController,
              totalTimeController: state.totalTimeController,
              descriptionController: state.descriptionController,
              validateStartDate: (date) => state.validateStartDate(date),
              validateStartTime: (time) => state.validateStartTime(time),
              validateEndTime: (time) => state.validateEndTime(time),
              validateTotalTime: (time) => state.validateTotalTime(time),
              validateTotalTimePositive: () =>
                  state.validateTotalTimePositive(),
            )
          : AsyncValueWidget(
              value: value,
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
                      startDateController: state.startDateController,
                      startTimeController: state.startTimeController,
                      endTimeController: state.endTimeController,
                      totalTimeController: state.totalTimeController,
                      descriptionController: state.descriptionController,
                      validateStartDate: (date) =>
                          state.validateStartDate(date),
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
