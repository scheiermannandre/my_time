import 'package:flutter/material.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_controller.dart';

/// A widget that listens to events from a [WizardController].
class WizardEventListener extends StatefulWidget {
  /// Creates a [WizardEventListener] widget.
  const WizardEventListener({
    required this.child,
    required this.controller,
    required this.onFinish,
    super.key,
  });

  /// The [WizardController] to listen to for events.
  final WizardController controller;

  /// Callback function to be invoked when the wizard finishes.
  final void Function(int) onFinish;

  /// The content of the widget.
  final Widget child;

  @override
  State<WizardEventListener> createState() => _WizardEventListenerState();
}

class _WizardEventListenerState extends State<WizardEventListener> {
  @override
  void initState() {
    super.initState();
    widget.controller.wizardEventStream.subscribe(widget.onFinish);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
