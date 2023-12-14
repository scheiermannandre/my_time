import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/value_selector.dart';

/// A widget that allows the user to select a payment status.
class PaymentStatusSelector extends StatelessWidget {
  /// Constructor for the PaymentStatusSelector widget.
  const PaymentStatusSelector({
    required this.paymentStatus,
    required this.onChoose,
    this.onCancel,
    super.key,
  });

  /// The payment status to be displayed.
  final PaymentStatus? paymentStatus;

  /// The callback to be called when a payment status is chosen.
  final void Function(PaymentStatus?) onChoose;

  /// The callback to be called when the user cancels the selection.
  final void Function()? onCancel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueSelector(
          options: PaymentStatus.values.map((e) => e.label(context)).toList(),
          data: paymentStatus?.label(context),
          onChoose: (value) {
            var paymentStatus = PaymentStatus.paid;
            if (value == PaymentStatus.paid.label(context)) {
              paymentStatus = PaymentStatus.paid;
            } else {
              paymentStatus = PaymentStatus.unpaid;
            }
            onChoose.call(paymentStatus);
          },
        ),
        Visibility(
          visible: onCancel != null,
          child: Padding(
            padding: const EdgeInsets.only(top: SpaceTokens.medium),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionButton.text(
                    onPressed: () async {
                      onCancel?.call();
                    },
                    child: Text(context.loc.cancelBtnLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
