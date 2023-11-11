import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_buttons.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_controller.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_step_indicator.dart';
import 'package:preload_page_view/preload_page_view.dart';

/// A widget that represents a wizard with multiple steps.
class Wizard extends ConsumerWidget {
  /// Creates a [Wizard] widget.
  const Wizard({
    required this.backgroundColor,
    required this.appBarTitleStyle,
    required this.appBarBackgroundColor,
    required this.appBarIconColor,
    required this.onFinish,
    required this.steps,
    required this.reviewStep,
    required this.stepStyle,
    required this.titleStyle,
    required this.primary,
    required this.secondary,
    required this.skipBtnTitle,
    required this.nextBtnTitlePrimary,
    required this.nextBtnTitleSecondary,
    required this.previousBtnTitle,
    required this.lastPageBtnTitle,
    required this.finishBtnTitle,
    required this.infoIconColor,
    this.indicatorPadding = const EdgeInsets.symmetric(
      horizontal: SpaceTokens.medium,
      vertical: SpaceTokens.small,
    ),
    this.btnsPadding = const EdgeInsets.all(SpaceTokens.medium),
    this.infoDialogBuilder,
    super.key,
  });

  /// Callback function invoked when the wizard finishes.
  final void Function() onFinish;

  /// Callback function that is called to show description for a step.
  final Widget Function(BuildContext context, String title, String description)?
      infoDialogBuilder;

  /// List of widgets representing individual steps in the wizard.
  final List<Widget> steps;

  /// Background color of the wizard.
  final Color backgroundColor;

  /// Background color of the app bar.
  final Color appBarBackgroundColor;

  /// Icon color of the app bar.
  final Color appBarIconColor;

  /// Text style for the app bar title.
  final TextStyle appBarTitleStyle;

  /// Padding for the step indicator.
  final EdgeInsets indicatorPadding;

  /// Style for the step indicator.
  final StepIndicatorStyle stepStyle;

  /// Widget representing the review step.
  final Widget reviewStep;

  /// Text style for the step title.
  final TextStyle titleStyle;

  /// Color of the information icon.
  final Color infoIconColor;

  /// Padding for the wizard buttons.
  final EdgeInsets btnsPadding;

  /// Style for the primary wizard button.
  final WizardButtonStyle primary;

  /// Style for the secondary wizard button.
  final WizardButtonStyle secondary;

  /// Widget representing the title of the skip button.
  final Widget skipBtnTitle;

  /// Widget representing the title of the primary next button.
  final Widget nextBtnTitlePrimary;

  /// Widget representing the title of the secondary next button.
  final Widget nextBtnTitleSecondary;

  /// Widget representing the title of the previous button.
  final Widget previousBtnTitle;

  /// Widget representing the title of the last page button.
  final Widget lastPageBtnTitle;

  /// Widget representing the title of the finish button.
  final Widget finishBtnTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(wizardControllerProvider.notifier);
    final state = ref.watch(wizardControllerProvider);
    return WizardEventListener(
      controller: controller,
      onFinish: (value) {
        onFinish(); // Call the onFinish callback from the outside.
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: !state.isLastPage ? 0 : 3,
          backgroundColor: appBarBackgroundColor,
          title: Text(
            !state.isLastPage
                ? context.loc
                    .stepIndicatorText(state.currentPage + 1, steps.length)
                : context.loc.stepIndicatorReviewText,
            style: appBarTitleStyle,
          ),
          iconTheme: IconThemeData(
            color: appBarIconColor,
          ),
        ),
        body: SafeArea(
          top: false,
          right: false,
          left: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !state.isLastPage,
                child: Padding(
                  padding: indicatorPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StepIndicatorRow(
                        steps: steps.length + 1,
                        currentStep: state.currentPage,
                        stepStyle: stepStyle,
                      ),
                      const SizedBox(height: SpaceTokens.small),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              !state.isLastPage ? state.stepTitle : '',
                              style: titleStyle,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          if (state.userInfo != null)
                            ActionButton.roundedIcon(
                              iconData: Icons.info_outline,
                              onPressed: () async {
                                if (infoDialogBuilder == null) return;
                                await showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      infoDialogBuilder!(
                                    context,
                                    state.userInfo!.title,
                                    state.userInfo!.description,
                                  ),
                                );
                              },
                              backgroundColor: Colors.transparent,
                              isLoading: false,
                              iconColor: infoIconColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PreloadPageView(
                  preloadPagesCount: steps.length,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: state.pageController,
                  children: [
                    ...steps,
                    reviewStep,
                  ],
                ),
              ),
              Padding(
                padding: btnsPadding,
                child: WizardButtons(
                  isLoading: state.isLoading,
                  showNextBtn: state.showNextBtn,
                  isSkipable: state.isSkipable,
                  isNextBtnEnabled: state.isNextBtnEnabled,
                  isFirstStep: state.isFirstPage,
                  isLastStep: state.isLastPage,
                  isInReview: state.isInReview,
                  primary: primary,
                  secondary: secondary,
                  previousButtonContent: previousBtnTitle,
                  onPrevious: controller.previous,
                  nextButtonContentPrimary: nextBtnTitlePrimary,
                  nextButtonContentSecondary: nextBtnTitleSecondary,
                  onNext: controller.next,
                  goToLastPageButtonContent: lastPageBtnTitle,
                  onLastPage: controller.last,
                  onSkip: controller.skip,
                  skipButtonContent: skipBtnTitle,
                  onFinish: controller.finish,
                  finishButtonContent: finishBtnTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
