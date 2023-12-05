import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/string_extension.dart';
import 'package:my_time/core/widgets/dropdown.dart';
import 'package:my_time/core/widgets/text_input_field.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/add_project_wizard/value_selector.dart';

/// Step 7: Money Management Step in a wizard.
class Step7MoneyManagement extends StatelessWidget {
  /// Constructor for the Step7MoneyManagement widget.
  const Step7MoneyManagement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<ProjectMoneyManagementEntity?>(
      title: context.loc.step7Title,
      stepNumber: 6,
      showNextBtn: true,
      isSkipable: true,
      isNextBtnEnabled: false,
      userInfo: WizardStepInfo(
        title: context.loc.step7InfoTitle,
        description: context.loc.stepInfoMessageMultipleValues,
      ),
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _MoneyManagementStep(
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

class _MoneyManagementStep extends StatefulHookWidget {
  const _MoneyManagementStep({
    required this.saveProjectTimeManagement,
    required this.enableNext,
    required this.disableNext,
    required this.data,
  });
  final ProjectMoneyManagementEntity? data;

  final void Function(ProjectMoneyManagementEntity) saveProjectTimeManagement;
  final VoidCallback enableNext;
  final VoidCallback disableNext;

  @override
  State<_MoneyManagementStep> createState() => _MoneyManagementStepState();
}

class _MoneyManagementStepState extends State<_MoneyManagementStep> {
  PaymentInterval? paymentInterval;
  Currency? currency;
  double? payment;
  bool isPaymentIntervalSet = false;
  bool isCurrencySet = false;

  @override
  void initState() {
    paymentInterval = widget.data?.paymentInterval;
    isPaymentIntervalSet = widget.data != null;
    currency = widget.data?.currency;
    isCurrencySet = widget.data != null;
    super.initState();
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.step7ValidationEmpty;
    }
    final result = value.isNumeric();

    if (!result.result || result.number.isNegative) {
      return context.loc.step7ValidationInvalidChars;
    }

    return null;
  }

  void saveData() {
    widget.saveProjectTimeManagement(
      ProjectMoneyManagementEntity(
        paymentInterval: paymentInterval,
        currency: currency,
        payment: payment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amountTextController =
        useTextEditingController(text: widget.data?.payment.toString() ?? '');

    final payAmountFocusNode = useFocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueSelector(
              labelText: context.loc.step7PaymentIntervalInputLabel,
              data: widget.data?.paymentInterval?.label(context) ?? '',
              onChoose: (option) {
                setState(() {
                  isPaymentIntervalSet = true;

                  if (option == PaymentInterval.hourly.label(context)) {
                    paymentInterval = PaymentInterval.hourly;
                  } else if (option == PaymentInterval.daily.label(context)) {
                    paymentInterval = PaymentInterval.daily;
                  } else if (option == PaymentInterval.weekly.label(context)) {
                    paymentInterval = PaymentInterval.weekly;
                  } else //if(option == PaymentInterval.monthly.label(context))
                  {
                    paymentInterval = PaymentInterval.monthly;
                  }
                });

                saveData();
              },
              options:
                  PaymentInterval.values.map((e) => e.label(context)).toList(),
              horizontalPadding: 0,
            ),
            const SizedBox(height: SpaceTokens.medium),
            Visibility(
              visible: isPaymentIntervalSet,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.step7CurrencyInputLabel,
                  ),
                  const SizedBox(
                    height: SpaceTokens.verySmall,
                  ),
                  DropDownTile(
                    initialValue: widget.data?.currency?.label ?? '',
                    values: Currency.values.map((e) => e.label).toList(),
                    onValueChanged: (newValue) {
                      setState(() {
                        isCurrencySet = true;
                        currency = Currency.values.firstWhere(
                          (currency) => currency.label == newValue,
                        );
                      });
                      payAmountFocusNode.requestFocus();
                      saveData();
                    },
                  ),
                ],
              ).animate().fadeIn(),
            ),
            const SizedBox(height: SpaceTokens.large),
            Visibility(
              visible: isCurrencySet && isPaymentIntervalSet,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputField(
                    labelText: context.loc.step7PaymentInputLabel(
                      paymentInterval?.label(context) ?? '',
                      currency?.label ?? '',
                    ),
                    onChanged: (value, isValid) {
                      if (!isValid) {
                        widget.disableNext();
                        return;
                      }
                      payment = double.parse(value);
                      saveData();
                      widget.enableNext();
                    },
                    validator: validate,
                    focusNode: payAmountFocusNode,
                    controller: amountTextController,
                    onEditingComplete: FocusScope.of(context).unfocus,
                  ),
                ],
              ).animate().fadeIn(),
            ),
          ],
        ),
      ),
    );
  }
}
