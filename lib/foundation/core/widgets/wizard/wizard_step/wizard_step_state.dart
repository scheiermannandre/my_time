import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Represents the state of a wizard step.
class WizardStepState<T> {
  /// Default constructor for initializing the state with default values.
  WizardStepState()
      : data = null,
        showNextBtn = true,
        isSkipable = false,
        isNextBtnEnabled = false,
        stepTitle = '',
        userInfo = null;

  /// Internal constructor for creating a [WizardStepState] with
  /// specific values.
  WizardStepState._internal({
    required this.data,
    required this.showNextBtn,
    required this.isSkipable,
    required this.isNextBtnEnabled,
    required this.stepTitle,
    required this.userInfo,
  });

  /// Factory constructor for creating a [WizardStepState] with specific
  /// values and no data.
  WizardStepState.factory({
    required this.showNextBtn,
    required this.isSkipable,
    required this.isNextBtnEnabled,
    required this.stepTitle,
    required this.userInfo,
  }) : data = null;

  /// The data associated with the wizard step.
  final T? data;

  /// Indicates whether the "Next" button should be displayed.
  final bool showNextBtn;

  /// Indicates whether the step can be skipped.
  final bool isSkipable;

  /// Indicates whether the "Next" button is enabled.
  final bool isNextBtnEnabled;

  /// The title of the wizard step.
  final String stepTitle;

  /// Additional information related to the wizard step.
  final WizardStepInfo? userInfo;

  /// Creates a new [WizardStepState] with the specified values,
  /// replacing the existing values.
  WizardStepState<T> copyWith({
    T? data,
    bool? showNextBtn,
    bool? isSkipable,
    bool? isNextBtnEnabled,
    String? stepTitle,
    WizardStepInfo? userInfo,
  }) {
    return WizardStepState<T>._internal(
      data: data ?? this.data,
      showNextBtn: showNextBtn ?? this.showNextBtn,
      isSkipable: isSkipable ?? this.isSkipable,
      isNextBtnEnabled: isNextBtnEnabled ?? this.isNextBtnEnabled,
      stepTitle: stepTitle ?? this.stepTitle,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
