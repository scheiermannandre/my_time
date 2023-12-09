import 'package:flutter/material.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step_controller.dart';

/// Widget that listens to events from a [WizardReviewStepController].
///
/// The `WizardReviewStepEventListener` widget is designed to be a parent widget
/// for the wizard review step. It listens to events from the provided
/// [controller] and triggers the onFinishEvent callback when the "onFinish"
/// event occurs.
class WizardReviewStepEventListener extends StatefulWidget {
  /// Creates a [WizardReviewStepEventListener] widget.
  ///
  /// The [child] is the content of the review step.
  /// The [controller] is the [WizardReviewStepController] associated with the
  /// review step.
  /// "onFinish" event occurs.
  const WizardReviewStepEventListener({
    required this.child,
    required this.controller,
    super.key,
  });

  /// The content of the review step.
  final Widget child;

  /// The [WizardReviewStepController] associated with the review step.
  final WizardReviewStepController controller;

  /// Callback function triggered when the "onFinish" event occurs.
  //final Future<void> Function(OnFinishEvent event)? onFinishEvent;

  @override
  State<WizardReviewStepEventListener> createState() =>
      _WizardReviewStepEventListenerState();
}

class _WizardReviewStepEventListenerState
    extends State<WizardReviewStepEventListener> {
  @override
  void initState() {
    super.initState();
    // if (widget.onFinishEvent != null) {
    //   widget.controller.onFinishEvent = widget.onFinishEvent;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
