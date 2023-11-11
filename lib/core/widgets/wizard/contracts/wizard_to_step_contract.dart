/// A mixin contract defining methods for communication between a wizard and a
/// step.
///
/// The `WizardToStepContract` mixin is used to establish a communication
/// contract between a wizard and a step. It defines methods that the wizard
/// can use to invoke actions on the step, such as moving to the next or
/// previous step.
mixin WizardToStepContract {
  /// Invoke the "onNext" action in the step.
  void invokeOnNext();

  /// Invoke the "onPrevious" action in the step.
  void invokeOnPrevious();
}
