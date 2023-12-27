/// A mixin contract defining methods for communication between a wizard and a
/// review step.
///
/// The `WizardToReviewStepContract` mixin is used to establish a communication
/// contract between a wizard and a review step. The method defined in this
/// mixin allows the wizard to invoke the "onFinish" action in the review step,
/// typically passing data collected from the wizard steps.
mixin WizardToReviewStepContract {
  /// Invoke the "onFinish" action in the review step with the provided data.
  ///
  /// The [data] parameter is a map containing data collected from various steps
  /// in the wizard. The review step may process and use this data as needed.
  Future<void> invokeOnFinish(Map<int, dynamic> data);
}
