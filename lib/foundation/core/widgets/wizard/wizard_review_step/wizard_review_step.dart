import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step_controller.dart';

/// Wizard Review Step widget.
///
/// The `WizardReviewStep` is a `ConsumerWidget` that listens to the state
/// of the wizard review step with the specified [stepsLength] and builds the
/// UI using the provided [builder] function. It provides a
/// [WizardReviewStepController] to the builder,
/// allowing for interaction and control over the review step.
class WizardReviewStep extends ConsumerWidget {
  /// Creates a [WizardReviewStep] widget.
  ///
  /// The [stepsLength] parameter specifies the total number of steps in the
  /// wizard.
  /// The [builder] parameter is a function that builds the UI based on the
  /// provided [WizardReviewStepController].
  const WizardReviewStep({
    required this.stepsLength,
    required this.builder,
    super.key,
  });

  /// The total number of steps in the wizard.
  final int stepsLength;

  /// Function that builds the UI based on the provided
  /// [WizardReviewStepController].
  final Widget Function(WizardReviewStepController controller) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      wizardReviewStepControllerProvider(
        stepsLength,
      ).notifier,
    );
    return builder(controller);
  }
}
