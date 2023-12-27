import 'package:flutter/material.dart';
import 'package:my_time/foundation/core/widgets/wizard/contracts/step_to_wizard_contract.dart';
import 'package:my_time/foundation/core/widgets/wizard/events/on_finish_event.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_state.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_controller.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wizard_controller.g.dart';

/// Controller for managing the state and flow of a wizard.
@riverpod
class WizardController extends _$WizardController with StepToWizardContract {
  /// Event stream for wizard-related events.

  /// Callback function for the "onFinish" event.
  Future<void> Function(OnFinishEvent)? onFinishEvent;

  /// Map to store wizard step controllers for each step.
  final Map<int, WizardStepController<dynamic>> stepControllers = {};

  @override
  WizardState build() {
    ref.onDispose(() {
      state.pageController.dispose();
      onFinishEvent = null;
    });
    return WizardState();
  }

  /// Called by the [WizardStepController] to register itself, so that the
  /// [WizardController] can call the [WizardStepController] while knowing that
  /// there is actually a [WizardStepController] for the given step.
  @override
  void registerWizardStepController(
    int stepNumber,
    WizardStepController<dynamic> controller,
    WizardStepState<dynamic> stepState,
  ) {
    stepControllers[stepNumber] = controller;
    state.wizardStepStates[stepNumber] = stepState;
    state = state.copyWith(
      wizardStepStates: state.wizardStepStates,
    );
  }

  /// Initializes the wizard states with the provided step states.
  void initStates(
    Map<int, WizardStepState<dynamic>> stepStates,
  ) {
    state = state.copyWith(
      wizardStepStates: stepStates,
    );
  }

  /// Moves to the next page in the wizard.
  void next() {
    stepControllers[state.currentPage]?.invokeOnNext();
    _nextPage();
  }

  /// Moves to the next page without invoking any controller events.
  void _nextPage() {
    changePage(state.currentPage + 1);
  }

  /// Moves to the previous page in the wizard.
  void _previousPage() {
    changePage(state.currentPage - 1);
  }

  /// Notifies the wizard to move to the next page.
  @override
  void invokeOnNext() {
    if (state.isInReview) return;
    _nextPage();
  }

  /// Sets the state of the specified step in the wizard.
  @override
  void setStepState(WizardStepState<dynamic> stepState, int step) {
    state.wizardStepStates[step] = stepState;
    state = state.copyWith(
      wizardStepStates: state.wizardStepStates,
    );
  }

  /// Sets the enabled state of the finish button in the review step.
  void setReviewPageFinishEnabled(bool isFinishBtnEnabled) {
    state = state.copyWith(
      isFinishBtnEnabled: isFinishBtnEnabled,
    );
  }

  /// Moves to the previous page in the wizard.
  void previous() {
    stepControllers[state.currentPage]?.invokeOnPrevious();
    _previousPage();
  }

  /// Changes the current page of the wizard to the specified page.
  void changePage(int page) {
    if (page < 0 || page > state.wizardStepStates.length) {
      return;
    }
    state.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _setPage(page);
  }

  /// Jumps to the specified page in the wizard without animation.
  void jumpPage(int page) {
    if (page < 0 || page > state.wizardStepStates.length) {
      return;
    }
    state.pageController.jumpToPage(
      page,
    );
    _setPage(page);
  }

  /// Sets the current page of the wizard and updates the review state.
  void _setPage(int page) {
    state = state.copyWith(
      currentPage: page,
    );
    if (!state.isInReview) {
      state = state.copyWith(
        isInReview: state.isLastPage,
      );
    }
  }

  /// Skips to the next page in the wizard.
  void skip() {
    _nextPage();
  }

  /// Jumps to the last page in the wizard.
  void last() {
    jumpPage(state.wizardStepStates.length);
  }

  /// Finishes the wizard, invokes the review step's finish event,
  /// and updates the state.
  Future<void> finish() async {
    state = state.copyWith(isLoading: true);
    final data = stepControllers.values.fold<Map<int, dynamic>>(
      {},
      (data, controller) {
        data[controller.stepNumber] =
            ref.read(wizardStepControllerProvider(controller.stepNumber)).data;
        return data;
      },
    );
    await onFinishEvent?.call(
      OnFinishEvent(
        data: data,
      ),
    );
    state = state.copyWith(isLoading: false);
  }
}
