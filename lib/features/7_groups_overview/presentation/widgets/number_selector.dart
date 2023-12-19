import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/number_picker.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/core/widgets/text_input_field.dart';

/// A widget that allows the user to select a number.
class NumberSelector extends StatefulWidget {
  /// Constructor for the NumberSelector widget.
  const NumberSelector({
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
    this.bigValues = false,
    this.minValue = 1,
    this.maxValue = 100,
    this.step = 1,
    super.key,
  });

  /// The initial value to be displayed.
  final int initialValue;

  /// The callback to be called when a number is chosen.
  final void Function(int) onSave;

  /// The callback to be called when the user cancels the selection.
  final void Function() onCancel;

  /// The minimum value to be displayed.
  final int minValue;

  /// The maximum value to be displayed.
  final int maxValue;

  /// The step between values.
  final int step;

  /// Whether to use a text input field or a number picker.
  final bool bigValues;
  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  int _currentValue = 0;
  bool isNumberPicker = true;

  @override
  void initState() {
    _currentValue = widget.initialValue;
    isNumberPicker = !widget.bigValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.loc.numberSelectorValueLabel(_currentValue),
                style: TextStyleTokens.body(null),
              ),
            ),
            ActionButton.icon(
              child: Icon(isNumberPicker ? Icons.edit_outlined : Icons.numbers),
              onPressed: () {
                setState(() {
                  isNumberPicker = !isNumberPicker;
                });
              },
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: isNumberPicker
              ? NumberPicker.styled(
                  context: context,
                  axis: Axis.horizontal,
                  value: _currentValue,
                  minValue: widget.minValue,
                  maxValue: widget.maxValue,
                  step: widget.step,
                  onChanged: (value) => setState(() => _currentValue = value),
                )
              : TextInputField(
                  initialValue: _currentValue.toString(),
                  keyboardType: TextInputField.number,
                  textInputType: TextInputField.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null ||
                          parsedValue < widget.minValue ||
                          parsedValue > widget.maxValue) {
                        return context.loc.numberSelectorValidatorMessage(
                          widget.minValue,
                          widget.maxValue,
                        );
                      }
                    }
                    return null;
                  },
                  onChanged: (value, isValid) {
                    if (!isValid) return;
                    setState(() {
                      _currentValue = int.parse(
                        value.isNotEmpty ? value : widget.minValue.toString(),
                      );
                    });
                  },
                ),
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
              ActionButton.text(
                onPressed: () async {
                  widget.onSave.call(_currentValue);
                },
                child: Text(context.loc.saveBtnLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
