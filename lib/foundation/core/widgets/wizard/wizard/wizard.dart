import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/wizard/events/on_finish_event.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_buttons.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_controller.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_step_indicator.dart';
import 'package:preload_page_view/preload_page_view.dart';

/// A widget that represents a wizard with multiple steps.
class Wizard extends ConsumerWidget {
  /// Creates a [Wizard] widget.
  const Wizard({
    required this.onFinish,
    required this.steps,
    required this.reviewStep,
    required this.stepStyle,
    required this.skipBtnTitle,
    required this.nextBtnTitle,
    required this.previousBtnTitle,
    required this.lastPageBtnTitle,
    required this.finishBtnTitle,
    this.indicatorPadding = const EdgeInsets.symmetric(
      horizontal: SpaceTokens.medium,
      vertical: SpaceTokens.small,
    ),
    this.btnsPadding = const EdgeInsets.all(SpaceTokens.medium),
    super.key,
  });

  /// Callback function invoked when the wizard finishes.
  final Future<void> Function(OnFinishEvent event) onFinish;

  /// List of widgets representing individual steps in the wizard.
  final List<Widget> steps;

  /// Padding for the step indicator.
  final EdgeInsets indicatorPadding;

  /// Style for the step indicator.
  final StepIndicatorStyle stepStyle;

  /// Widget representing the review step.
  final Widget reviewStep;

  /// Padding for the wizard buttons.
  final EdgeInsets btnsPadding;

  /// Widget representing the title of the skip button.
  final Widget skipBtnTitle;

  /// Widget representing the title of the primary next button.
  final Widget nextBtnTitle;

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
      onFinish: onFinish,
      child: Scaffold(
        appBar: AppBar(
          elevation: !state.isLastPage ? 0 : 1,
          title: Text(
            !state.isLastPage
                ? context.loc
                    .stepIndicatorText(state.currentPage + 1, steps.length)
                : context.loc.stepIndicatorReviewText,
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
                        steps: steps.length,
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
                              style: TextStyleTokens.getHeadline4(null),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Visibility(
                            visible: state.userInfo != null,
                            child: ActionButton.icon(
                              child: const Icon(Icons.info_outline),
                              onPressed: () async {
                                await ModalDialogUI.showOk(
                                  context: context,
                                  title: state.userInfo!.title,
                                  content: state.userInfo!.description,
                                );
                              },
                            ),
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
                  previousButtonContent: previousBtnTitle,
                  onPrevious: controller.previous,
                  nextButtonContent: nextBtnTitle,
                  onNext: controller.next,
                  goToLastPageButtonContent: lastPageBtnTitle,
                  onLastPage: controller.last,
                  onSkip: controller.skip,
                  skipButtonContent: skipBtnTitle,
                  onFinish: controller.finish,
                  finishButtonContent: finishBtnTitle,
                  finishBtnEnabled: state.isFinishBtnEnabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
