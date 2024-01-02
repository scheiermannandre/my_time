import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/domain/group_domain/models/enums/reference_period.dart';
import 'package:my_time/domain/group_domain/models/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/reference_period_selector.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/text_input_field.dart';
import 'package:my_time/foundation/core/widgets/wizard/labeled_widgets.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 6: Project Time Management Step in a wizard.
class Step6ProjectTimeManagement extends StatelessWidget {
  /// Constructor for the Step6ProjectTimeManagement widget.
  const Step6ProjectTimeManagement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<NewProjectTimeManagementModel?>(
      title: context.loc.step6Title,
      stepNumber: 5,
      showNextBtn: true,
      isSkipable: true,
      isNextBtnEnabled: false,
      userInfo: WizardStepInfo(
        title: context.loc.step6InfoTitle,
        description: context.loc.stepInfoMessageMultipleValues,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _TimeManagementStep(
            data: data,
            saveProjectTimeManagement: controller.saveData,
            enableNext: controller.enableNext,
            disableNext: controller.disableNext,
          ),
        );
      },
    );
  }
}

class _TimeManagementStep extends StatefulHookWidget {
  const _TimeManagementStep({
    required this.saveProjectTimeManagement,
    required this.enableNext,
    required this.disableNext,
    required this.data,
  });
  final NewProjectTimeManagementModel? data;

  final void Function(NewProjectTimeManagementModel) saveProjectTimeManagement;
  final VoidCallback enableNext;
  final VoidCallback disableNext;

  @override
  State<_TimeManagementStep> createState() => _TimeManagementStepState();
}

class _TimeManagementStepState extends State<_TimeManagementStep> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  ReferencePeriod? period;
  int? workingHours;
  bool isReferencePeriodSet = false;

  @override
  void initState() {
    period = widget.data?.referencePeriod;
    isReferencePeriodSet = widget.data != null;
    super.initState();
  }

  String? validate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.loc.step6ValidationEmpty;
    }

    final workingHours = int.tryParse(value);

    if (period == ReferencePeriod.daily && workingHours! > 24) {
      return context.loc
          .step6workingHourValidation(24, ReferencePeriod.daily.label(context));
    } else if (period == ReferencePeriod.weekly && workingHours! > 168) {
      return context.loc.step6workingHourValidation(
        168,
        ReferencePeriod.weekly.label(context),
      );
    } else if (period == ReferencePeriod.monthly && workingHours! > 744) {
      return context.loc.step6workingHourValidation(
        744,
        ReferencePeriod.monthly.label(context),
      );
    } else if (period == ReferencePeriod.annually && workingHours! > 8760) {
      return context.loc.step6workingHourValidation(
        8760,
        ReferencePeriod.annually.label(context),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(
      text: widget.data?.workingHours.toString() ?? '',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledWidgets(
            label: context.loc.step6ReferencePeriodInputLabel,
            children: [
              ReferencePeriodSelector(
                referencePeriod: period,
                onChoose: (value) {
                  setState(() {
                    isReferencePeriodSet = true;
                    period = value;
                  });
                  if (textController.text.isNotEmpty) {
                    _fieldKey.currentState?.validate();
                  }
                  widget.saveProjectTimeManagement(
                    NewProjectTimeManagementModel(
                      referencePeriod: period,
                      workingHours: workingHours,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: SpaceTokens.large),
          Visibility(
            visible: isReferencePeriodSet,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputField(
                  fieldKey: _fieldKey,
                  textInputType: TextInputField.number,
                  keyboardType: TextInputType.number,
                  labelText: context.loc.step6WorkingHoursInputLabel(
                    period?.label(context) ?? '',
                  ),
                  onChanged: (value, isValid) {
                    if (!isValid) {
                      widget.disableNext();
                      return;
                    }
                    widget.enableNext();
                    widget.saveProjectTimeManagement(
                      NewProjectTimeManagementModel(
                        referencePeriod: period,
                        workingHours: int.parse(value),
                      ),
                    );
                  },
                  validator: (value) => validate(value, context),
                  controller: textController,
                  autofocus: widget.data == null,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ).animate().fadeIn(),
          ),
        ],
      ),
    );
  }
}
