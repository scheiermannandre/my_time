import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
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

/// A widget representing the add project wizard.
class AddProjectWizard extends StatelessWidget {
  /// Constructs an [AddProjectWizard] with required parameters.
  const AddProjectWizard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Wizard(
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

/// A customizable wizard widget that guides the user through a series of steps.

class _Wizard extends StatelessWidget {
  /// Creates a MightyWizard widget.
  ///
  /// The [steps] parameter is a list of widgets representing the steps
  /// in the wizard.
  /// The [reviewStep] parameter is the widget to be displayed on the
  /// review step.
  /// The [skipBtnTitle], [nextBtnTitle], [previousBtnTitle],
  /// [lastPageBtnTitle], and [finishBtnTitle] parameters are titles for
  /// different buttons in the wizard.

  const _Wizard({
    required this.steps,
    required this.reviewStep,
    required this.skipBtnTitle,
    required this.nextBtnTitle,
    required this.previousBtnTitle,
    required this.lastPageBtnTitle,
    required this.finishBtnTitle,
  });

  /// A list of widgets representing the steps in the wizard.
  final List<Widget> steps;

  /// The widget to be displayed on the review step.
  final Widget reviewStep;

  /// The title for the skip button.
  final String skipBtnTitle;

  /// The title for the next button.
  final String nextBtnTitle;

  /// The title for the previous button.
  final String previousBtnTitle;

  /// The title for the last page button.
  final String lastPageBtnTitle;

  /// The title for the finish button.
  final String finishBtnTitle;
  @override
  Widget build(BuildContext context) {
    return Wizard(
      onFinish: () {},
      previousBtnTitle: _Button(
        title: previousBtnTitle,
        type: _BtnType.previous,
      ),
      nextBtnTitlePrimary: _Button(
        title: nextBtnTitle,
        type: _BtnType.forward,
      ),
      nextBtnTitleSecondary: _Button(
        title: nextBtnTitle,
        type: _BtnType.forward,
      ),
      skipBtnTitle: _Button(
        title: skipBtnTitle,
      ),
      lastPageBtnTitle: _Button(
        title: lastPageBtnTitle,
      ),
      finishBtnTitle: _Button(
        title: finishBtnTitle,
      ),
      reviewStep: reviewStep,
      steps: steps,
      stepStyle: const StepIndicatorStyle(),
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
