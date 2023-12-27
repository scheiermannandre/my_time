import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wizard_review_step_controller.g.dart';

/// Riverpod controller for managing the review step in a wizard.
///
/// The `WizardReviewStepController` class extends the generated
/// `_$WizardReviewStepController` class and implements the
/// `WizardToReviewStepContract` mixin to handle interactions with the
/// review step.
@riverpod
class WizardReviewStepController extends _$WizardReviewStepController
//with WizardToReviewStepContract
{
  /// Callback function for the "onFinish" event.
  //Future<void> Function(OnFinishEvent)? onFinishEvent;

  /// Initializes the controller and sets up cleanup on disposal.
  ///
  /// The [stepNumber] parameter indicates the step number of the review step.
  @override
  void build(int stepNumber) {
    // ref.onDispose(() {
    //   onFinishEvent = null;
    // });
  }

  /// Sets the finish button to enabled.
  void enableFinish() {
    ref
        .read(wizardControllerProvider.notifier)
        .setReviewPageFinishEnabled(true);
  }

  /// Sets the finish button to disabled.
  void disableFinish() {
    ref
        .read(wizardControllerProvider.notifier)
        .setReviewPageFinishEnabled(false);
  }

  /// Invokes the "onFinish" event with the provided [data].
  ///
  /// This method is called when the user finishes the wizard, and it triggers
  /// the associated [onFinishEvent] callback.
  // @override
  // Future<void> invokeOnFinish(Map<int, dynamic> data) async {
  //   if (onFinishEvent != null) {
  //     await onFinishEvent!(OnFinishEvent(data: data));
  //   }
  // }
}
