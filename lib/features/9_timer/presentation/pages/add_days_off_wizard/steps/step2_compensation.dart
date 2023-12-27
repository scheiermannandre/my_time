import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/payment_status_selector.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/add_days_off_wizard.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 2 of the AddDaysOffWizard.
class Step2Compensation extends StatelessWidget {
  /// Constructor for the Step2Compensation widget.
  const Step2Compensation({super.key});

  @override
  Widget build(BuildContext context) {
    final project = AddDaysOffWizardInherited.of(context)!.project;
    final entryType = AddDaysOffWizardInherited.of(context)!.entryType;
    return WizardStepWrapper<PaymentStatus?>(
      title: context.loc.entryCompensationLabel,
      stepNumber: 1,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        var paymentStatus = data;
        if (data == null) {
          if (entryType == EntryType.sick) {
            paymentStatus = project.sickDaysPayment;
          } else if (entryType == EntryType.vacation) {
            paymentStatus = project.vacationInfo?.paymentStatus ?? data;
          } else //if(entryType == EntryType.publicHoliday)
          {
            paymentStatus = project.publicHolidaysPayment;
          }
        }

        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: PaymentStatusSelection(
            paymentStatus: paymentStatus,
            onChoose: (date) {
              controller
                ..saveData(date)
                ..next();
            },
            onSave: (date) {
              controller.saveData(date);
            },
          ),
        );
      },
    );
  }
}

/// Widget for selecting the payment status.
class PaymentStatusSelection extends StatefulWidget {
  /// Constructor for the PaymentStatusSelection widget.
  const PaymentStatusSelection({
    required this.onChoose,
    required this.paymentStatus,
    required this.onSave,
    super.key,
  });

  /// The payment status.
  final PaymentStatus? paymentStatus;

  /// The function to call when a payment status is chosen.
  final void Function(PaymentStatus?) onChoose;

  /// The function to call when the payment status is saved.
  final void Function(PaymentStatus?) onSave;

  @override
  State<PaymentStatusSelection> createState() => _PaymentStatusSelectionState();
}

class _PaymentStatusSelectionState extends State<PaymentStatusSelection> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSave(widget.paymentStatus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaymentStatusSelector(
      paymentStatus: widget.paymentStatus,
      onChoose: widget.onChoose,
    );
  }
}
