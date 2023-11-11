import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 3: Sick Days Selection Step in a wizard.
class Step3SickDays extends ConsumerWidget {
  /// Constructor for the Step3SickDays widget.
  const Step3SickDays({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(mightyThemeControllerProvider.notifier);
    ref.watch(mightyThemeControllerProvider);

    return WizardStepWrapper<PaymentStatus?>(
      title: context.loc.step3Title,
      stepNumber: 2,
      showNextBtn: false,
      isSkipable: true,
      isNextBtnEnabled: true,
      userInfo: WizardStepInfo(
        title: context.loc.step3InfoTitle,
        description: context.loc.stepInfoMessageSingleValue,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: ValueSelector(
            options: PaymentStatus.values.map((e) => e.label(context)).toList(),
            themeController: themeController,
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
        );
      },
    );
  }
}
