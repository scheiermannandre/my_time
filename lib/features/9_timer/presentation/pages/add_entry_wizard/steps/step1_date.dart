import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/9_timer/presentation/widgets/date_picker.dart';

/// Step 1: Date selection step.
class Step1Date extends StatelessWidget {
  /// Constructor for the Step1Group widget.
  const Step1Date({super.key});

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<DateTime?>(
      title: context.loc.entrySelectDateLabel,
      stepNumber: 0,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: DatePicker(
            data: [data ?? DateTime.now()],
            onSelect: (dates) {
              final date = dates.first;
              controller
                ..next()
                ..saveData(date);
            },
            onSave: (dates) {
              final date = dates.first;
              controller.saveData(date);
            },
          ),
        );
      },
    );
  }
}
