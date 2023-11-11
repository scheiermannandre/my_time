/// A mixin contract defining methods for communication between a step and
/// a controller.
///
/// The `StepToControllerContract` mixin is used to establish a communication
/// contract between a step in a wizard and its associated controller.
/// The methods defined in this mixin allow the step to interact with the
/// controller, enabling actions such as moving to the next step, enabling or
/// disabling the next button, showing or hiding specific buttons,
/// and saving data.
///
/// The generic type [T] represents the type of data that can be
/// saved by the step.
mixin StepToControllerContract<T> {
  /// Move to the next step in the wizard.
  void next();

  /// Enable the next button in the wizard.
  void enableNext();

  /// Disable the next button in the wizard.
  void disableNext();

  /// Show the next button in the wizard.
  void showNextBtn();

  /// Hide the skip button in the wizard.
  void hideSkipBtn();

  /// Save data from the step to the controller.
  void saveData(T data);
}
