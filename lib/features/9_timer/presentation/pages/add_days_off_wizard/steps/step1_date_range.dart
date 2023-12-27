import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/9_timer/presentation/widgets/date_picker.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 1: Date selection step.
class Step1DateRange extends StatelessWidget {
  /// Constructor for the Step1Group widget.
  const Step1DateRange({super.key});

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<List<DateTime?>>(
      title: context.loc.entryDateRangeSelectHeader,
      stepNumber: 0,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: DatePicker(
            isRange: true,
            data: data ?? [DateTime.now()],
            onSelect: (date) {
              controller.saveData(date);
            },
            onSave: (date) {
              controller.saveData(date);
            },
          ),
        );
      },
    );
  }
}
