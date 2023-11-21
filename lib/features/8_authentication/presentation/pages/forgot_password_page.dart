import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/modals/mighty_snack_bar.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_validation.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/forgot_password_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// Page widget for resetting the password.
class ForgotPasswordPage extends HookConsumerWidget with EmailValidator {
  /// Constructs a [ForgotPasswordPage].
  ///
  /// [email] parameter is optional and represents the initial email address
  /// in the field.
  ForgotPasswordPage({super.key, this.email});

  /// The optional initial email address displayed in the field.
  final String? email;

  /// The key to uniquely identify the form in the widget tree.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Handles the form submission to reset the password.
  ///
  /// It validates the form and triggers the password reset process using the
  /// provided controller.
  Future<void> _submit(
    BuildContext context,
    String email,
    ForgotPasswordPageState state,
    ForgotPasswordPageController controller,
    MightyThemeController themeController,
  ) async {
    // Performs the password reset submission using the provided controller
    await controller.sendForgotPassword(
      email: email,
      validate: _formKey.currentState!.validate,
      postSubmit: () {
        // Shows a snackbar with the submission result
        if (!context.mounted) return;
        const snackbarMessage =
            '''Password reset email sent successfully! \nPlease check your inbox.''';
        if (snackbarMessage.isEmpty) return;
        MightySnackBar.show(
          context,
          themeController,
          snackbarMessage,
          onOk: () => _changePage(
            context,
            AppRoute.signIn,
            email,
          ),
        );
      },
    );
  }

  /// Changes the current page to the specified page with an optional
  /// email parameter.
  void _changePage(
    BuildContext context,
    String page,
    String? email,
  ) {
    if (!context.mounted) return;
    context.pushReplacementNamed(
      page,
      queryParameters: {
        'email': email,
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtains the theme and authentication page state
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    final authPage = ref.watchStateProvider(
      context,
      forgotPasswordPageControllerProvider,
      forgotPasswordPageControllerProvider.notifier,
    );
    final state = authPage.state.value;

    // Controllers for email and password text fields with initial values
    final emailTextController = useTextEditingController(text: email ?? '');
    return Scaffold(
      backgroundColor: theme.controller.mainBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
            child: Form(
              key: _formKey, // Associates the form key with the Form widget
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Displays the title of the authentication page
                    Text(
                      'Reset\nPassword',
                      style: theme.controller.headline1,
                    ),
                    const SizedBox(height: SpaceTokens.medium),

                    // Email text field for resetting password
                    MightyTextFormField(
                      validator: authPage.controller.emailValidator,
                      onChanged: (value, isValid) => _formKey.currentState!
                          .validate(), // Triggers validation
                      controller: emailTextController,
                      mightyThemeController: theme.controller,
                      labelText: 'Your e-mail address',
                      hintText: 'Please enter your e-mail address',
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: SpaceTokens.medium),

                    // Button to trigger password reset
                    MightyActionButton.primary(
                      themeController: theme.controller,
                      label: 'Reset my Password!',
                      onPressed: () {
                        // Triggers the form submission for password reset
                        _submit(
                          context,
                          emailTextController.text,
                          state!,
                          authPage.controller,
                          theme.controller,
                        );
                      },
                      isLoading: authPage.state.isLoading,
                    ),
                    const SizedBox(height: SpaceTokens.medium),

                    // Buttons for primary and secondary actions
                    MightyActionButton.secondary(
                      themeController: theme.controller,
                      label: 'Cancel',
                      onPressed: () => _changePage(
                        context,
                        AppRoute.signIn,
                        emailTextController.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
