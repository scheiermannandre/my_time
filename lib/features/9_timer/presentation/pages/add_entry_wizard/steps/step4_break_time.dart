import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_picker.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 4 of the AddEntryWizard.
class Step4BreakTime extends ConsumerStatefulWidget {
  /// Constructor for the Step4BreakTime widget.
  const Step4BreakTime({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step4BreakTimeState();
}

class _Step4BreakTimeState extends ConsumerState<Step4BreakTime> {
  Duration time = const Duration(minutes: 30);
  @override
  @override
  Widget build(BuildContext context) {
    // ToDo: Calculate average Break Time for this Project and set it as default
    return WizardStepWrapper<Duration?>(
      title: context.loc.entryBreakTimeLabel,
      stepNumber: 3,
      showNextBtn: true,
      isSkipable: true,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {
            controller.saveData(time);
          },
          child: TimePicker(
            initialTime: data ?? time,
            onTimeChanged: (newTime) {
              setState(() {
                time = newTime;
              });
              controller.saveData(time);
            },
          ),
        );
      },
    );
  }
}
