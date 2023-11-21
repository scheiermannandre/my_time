import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/core/widgets/mighty_wizard.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step1_group.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step2_project_name.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step3_sick_days.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step4_public_holidays.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step5_vacation_info.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step6_project_time_management.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step7_money_management.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step8_workplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/steps/step9_review.dart';

/// A widget representing the add project wizard.
class AddProjectWizard extends HookConsumerWidget {
  /// Constructs an [AddProjectWizard] with required parameters.
  const AddProjectWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MightyWizard(
      previousBtnTitle: context.loc.previousBtn,
      nextBtnTitle: context.loc.nextBtn,
      skipBtnTitle: context.loc.skipBtn,
      lastPageBtnTitle: context.loc.backToReviewBtn,
      finishBtnTitle: context.loc.finishBtn,
      reviewStep: const ReviewStep(),
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
    );
  }
}
