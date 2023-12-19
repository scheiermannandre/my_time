import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_picker.dart';

/// Step 2 of the AddEntryWizard.
class Step2StartTime extends ConsumerStatefulWidget {
  /// Constructor for the Step2StartTime widget.
  const Step2StartTime({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step2StartTimeState();
}

class _Step2StartTimeState extends ConsumerState<Step2StartTime> {
  Duration time = const Duration(hours: 9);

  @override
  Widget build(BuildContext context) {
    // ToDo: Calculate average Start Time for this Project and set it as default
    return WizardStepWrapper<Duration?>(
      title: context.loc.entryStartTimeLabel,
      stepNumber: 1,
      showNextBtn: true,
      isSkipable: false,
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
              controller.saveData(newTime);
            },
          ),
        );
      },
    );
  }
}
