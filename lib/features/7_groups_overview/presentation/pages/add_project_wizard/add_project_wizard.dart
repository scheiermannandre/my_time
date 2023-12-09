import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_step_indicator.dart';
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
      previousBtnTitle: _Button(
        title: context.loc.previousBtn,
        type: _BtnType.previous,
      ),
      nextBtnTitle: _Button(
        title: context.loc.nextBtn,
        type: _BtnType.forward,
      ),
      skipBtnTitle: _Button(
        title: context.loc.skipBtn,
      ),
      lastPageBtnTitle: _Button(
        title: context.loc.backToReviewBtn,
      ),
      finishBtnTitle: _Button(
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

/// Enum representing the type of a wizard button.
enum _BtnType {
  /// [forward] is used for the next button because it adds an arrow pointing
  /// to the right.
  forward,

  /// [previous] is used for the previous button because it adds an arrow
  /// pointing to the left.
  previous,

  /// [regular] is used for all other buttons.
  regular,
}

/// A customizable button widget used in the MightyWizard widget.

class _Button extends StatelessWidget {
  /// Creates a Button widget.
  ///
  /// The [title] parameter is the title text of the button.
  /// The [type] parameter is the type of the button
  /// (forward, previous, regular).

  const _Button({
    required this.title,
    this.type = _BtnType.regular,
  });

  /// The type of the button (forward, previous, regular).
  final _BtnType type;

  /// The title text of the button.
  final String title;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Visibility(
            visible: type == _BtnType.previous,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.large),
            child: Text(
              title,
              style: TextStyleTokens.body(null),
              overflow: TextOverflow.fade,
            ),
          ),
          Visibility(
            visible: type == _BtnType.forward,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
