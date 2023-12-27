import 'package:flutter/material.dart';
import 'package:my_time/foundation/core/widgets/wizard/contracts/step_to_controller_contract.dart';
import 'package:my_time/foundation/core/widgets/wizard/events/on_next_event.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_controller.dart';

/// A StatefulWidget that listens to the "next" event of a
/// [WizardStepController].
class WizardStepEventListener extends StatefulWidget {
  /// Constructs a [WizardStepEventListener] widget.
  ///
  /// The [child] is the content of the widget.
  /// The [controller] is a [StepToControllerContract] that must be a [
  /// WizardStepController].
  /// The [onNextEvent] is a callback function that takes an [OnNextEvent].
  const WizardStepEventListener({
    required this.child,
    required StepToControllerContract<dynamic> controller,
    required this.onNextEvent,
    super.key,
  }) : _controller = controller as WizardStepController;

  /// The [WizardStepController] responsible for managing the wizard step.
  final WizardStepController<dynamic> _controller;

  /// The callback function to be executed when the "next" event occurs.
  final void Function(OnNextEvent) onNextEvent;

  /// The content of the widget.
  final Widget child;

  @override
  State<WizardStepEventListener> createState() =>
      _WizardStepEventListenerState();
}

class _WizardStepEventListenerState extends State<WizardStepEventListener> {
  @override
  void initState() {
    super.initState();
    widget._controller.onNextEvent.subscribe(widget.onNextEvent);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
