import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/9_timer/presentation/widgets/description_step.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 3 of the AddDaysOffWizard.
class Step3Description extends StatelessWidget {
  /// Constructor for the Step3Description widget.
  const Step3Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<String?>(
      title: context.loc.entryDescriptionLabel,
      stepNumber: 2,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: DescriptionField(
            data: data,
            save: controller.saveData,
          ),
        );
      },
    );
  }
}
