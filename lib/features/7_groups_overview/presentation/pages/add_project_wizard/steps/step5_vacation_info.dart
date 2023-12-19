import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/number_picker.dart';
import 'package:my_time/core/widgets/wizard/labeled_widgets.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/payment_status_selector.dart';

/// Step 5: Vacation Days Selection Step in a wizard.
class Step5VacationInfo extends StatelessWidget {
  /// Constructor for the Step5VacationInfo widget.
  const Step5VacationInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<VacationEntity?>(
      title: context.loc.step5Title,
      stepNumber: 4,
      showNextBtn: true,
      isNextBtnEnabled: false,
      isSkipable: true,
      userInfo: WizardStepInfo(
        title: context.loc.step5InfoTitle,
        description: context.loc.stepInfoMessageMultipleValues,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _VacationDaysStep(
            data: data,
            saveVacationInfo: controller.saveData,
            enableNext: controller.enableNext,
            disableNext: controller.disableNext,
          ),
        );
      },
    );
  }
}

class _VacationDaysStep extends StatefulHookWidget {
  const _VacationDaysStep({
    required this.saveVacationInfo,
    required this.enableNext,
    required this.disableNext,
    required this.data,
  });
  final VacationEntity? data;

  final void Function(VacationEntity) saveVacationInfo;
  final VoidCallback enableNext;
  final VoidCallback disableNext;

  @override
  State<_VacationDaysStep> createState() => _VacationDaysStepState();
}

class _VacationDaysStepState extends State<_VacationDaysStep> {
  PaymentStatus? paymentStatus;
  bool _areVacationDaysSet = false;
  bool _finishedEditingVacationDays = false;
  int days = 1;
  @override
  void initState() {
    _areVacationDaysSet = widget.data?.days != null;
    super.initState();
  }

  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.step5ValidationEmpty;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SpaceTokens.small),
          LabeledWidgets(
            label: context.loc.step5HolidaysInputLabel,
            children: [
              Center(
                child: NumberPicker.styled(
                  context: context,
                  axis: Axis.horizontal,
                  minValue: 0,
                  maxValue: 120,
                  value: days,
                  onChanged: (value) {
                    setState(() {
                      days = value;
                      _areVacationDaysSet = true;
                    });
                    if (paymentStatus != null) {
                      widget.enableNext();
                    }
                    widget.saveVacationInfo(VacationEntity(days: value));
                    _finishedEditingVacationDays = true;
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: _finishedEditingVacationDays,
            child: Padding(
              padding: const EdgeInsets.only(top: SpaceTokens.medium),
              child: LabeledWidgets(
                label: context.loc.step5PaymentStatusLabel,
                children: [
                  PaymentStatusSelector(
                    paymentStatus: widget.data?.paymentStatus,
                    onChoose: (value) {
                      setState(() {
                        paymentStatus = value;
                      });
                      if (!_areVacationDaysSet ||
                          !_finishedEditingVacationDays) {
                        widget.disableNext();
                        return;
                      }
                      widget.enableNext();

                      widget.saveVacationInfo(
                        VacationEntity(
                          paymentStatus: paymentStatus,
                          days: days,
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}
