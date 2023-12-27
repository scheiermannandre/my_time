import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

/// A customizable text form field with theming support.
class TextInputField extends StatefulWidget {
  /// Constructs a [TextInputField] with the required parameters.
  const TextInputField({
    this.labelText,
    this.hintText,
    this.controller,
    super.key,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.onEditingComplete,
    this.focusNode,
    this.readOnly = false,
    this.textInputType,
    this.suffixIcon,
    this.onTap,
    this.fieldKey,
    this.onFocus,
    this.onFocusLost,
    this.initialValue,
    this.maxLines = 1,
  });

  /// The type of keyboard to display for text input.
  static TextInputType get number => TextInputType.number;

  /// The theme controller for adapting the field's appearance.

  /// The label text to display above the text field.
  final String? labelText;

  /// The hint text to display in the text field when it's empty.
  final String? hintText;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Determines whether the text is obscured (e.g., for password input).
  final bool obscureText;

  /// The type of keyboard to display for text input.
  final TextInputType keyboardType;

  /// Validator function for input validation.
  final FormFieldValidator<String>? validator;

  /// Callback function triggered when the field's value changes.
  // ignore: avoid_positional_boolean_parameters
  final void Function(String value, bool isValid)? onChanged;

  /// Callback function triggered when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Determines whether the field should automatically focus when rendered.
  final bool autofocus;

  /// The focus node that controls the focus state of the field.
  final FocusNode? focusNode;

  /// Determines whether the field is in read-only mode.
  final bool readOnly;

  /// The type of keyboard to display for text input.
  final TextInputType? textInputType;

  /// The icon to display at the end of the text field.
  final Widget? suffixIcon;

  /// Callback function triggered when the field is tapped.
  final VoidCallback? onTap;

  /// The key to use for the form field.
  final GlobalKey<FormFieldState<String>>? fieldKey;

  /// Callback function triggered when the field gains focus.
  final VoidCallback? onFocus;

  /// Callback function triggered when the field loses focus.
  final VoidCallback? onFocusLost;

  /// The initial value of the text field.
  final String? initialValue;

  /// The maximum number of lines to display in the text field.
  final int? maxLines;
  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late final GlobalKey<FormFieldState<String>> _fieldKey;
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _fieldKey = widget.fieldKey ?? GlobalKey<FormFieldState<String>>();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue ?? '';
  }

  bool hasError = false;

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.textInputType == null) {
      return null;
    }
    if (widget.textInputType == TextInputField.number) {
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
          ),
        if (widget.labelText != null)
          const SizedBox(
            height: SpaceTokens.verySmall,
          ),
        Focus(
          onFocusChange: (hasFocus) async {
            if (!hasFocus) {
              widget.onFocusLost?.call();
              Future.delayed(const Duration(milliseconds: 200), () {
                if (!context.mounted) return;
                setState(() {
                  hasError = !_fieldKey.currentState!.validate();
                });
              });
            } else {
              widget.onFocus?.call();
            }
          },
          child: TextFormField(
            maxLines: widget.maxLines,
            inputFormatters: _getInputFormatters(),
            onTap: widget.onTap,
            key: _fieldKey,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            onChanged: (value) {
              setState(() {
                hasError = !_fieldKey.currentState!.validate();
                widget.onChanged?.call(value, !hasError);
              });
            },
            focusNode: widget.focusNode,
            controller: _controller,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorMaxLines: 3,
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpaceTokens.mediumSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasError)
                      const Icon(Icons.close, color: ThemelessColorTokens.red),
                    if (hasError && widget.suffixIcon != null)
                      const SizedBox(width: SpaceTokens.small),
                    if (widget.suffixIcon != null) widget.suffixIcon!,
                  ],
                ),
              ),
            ),
            onEditingComplete: widget.onEditingComplete,
            validator: (value) {
              return widget.validator?.call(value);
            },
          ),
        ),
      ],
    );
  }
}