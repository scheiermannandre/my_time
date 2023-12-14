import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/value_selector.dart';

/// A widget that allows the user to select a payment interval.
class PaymentIntervalSelector extends StatelessWidget {
  /// Constructor for the PaymentIntervalSelector widget.
  const PaymentIntervalSelector({
    required this.paymentInterval,
    required this.onChoose,
    this.onCancel,
    super.key,
  });

  /// The payment interval to be displayed.
  final PaymentInterval? paymentInterval;

  /// The callback to be called when a payment interval is chosen.
  final void Function(PaymentInterval?) onChoose;

  /// The callback to be called when the user cancels the selection.
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueSelector(
          options: PaymentInterval.values.map((e) => e.label(context)).toList(),
          horizontalPadding: 0,
          data: paymentInterval?.label(context) ?? '',
          onChoose: (option) {
            var paymentInterval = PaymentInterval.hourly;

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
            onChoose.call(paymentInterval);
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
