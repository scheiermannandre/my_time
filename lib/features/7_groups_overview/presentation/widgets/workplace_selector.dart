import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/value_selector.dart';

/// A widget that allows the user to select a workplace.
class WorkplaceSelector extends StatelessWidget {
  /// Constructor for the WorkplaceSelector widget.
  const WorkplaceSelector({
    required this.workplace,
    required this.onChoose,
    this.onCancel,
    super.key,
  });

  /// The workplace to be displayed.
  final Workplace? workplace;

  /// The callback to be called when a workplace is chosen.
  final void Function(Workplace?) onChoose;

  /// The callback to be called when the user cancels the selection.
  final void Function()? onCancel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueSelector(
          options: Workplace.values.map((e) => e.label(context)).toList(),
          data: workplace?.label(context),
          onChoose: (value) {
            var workplace = Workplace.remote;
            if (value == Workplace.remote.label(context)) {
              workplace = Workplace.remote;
            } else if (value == Workplace.office.label(context)) {
              workplace = Workplace.office;
            } else //if (value == Workplace.homeOffice.label(context))
            {
              workplace = Workplace.homeOffice;
            }
            onChoose.call(workplace);
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
