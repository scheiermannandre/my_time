import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_picker.dart';

/// Step 3 of the AddEntryWizard.
class Step3EndTime extends ConsumerStatefulWidget {
  /// Constructor for the Step3EndTime widget.
  const Step3EndTime({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step3EndTimeState();
}

class _Step3EndTimeState extends ConsumerState<Step3EndTime> {
  Duration time = const Duration(hours: 17, minutes: 30);

  @override
  Widget build(BuildContext context) {
    // ToDo: Calculate average End Time for this Project and set it as default
    return WizardStepWrapper<Duration?>(
      title: context.loc.entryEndTimeLabel,
      stepNumber: 2,
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
