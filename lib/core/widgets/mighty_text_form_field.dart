import 'package:flutter/material.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';

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

  @override
  State<MightyTextFormField> createState() => _MightyTextFormFieldState();
}

class _MightyTextFormFieldState extends State<MightyTextFormField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    final enabledBorderColor =
        widget.mightyThemeController.nonDecorativeBorderColor;

    final errorColor = widget.mightyThemeController.errorColor;
    final cursorColor =
        widget.mightyThemeController.themeMode == SystemThemeMode.light
            ? enabledBorderColor
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
        Form(
          key: _formKey,
          child: TextFormField(
            key: _fieldKey,
            readOnly: widget.readOnly,
            onChanged: (value) {
              setState(() {
                hasError = !_formKey.currentState!.validate();
                widget.onChanged?.call(value, !hasError);
              });
            },
            focusNode: widget.focusNode,
            style: widget.mightyThemeController.body,
            cursorColor: cursorColor,
            controller: widget.controller,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              border: _getBorder(enabledBorderColor),
              enabledBorder: _getBorder(enabledBorderColor),
              focusedBorder: _getBorder(enabledBorderColor),
              errorBorder: _getBorder(errorColor),
              focusedErrorBorder: _getBorder(errorColor),
              errorStyle: TextStyle(color: errorColor),
              suffixIcon:
                  hasError ? Icon(Icons.cancel, color: errorColor) : null,
            ),
            onEditingComplete: widget.onEditingComplete,
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  InputBorder _getBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          CornerRadiusTokens.small,
        ),
      ),
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }
}
