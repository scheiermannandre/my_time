import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_state.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:preload_page_view/preload_page_view.dart';

/// The state for the Wizard widget.
class WizardState {
  /// Creates an instance of [WizardState].
  WizardState()
      : this._internal(
          pageController: PreloadPageController(),
          currentPage: 0,
          isInReview: false,
          wizardStepStates: {},
          isLoading: false,
          isFinishBtnEnabled: true,
        );

  /// Creates an instance of [WizardState] with internal parameters.
  WizardState._internal({
    required this.pageController,
    required this.currentPage,
    required this.isInReview,
    required this.wizardStepStates,
    required this.isLoading,
    required this.isFinishBtnEnabled,
  });

  /// The page controller for the wizard.
  final PreloadPageController pageController;

  /// The current page of the wizard.
  final int currentPage;

  /// A flag indicating whether the wizard is in review mode.
  final bool isInReview;

  /// A flag indicating whether the wizard is loading.
  final bool isLoading;

  /// The state of each wizard step identified by its step number.
  final Map<int, WizardStepState<dynamic>> wizardStepStates;

  /// Returns whether the finish button is enabled.
  final bool isFinishBtnEnabled;

  /// Returns whether the next button is enabled.
  bool get isNextBtnEnabled => getWizardStepState()?.isNextBtnEnabled ?? false;

  /// Returns whether the step is skippable.
  bool get isSkipable => getWizardStepState()?.isSkipable ?? false;

  /// Returns whether the next button is to be shown.
  bool get showNextBtn => getWizardStepState()?.showNextBtn ?? false;

  /// Returns whether the current page is the last page.
  bool get isLastPage => _isLastPage();

  /// Returns whether the current page is the first page.
  bool get isFirstPage => currentPage == 0;

  /// Returns the title of the current step.
  String get stepTitle => getWizardStepState()?.stepTitle ?? '';

  /// Returns additional information about the current step.
  WizardStepInfo? get userInfo => getWizardStepState()?.userInfo;

  /// Returns the state of the current step.
  WizardStepState<dynamic>? getWizardStepState() {
    if (currentPage >= wizardStepStates.length) return null;
    return wizardStepStates[currentPage];
  }

  /// Checks if the current page is the last page in the wizard.
  bool _isLastPage() {
    final lastPageIndex =
        wizardStepStates.isEmpty ? 1 : wizardStepStates.length;
    return currentPage == lastPageIndex;
  }

  /// Creates a copy of the current state with optional changes.
  WizardState copyWith({
    PreloadPageController? pageController,
    int? currentPage,
    bool? isInReview,
    Map<int, WizardStepState<dynamic>>? wizardStepStates,
    bool? isLoading,
    bool? isFinishBtnEnabled,
  }) {
    return WizardState._internal(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      isInReview: isInReview ?? this.isInReview,
      wizardStepStates: wizardStepStates ?? this.wizardStepStates,
      isLoading: isLoading ?? this.isLoading,
      isFinishBtnEnabled: isFinishBtnEnabled ?? this.isFinishBtnEnabled,
    );
  }
}
