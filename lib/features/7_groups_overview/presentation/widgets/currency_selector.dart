import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/domain/group_domain/models/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/value_selector.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';

/// A widget that allows the user to select a currency.
class CurrencySelector extends StatelessWidget {
  /// Constructor for the CurrencySelector widget.
  const CurrencySelector({
    required this.currency,
    required this.onChoose,
    this.onCancel,
    super.key,
  });

  /// The currency to be displayed.
  final Currency? currency;

  /// The callback to be called when a currency is chosen.
  final void Function(Currency?) onChoose;

  /// The callback to be called when the user cancels the selection.
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 535,
          child: SingleChildScrollView(
            child: ValueSelector(
              options: Currency.values.map((e) => e.label).toList(),
              horizontalPadding: 0,
              data: currency?.label ?? '',
              onChoose: (option) {
                final currency = Currency.values.firstWhere(
                  (currency) => currency.label == option,
                );

                onChoose.call(currency);
              },
            ),
          ),
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
