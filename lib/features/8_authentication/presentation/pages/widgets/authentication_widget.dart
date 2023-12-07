import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/password_checker/enum/password_strength_enum.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/core/widgets/text_input_field.dart';

/// A Widget for authentication pages.
class AuthenticationWidget extends StatelessWidget {
  /// Constructs an [AuthenticationWidget].
  const AuthenticationWidget({
    required this.emailTextController,
    required this.passwordController,
    required this.obscurePassword,
    required this.toggleObscurePassword,
    required this.onChanged,
    required this.isSubmitEnabled,
    required this.onSubmit,
    required this.submitButtonLabel,
    required this.isLoading,
    required this.title,
    required this.onFocusLost,
    required this.validator,
    this.forgotPasswordWidget,
    this.emailFieldReadOnly = false,
    super.key,
  });

  /// The optional widget for the forgot password action.
  final Widget? forgotPasswordWidget;

  /// The controller for the email text field.
  final TextEditingController emailTextController;

  /// The controller for the password text field.
  final TextEditingController passwordController;

  /// Whether the password is obscured or not.
  final bool obscurePassword;

  /// Toggles the password obscuration.
  final void Function() toggleObscurePassword;

  /// The callback for when the password changes.
  // ignore: avoid_positional_boolean_parameters
  final void Function(String value, bool isValid, PasswordStrength? strength)
      onChanged;

  /// Whether the submit button is enabled or not.
  final bool isSubmitEnabled;

  /// The callback for when the submit button is pressed.
  final void Function() onSubmit;

  /// The label of the submit button.
  final String submitButtonLabel;

  /// Whether the submit button is loading or not.
  final bool isLoading;

  /// The title of the authentication page.
  final String title;

  /// The callback for when the focus is lost.
  final VoidCallback onFocusLost;

  /// The validator for the text field.
  final String? Function(BuildContext context, String? value) validator;

  /// Determines whether the email field is in read-only mode.
  final bool emailFieldReadOnly;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Displays the title of the authentication page
        Text(
          title,
          style: TextStyleTokens.getHeadline1(null),
        ),
        //Email text field for sign-in
        TextInputField(
          onFocusLost: onFocusLost,
          validator: (value) => validator(context, value),
          controller: emailTextController,
          labelText: context.loc.authPagesEmailFieldLabel,
          hintText: context.loc.authPagesEmailFieldHint,
          textInputType: TextInputType.emailAddress,
          readOnly: emailFieldReadOnly,
        ),

        // Password text field for sign-in
        SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: SpaceTokens.small,
          children: [
            TextInputField(
              controller: passwordController,
              labelText: context.loc.passwordFieldLabel,
              hintText: context.loc.signInPasswordFieldHint,
              textInputType: TextInputType.visiblePassword,
              obscureText: obscurePassword,
              suffixIcon: GestureDetector(
                onTap: toggleObscurePassword,
                child: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              onChanged: (value, isValid) {},
            ),
            if (forgotPasswordWidget != null) forgotPasswordWidget!,
          ],
        ),
        ActionButton.primary(
          onPressed: !isSubmitEnabled ? null : onSubmit,
          isLoading: isLoading,
          child: Text(submitButtonLabel),
        ),
      ],
    );
  }
}
