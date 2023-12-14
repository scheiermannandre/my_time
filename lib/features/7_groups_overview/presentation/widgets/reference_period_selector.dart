import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/value_selector.dart';

/// A widget that allows the user to select a reference period.
class ReferencePeriodSelector extends StatelessWidget {
  /// Constructor for the ReferencePeriodSelector widget.
  const ReferencePeriodSelector({
    required this.referencePeriod,
    required this.onChoose,
    this.onCancel,
    super.key,
  });

  /// The reference period to be displayed.
  final ReferencePeriod? referencePeriod;

  /// The callback to be called when a reference period is chosen.
  final void Function(ReferencePeriod?) onChoose;

  /// The callback to be called when the user cancels the selection.
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueSelector(
          options: ReferencePeriod.values.map((e) => e.label(context)).toList(),
          horizontalPadding: 0,
          data: referencePeriod?.label(context) ?? '',
          onChoose: (option) {
            var period = ReferencePeriod.annually;
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
            onChoose.call(period);
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
