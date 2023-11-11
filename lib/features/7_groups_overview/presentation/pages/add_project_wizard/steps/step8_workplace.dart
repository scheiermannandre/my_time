import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 8: Workplace Selection Step in a wizard.
class Step8Workplace extends ConsumerWidget {
  /// Constructor for the Step8Workplace widget.
  const Step8Workplace({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(mightyThemeControllerProvider.notifier);
    ref.watch(mightyThemeControllerProvider);
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
          child: ValueSelector(
            options: Workplace.values.map((e) => e.label(context)).toList(),
            themeController: themeController,
            data: data?.label(context),
            onChoose: (value) {
              var workplace = Workplace.remote;
              if (value == Workplace.remote.label(context)) {
                workplace = Workplace.remote;
              } else if (value == Workplace.office.label(context)) {
                workplace = Workplace.office;
              } else //if (value == Workplace.homeOffice.label(context))
              {
                workplace = Workplace.homeOffice;
              }
              controller
                ..next()
                ..saveData(workplace)
                ..showNextBtn()
                ..hideSkipBtn();
            },
          ),
        );
      },
    );
  }
}
