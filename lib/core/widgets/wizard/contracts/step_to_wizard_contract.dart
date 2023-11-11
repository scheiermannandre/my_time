import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_controller.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_state.dart';

/// A mixin contract defining methods for communication between a step and
/// a wizard.
///
/// The `StepToWizardContract` mixin is used to establish a communication
/// contract between a step in a wizard and the wizard itself.
/// The methods defined in this mixin allow the step to invoke the next
/// action in the wizard, set the state of a specific step, and register a
/// wizard step controller along with its state.
mixin StepToWizardContract {
  /// Invoke the "onNext" action in the wizard, typically moving to the
  /// next step.
  void invokeOnNext();

  /// Set the state of a specific step in the wizard.
  void setStepState(WizardStepState<dynamic> state, int step);

  /// Register a wizard step controller along with its state for a specific
  /// step.
  void registerWizardStepController(
    int stepNumber,
    WizardStepController<dynamic> controller,
    WizardStepState<dynamic> state,
  );
}
