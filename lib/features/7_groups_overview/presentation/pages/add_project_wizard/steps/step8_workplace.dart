import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/workplace_selector.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 8: Workplace Selection Step in a wizard.
class Step8Workplace extends StatelessWidget {
  /// Constructor for the Step8Workplace widget.
  const Step8Workplace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<Workplace?>(
      title: context.loc.step8Title,
      stepNumber: 7,
      showNextBtn: false,
      isSkipable: true,
      isNextBtnEnabled: true,
      userInfo: WizardStepInfo(
        title: context.loc.step8InfoTitle,
        description: context.loc.stepInfoMessageSingleValue,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
            child: WorkplaceSelector(
              workplace: data,
              onChoose: (value) {
                controller
                  ..next()
                  ..saveData(value)
                  ..showNextBtn()
                  ..hideSkipBtn();
              },
            ),
          ),
        );
      },
    );
  }
}
