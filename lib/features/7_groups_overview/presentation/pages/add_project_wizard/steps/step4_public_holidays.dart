import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 4: Public Holidays Selection Step in a wizard.
class Step4PublicHolidays extends StatelessWidget {
  /// Constructor for the Step4PublicHolidays widget.
  const Step4PublicHolidays({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<PaymentStatus?>(
      title: context.loc.step4Title,
      stepNumber: 3,
      showNextBtn: false,
      isSkipable: true,
      isNextBtnEnabled: true,
      userInfo: WizardStepInfo(
        title: context.loc.step4InfoTitle,
        description: context.loc.stepInfoMessageSingleValue,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
            child: ValueSelector(
              options:
                  PaymentStatus.values.map((e) => e.label(context)).toList(),
              data: data?.label(context),
              onChoose: (value) {
                var paymentStatus = PaymentStatus.paid;
                if (value == PaymentStatus.paid.label(context)) {
                  paymentStatus = PaymentStatus.paid;
                } else {
                  paymentStatus = PaymentStatus.unpaid;
                }
                controller
                  ..next()
                  ..saveData(paymentStatus)
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
