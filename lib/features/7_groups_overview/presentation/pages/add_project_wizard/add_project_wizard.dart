import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step1_group.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step2_project_name.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step3_sick_days.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step4_public_holidays.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step5_vacation_info.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step6_project_time_management.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step7_money_management.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step8_workplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step9_review.dart';
import 'package:my_time/features/7_groups_overview/presentation/state_management/add_project_wizard_controller.dart';
import 'package:my_time/foundation/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_step_indicator.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_button_data.dart';

/// A widget representing the add project wizard.
class AddProjectWizard extends ConsumerWidget {
  /// Constructs an [AddProjectWizard] with required parameters.
  const AddProjectWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watchAndListenAsyncValueErrors(
      context,
      addProjectWizardControllerProvider,
    );

    return Wizard(
      onFinish: (event) async {
        final isSuccess = await ref
            .read(addProjectWizardControllerProvider.notifier)
            .addProject(event.data);

        if (!isSuccess) return;
        if (!context.mounted) return;

        context.pop();
      },
      previousBtnTitle: WizardButtonData(
        title: context.loc.previousBtn,
        type: WizardBtnType.previous,
      ),
      nextBtnTitle: WizardButtonData(
        title: context.loc.nextBtn,
        type: WizardBtnType.forward,
      ),
      skipBtnTitle: WizardButtonData(
        title: context.loc.skipBtn,
      ),
      lastPageBtnTitle: WizardButtonData(
        title: context.loc.backToReviewBtn,
      ),
      finishBtnTitle: WizardButtonData(
        title: context.loc.finishBtn,
      ),
      stepStyle: const StepIndicatorStyle(),
      steps: const [
        Step1Group(),
        Step2ProjectName(),
        Step3SickDays(),
        Step4PublicHolidays(),
        Step5VacationInfo(),
        Step6ProjectTimeManagement(),
        Step7MoneyManagement(),
        Step8Workplace(),
      ],
      reviewStep: const ReviewStep(),
    );
  }
}
