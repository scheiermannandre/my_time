import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/9_timer/presentation/widgets/date_picker.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';

/// A widget that allows the user to select a number.
class DateSelector extends StatefulWidget {
  /// Constructor for the NumberSelector widget.
  const DateSelector({
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  /// The initial value to be displayed.
  final DateTime initialValue;

  /// The callback to be called when a number is chosen.
  final void Function(DateTime) onSave;

  /// The callback to be called when the user cancels the selection.
  final void Function() onCancel;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime _currentTime = DateTime.now();
  bool isNumberPicker = true;

  @override
  void initState() {
    _currentTime = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      children: <Widget>[
        DatePicker(
          data: [_currentTime],
          onSelect: (dates) {
            widget.onSave.call(dates.first!);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ActionButton.text(
                onPressed: () async {
                  widget.onCancel.call();
                },
                child: Text(context.loc.cancelBtnLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
