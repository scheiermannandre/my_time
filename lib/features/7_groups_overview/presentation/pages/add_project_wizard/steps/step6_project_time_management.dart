import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/util/extentions/string_extension.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 6: Project Time Management Step in a wizard.
class Step6ProjectTimeManagement extends ConsumerWidget {
  /// Constructor for the Step6ProjectTimeManagement widget.
  const Step6ProjectTimeManagement({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(mightyThemeControllerProvider.notifier);
    ref.watch(mightyThemeControllerProvider);
    return WizardStepWrapper<ProjectTimeManagementEntity?>(
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
            themeController: themeController,
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
    required this.themeController,
    required this.data,
  });
  final MightyThemeController themeController;
  final ProjectTimeManagementEntity? data;

  final void Function(ProjectTimeManagementEntity) saveProjectTimeManagement;
  final VoidCallback enableNext;
  final VoidCallback disableNext;

  @override
  State<_TimeManagementStep> createState() => _TimeManagementStepState();
}

class _TimeManagementStepState extends State<_TimeManagementStep> {
  ReferencePeriod? period;
  int? workingHours;
  bool isReferencePeriodSet = false;

  @override
  void initState() {
    period = widget.data?.referencePeriod;
    isReferencePeriodSet = widget.data != null;
    super.initState();
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.step6ValidationEmpty;
    }
    final result = value.isNumeric();

    if (!result.result || result.number.isNegative) {
      return context.loc.step6ValidationInvalidChars;
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
          ValueSelector(
            labelText: context.loc.step6ReferencePeriodInputLabel,
            themeController: widget.themeController,
            data: widget.data?.referencePeriod?.label(context) ?? '',
            onChoose: (option) {
              setState(() {
                isReferencePeriodSet = true;
                if (option == ReferencePeriod.annually.label(context)) {
                  period = ReferencePeriod.annually;
                } else if (option == ReferencePeriod.monthly.label(context)) {
                  period = ReferencePeriod.monthly;
                } else if (option == ReferencePeriod.weekly.label(context)) {
                  period = ReferencePeriod.weekly;
                } else //if (option == ReferencePeriod.daily.label(context))
                {
                  period = ReferencePeriod.daily;
                }
              });
              widget.saveProjectTimeManagement(
                ProjectTimeManagementEntity(
                  referencePeriod: period,
                  workingHours: workingHours,
                ),
              );
            },
            options:
                ReferencePeriod.values.map((e) => e.label(context)).toList(),
            horizontalPadding: 0,
          ),
          const SizedBox(height: SpaceTokens.large),
          Visibility(
            visible: isReferencePeriodSet,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MightyTextFormField(
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
                      ProjectTimeManagementEntity(
                        referencePeriod: period,
                        workingHours: int.parse(value),
                      ),
                    );
                  },
                  validator: validate,
                  controller: textController,
                  mightyThemeController: widget.themeController,
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
