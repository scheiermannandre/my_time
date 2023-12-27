import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_controller.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_controller.dart';

/// Wrapper widget for a wizard review step.
///
/// The `WizardReviewStepWrapper` is a `ConsumerWidget` that listens to the
/// state of the wizard step with the specified [stepToJumpTo] and builds the
/// UI using the provided [builder] function. It includes a `GestureDetector`
/// that triggers a jump to the specified step when tapped, allowing for a
/// quick navigation to the targeted step in the wizard.
class WizardReviewStepWrapper<T> extends ConsumerWidget {
  /// Creates a [WizardReviewStepWrapper] widget.
  ///
  /// The [stepToJumpTo] parameter specifies the step number to jump to.
  /// The [builder] parameter is a function that builds the UI based on the
  /// data of the wizard step.
  const WizardReviewStepWrapper({
    required this.stepToJumpTo,
    required this.builder,
    super.key,
  });

  /// The step number to jump to.
  final int stepToJumpTo;

  /// Function that builds the UI based on the data of the wizard step.
  final Widget Function(T? data) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wizardStepControllerProvider(stepToJumpTo));

    return Card(
      child: ListTile(
        onTap: () {
          ref.read(wizardControllerProvider.notifier).jumpPage(stepToJumpTo);
        },
        title: AbsorbPointer(
          child: builder(state.data as T?),
        ),
      ),
    );
  }
}

/// Wrapper widget for a wizard review step for showing data that is
/// accumulated over multiple steps.
class WizardReviewStepAccumulatedWrapper extends ConsumerWidget {
  /// Creates a [WizardReviewStepAccumulatedWrapper] widget.
  const WizardReviewStepAccumulatedWrapper({
    required this.steps,
    required this.builder,
    super.key,
  });

  /// The step number to jump to.
  final List<int> steps;

  /// Function that builds the UI based on the data of the wizard step.
  final Widget Function(Map<int, dynamic> data) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = <int, dynamic>{};

    for (final step in steps) {
      final state = ref.watch(wizardStepControllerProvider(step));
      data[step] = state.data;
    }
    return Card(
      child: ListTile(
        title: AbsorbPointer(
          child: builder(data),
        ),
      ),
    );
  }
}

/// Wrapper widget for a wizard review step for showing data that is not
/// gathered via the wizard.
class WizardReviewStepDataWrapper extends StatelessWidget {
  /// Creates a [WizardReviewStepDataWrapper] widget.
  const WizardReviewStepDataWrapper({
    required this.builder,
    super.key,
  });

  /// Function that builds the UI based on the data of the wizard step.
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: AbsorbPointer(
          child: builder(),
        ),
      ),
    );
  }
}