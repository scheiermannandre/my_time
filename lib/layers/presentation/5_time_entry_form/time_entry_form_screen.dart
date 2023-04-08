import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen_loading_state.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_widget.dart';
import 'package:my_time/global/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final languageCode = Localizations.localeOf(context).languageCode;
    final invalidTotalTimeMessage =
        AppLocalizations.of(context)!.invalidTotalTimeMessage;

    final controller = ref.watch(timeEntryFormScreenControllerProvider(
            projectId, timeEntryId, invalidTotalTimeMessage, languageCode)
        .notifier);
    final state = ref
        .watch(timeEntryFormScreenControllerProvider(
            projectId, timeEntryId, invalidTotalTimeMessage, languageCode))
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
              init: () => controller.init(context: context),
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
                      projectId, timeEntryId, invalidTotalTimeMessage, languageCode))
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
                          btnLabel: AppLocalizations.of(context)!
                              .noEntryFoundBtnLabel,
                          onBtnTap: () =>
                              state!.refreshIndicatorKey.currentState?.show(),
                          title:
                              AppLocalizations.of(context)!.noEntryFoundTitle,
                          description: AppLocalizations.of(context)!
                              .noEntryFoundDescription,
                          icon: Icons.refresh,
                        )
                      : TimeEntryFormWidget(
                          formKey: state!.formKey,
                          init: () => controller.init(entry: entry, context: context),
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
