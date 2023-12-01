import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/string_extension.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 5: Vacation Days Selection Step in a wizard.
class Step5VacationInfo extends ConsumerWidget {
  /// Constructor for the Step5VacationInfo widget.
  const Step5VacationInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(mightyThemeControllerProvider.notifier);
    ref.watch(mightyThemeControllerProvider);
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
            themeController: themeController,
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
    required this.themeController,
    required this.data,
  });
  final MightyThemeController themeController;
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
  @override
  void initState() {
    _areVacationDaysSet = widget.data?.days != null;
    super.initState();
  }

  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.step5ValidationEmpty;
    }
    final result = value.isNumeric();

    if (!result.result || result.number.isNegative) {
      return context.loc.step5ValidationInvalidChars;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textController =
        useTextEditingController(text: widget.data?.days.toString() ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SpaceTokens.small),
          MightyTextFormField(
            labelText: context.loc.step5HolidaysInputLabel,
            onChanged: (value, isValid) {
              setState(() {
                _areVacationDaysSet = isValid;
              });
              if (!isValid) {
                widget.disableNext();
                return;
              }

              if (paymentStatus != null) {
                widget.enableNext();
              }
              widget.saveVacationInfo(VacationEntity(days: int.parse(value)));
            },
            validator: (value) => validate(context, value),
            controller: textController,
            mightyThemeController: widget.themeController,
            autofocus: widget.data == null,
            onEditingComplete: () {
              if (validate(context, textController.text) != null) return;
              setState(() {
                _finishedEditingVacationDays = true;
              });
              FocusScope.of(context).unfocus();
            },
          ),
          const SizedBox(height: SpaceTokens.large),
          Visibility(
            visible: _finishedEditingVacationDays,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueSelector(
                  labelText: context.loc.step5PaymentStatusLabel,
                  options: PaymentStatus.values
                      .map((e) => e.label(context))
                      .toList(),
                  horizontalPadding: 0,
                  themeController: widget.themeController,
                  data: widget.data?.paymentStatus?.label(context) ?? '',
                  onChoose: (value) {
                    setState(() {
                      if (value == PaymentStatus.paid.label(context)) {
                        paymentStatus = PaymentStatus.paid;
                      } else //if (value == PaymentStatus.unpaid.label(context))
                      {
                        paymentStatus = PaymentStatus.unpaid;
                      }
                    });

                    if (!_areVacationDaysSet || !_finishedEditingVacationDays) {
                      widget.disableNext();
                      return;
                    }
                    widget.enableNext();

                    widget.saveVacationInfo(
                      VacationEntity(
                        paymentStatus: paymentStatus,
                        days: int.parse(textController.text),
                      ),
                    );
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
