import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/foundation/core/widgets/wizard/contracts/step_to_controller_contract.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_controller.dart';

/// Information associated with a wizard step.
class WizardStepInfo {
  /// Creates a [WizardStepInfo] with the specified title and description.
  const WizardStepInfo({
    required this.title,
    required this.description,
  });

  /// The title of the wizard step.
  final String title;

  /// The description or additional information about the wizard step.
  final String description;
}

/// A function type for building the content of a wizard step.
typedef StepBuilder<T> = Widget Function(
  BuildContext context,
  T? data,
  StepToControllerContract<dynamic> controller,
);

/// Wrapper for a wizard step that provides necessary configurations.
class WizardStepWrapper<T> extends ConsumerStatefulWidget {
  /// Creates a [WizardStepWrapper] with the specified configurations.
  const WizardStepWrapper({
    required this.stepNumber,
    required this.title,
    required this.isNextBtnEnabled,
    required this.showNextBtn,
    required this.isSkipable,
    required this.builder,
    this.userInfo,
    super.key,
  });

  /// The builder function for creating the content of the wizard step.
  final StepBuilder<T> builder;

  /// The step number in the wizard sequence.
  final int stepNumber;

  /// Indicates whether the "Next" button is enabled for this step.
  final bool isNextBtnEnabled;

  /// Indicates whether the "Next" button should be displayed for this step.
  final bool showNextBtn;

  /// Indicates whether this step can be skipped.
  final bool isSkipable;

  /// The title of the wizard step.
  final String title;

  /// Additional information about the wizard step.
  final WizardStepInfo? userInfo;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WizardStepWrapperV2State<T>();
}

class _WizardStepWrapperV2State<T> extends ConsumerState<WizardStepWrapper<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wizardStepControllerProvider(widget.stepNumber).notifier)
          .initState(
            isNextBtnEnabled: widget.isNextBtnEnabled,
            isSkipable: widget.isSkipable,
            showNextBtn: widget.showNextBtn,
            title: widget.title,
            userInfo: widget.userInfo,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(wizardStepControllerProvider(widget.stepNumber).notifier);

    final state = ref.watch(wizardStepControllerProvider(widget.stepNumber));

    return widget.builder(
      context,
      state.data as T?,
      controller,
    );
  }
}
