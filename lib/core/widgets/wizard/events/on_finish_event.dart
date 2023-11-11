/// An event class representing the "onFinish" event in a wizard.
///
/// The `OnFinishEvent` class is used to encapsulate the data to be passed
/// when the "onFinish" event is triggered in a wizard. It contains a map
/// of step numbers to dynamic data.
class OnFinishEvent {
  /// Creates an instance of `OnFinishEvent` with the specified data.
  ///
  /// The [data] parameter is a map containing step numbers as keys and dynamic
  /// data associated with each step.
  OnFinishEvent({required this.data});

  /// The data associated with each step, where the key is the step number.
  final Map<int, dynamic> data;
}
