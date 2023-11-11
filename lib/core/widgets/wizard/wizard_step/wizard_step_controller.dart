import 'package:my_time/core/util/classes/event_stream.dart';
import 'package:my_time/core/widgets/wizard/contracts/step_to_controller_contract.dart';
import 'package:my_time/core/widgets/wizard/contracts/wizard_to_step_contract.dart';
import 'package:my_time/core/widgets/wizard/events/on_next_event.dart';
import 'package:my_time/core/widgets/wizard/events/on_previous_event.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_controller.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_state.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wizard_step_controller.g.dart';

@riverpod

/// Wizard Step Controller.
///
/// The `WizardStepController` class is responsible for managing the state and
/// behavior of a specific step within a wizard. It implements both the
/// [WizardToStepContract] and [StepToControllerContract] mixins, providing
/// methods for navigation and communication with the wizard
/// and the step itself.
class WizardStepController<T> extends _$WizardStepController
    with WizardToStepContract, StepToControllerContract<T> {
  /// Event stream for the "next" button click event.
  final EventStream<OnNextEvent> onNextEvent = EventStream<OnNextEvent>();

  /// Event stream for the "previous" button click event.
  final EventStream<OnPreviousEvent> onPreviousEvent =
      EventStream<OnPreviousEvent>();

  /// The step number associated with this controller.
  int stepNumber = 0;

  @override
  WizardStepState<dynamic> build(int step) {
    ref.onDispose(() {
      onNextEvent.dispose();
      onPreviousEvent.dispose();
    });
    stepNumber = step;
    final newState = WizardStepState<T>();
    return newState;
  }

  /// [WizardController] calls this method to notify the [WizardStepController]
  @override
  void invokeOnNext() {
    onNextEvent.publish(OnNextEvent());
  }

  @override
  void invokeOnPrevious() {
    onPreviousEvent.publish(OnPreviousEvent());
  }

  /// [WizardStepController] calls this method to notify the [WizardController]
  @override
  void next() {
    invokeOnNext();
    ref.read(wizardControllerProvider.notifier).invokeOnNext();
  }

  /// [WizardStepController] calls this method to notify the [WizardController]
  @override
  void enableNext() {
    state = state.copyWith(
      isNextBtnEnabled: true,
    );
    ref.read(wizardControllerProvider.notifier).setStepState(state, stepNumber);
  }

  /// [WizardStepController] calls this method to notify the [WizardController]
  @override
  void disableNext() {
    state = state.copyWith(
      isNextBtnEnabled: false,
    );
    ref.read(wizardControllerProvider.notifier).setStepState(state, stepNumber);
  }

  @override
  void showNextBtn() {
    state = state.copyWith(
      showNextBtn: true,
      isNextBtnEnabled: true,
    );
    ref.read(wizardControllerProvider.notifier).setStepState(state, stepNumber);
  }

  @override
  void hideSkipBtn() {
    state = state.copyWith(
      isSkipable: false,
    );
    ref.read(wizardControllerProvider.notifier).setStepState(state, stepNumber);
  }

  /// Initializes the state of the step.
  ///
  /// This method is called to set the initial state of the step, such as
  /// enabling or disabling the "next" button, showing or hiding the "skip"
  /// button, and providing additional information about the step.
  void initState({
    required bool isNextBtnEnabled,
    required bool isSkipable,
    required bool showNextBtn,
    required String title,
    required WizardStepInfo? userInfo,
  }) {
    state = state.copyWith(
      isNextBtnEnabled: isNextBtnEnabled,
      isSkipable: isSkipable,
      showNextBtn: showNextBtn,
      stepTitle: title,
      userInfo: userInfo,
    );
    ref
        .read(wizardControllerProvider.notifier)
        .registerWizardStepController(step, this, state);
  }

  @override
  void saveData(T data) {
    state = state.copyWith(
      data: data,
    );
  }
}
