import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

import 'package:flutter/material.dart';

class TimeEntryFormWidget extends StatelessWidget {
  final Function() onBtnTap;
  final TimeEntryFormScreenState? state;
  const TimeEntryFormWidget(
      {super.key, required this.onBtnTap, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      Function()? onLocalBtnTap = !state!.isLoading ? onBtnTap : null;

      return Form(
        key: state!.formKey,
        child: ResponsiveAlign(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledDateFormField(
                      validateDate: (date) => state!.validateDate(date),
                      dateController: state!.startDateController,
                      label: context.loc.datePickFieldLabel,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 16)),
                    ResponsiveAlign(
                      maxContentWidth: Breakpoint.tablet,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.startTimePickFieldLabel,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 12)),
                              TimePickField(
                                  maxContentWidth: 100,
                                  timeController: state!.startTimeController,
                                  validateTime: (time) =>
                                      state!.validateStartTime(time)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.endTimePickFieldLabel,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 12)),
                              TimePickField(
                                  maxContentWidth: 100,
                                  timeController: state!.endTimeController,
                                  validateTime: (time) =>
                                      state!.validateEndTime(time)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.totalTimePickFieldLabel,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                              ),
                              TimePickField(
                                maxContentWidth: 100,
                                timeController: state!.totalTimeController,
                                validateTime: (time) =>
                                    state!.validateTotalTime(time),
                                validateField: () =>
                                    state!.validateTotalTimePositive(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 16)),
                    LabeledDescriptionFormField(
                        label: context.loc.descriptionFieldLabel,
                        controller: state!.descriptionController),
                    Expanded(
                      child: NavBarSubmitButton(
                        isLoading: state!.isLoading,
                        btnText: context.loc.saveEntryBtnLabel,
                        onBtnTap: onLocalBtnTap,
                        align: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 16))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
