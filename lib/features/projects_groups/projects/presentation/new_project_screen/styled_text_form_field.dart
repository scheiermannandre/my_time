import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  const StyledTextFormField(
      {super.key,
      required this.controller,
      required this.label,
      this.onSaved,
      this.validator,
      this.onTap,
      this.readOnly = false,
      this.suffixIcon,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: GlobalProperties.secondaryAccentColor,
      focusNode: focusNode,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[100],
        label: Text(
          label,
          style: const TextStyle(color: GlobalProperties.secondaryAccentColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalProperties.secondaryAccentColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalProperties.secondaryAccentColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      readOnly: readOnly,
      validator: validator != null ? (value) => validator!(value) : null,
      onSaved: onSaved != null ? (newValue) => onSaved!(newValue) : null,
      onTap: onTap != null ? () => onTap!() : null,
    );
  }
}
