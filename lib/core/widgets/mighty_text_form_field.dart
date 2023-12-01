import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

/// A customizable text form field with theming support.
class MightyTextFormField extends StatefulWidget {
  /// Constructs a [MightyTextFormField] with the required parameters.
  const MightyTextFormField({
    required this.mightyThemeController,
    this.labelText,
    this.hintText,
    this.controller,
    super.key,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    // ignore: avoid_positional_boolean_parameters
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
  });

  /// The theme controller for adapting the field's appearance.
  final MightyThemeController mightyThemeController;

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
  @override
  State<MightyTextFormField> createState() => _MightyTextFormFieldState();
}

class _MightyTextFormFieldState extends State<MightyTextFormField> {
  late final GlobalKey<FormFieldState<String>> _fieldKey;
  @override
  void initState() {
    super.initState();
    _fieldKey = widget.fieldKey ?? GlobalKey<FormFieldState<String>>();
  }

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    final errorColor = widget.mightyThemeController.errorColor;
    final cursorColor =
        widget.mightyThemeController.themeMode == SystemThemeMode.light
            ? widget.mightyThemeController.nonDecorativeBorderColor
            : widget.mightyThemeController.actionsColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: widget.mightyThemeController.small,
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
            cursorColor: cursorColor,
            controller: widget.controller,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpaceTokens.mediumSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasError) Icon(Icons.close, color: errorColor),
                    if (hasError && widget.suffixIcon != null)
                      const SizedBox(width: SpaceTokens.small),
                    if (widget.suffixIcon != null) widget.suffixIcon!,
                  ],
                ),
              ),
            ),
            onEditingComplete: widget.onEditingComplete,
            validator: (value) {
              return widget.validator?.call(widget.controller?.text);
            },
          ),
        ),
      ],
    );
  }
}
