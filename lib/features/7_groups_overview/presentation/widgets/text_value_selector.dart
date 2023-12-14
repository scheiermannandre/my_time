import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/core/widgets/text_input_field.dart';

/// A widget that allows the user to select a text value.
class TextValueSelector extends StatefulHookWidget {
  /// Constructor for the TextValueSelector widget.
  const TextValueSelector({
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
    required this.validationEmptyMessage,
    super.key,
  });

  /// The initial value to be displayed.
  final String initialValue;

  /// The callback to be called when a text value is chosen.
  final void Function(String?) onSave;

  /// The callback to be called when the user cancels the selection.
  final void Function() onCancel;

  /// The validation message to be displayed when the text value is empty.
  final String validationEmptyMessage;

  @override
  State<TextValueSelector> createState() => _TextValueSelectorState();
}

class _TextValueSelectorState extends State<TextValueSelector> {
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: widget.initialValue);
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      children: [
        TextInputField(
          controller: textController,
          initialValue: widget.initialValue,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.validationEmptyMessage;
            }
            return null;
          },
          onChanged: (value, isValid) {
            setState(() {
              _isValid = isValid;
            });
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
              ActionButton.text(
                onPressed: _isValid
                    ? () async {
                        widget.onSave.call(textController.text);
                      }
                    : null,
                child: Text(context.loc.saveBtnLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
