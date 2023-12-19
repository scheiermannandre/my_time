import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/9_timer/presentation/widgets/description_step.dart';

/// Step 6 of the AddEntryWizard.
class Step6Description extends StatelessWidget {
  /// Constructor for the Step6Description widget.
  const Step6Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<String?>(
      title: context.loc.entryWorkDescriptionLabel,
      stepNumber: 5,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: DescriptionStep(
            data: data,
            saveName: controller.saveData,
          ),
        );
      },
    );
  }
}
