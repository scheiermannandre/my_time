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
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_app_opener.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_validation.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_action_footer.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_password_field.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_social_buttons.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/sign_up_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// A widget representing the sign-up/authentication page.
class SignUpPage extends StatefulHookConsumerWidget with EmailValidator {
  /// Constructs a [SignUpPage].
  ///
  /// The optional [email] and [password] parameters represent initial
  /// values for the corresponding fields.
  SignUpPage({this.email, this.password, super.key});

  /// The optional initial email address displayed in the field.
  final String? email;

  /// The optional initial password displayed in the field.
  final String? password;

  @override
  SignUpPageState createState() => SignUpPageState();
}

/// The state of the [SignUpPage].
class SignUpPageState extends ConsumerState<SignUpPage>
    with SingleTickerProviderStateMixin {
  /// The key to uniquely identify the form in the widget tree.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = widget.email;
      final password = widget.password;
      if (email != null && email.isNotEmpty) {
        ref
            .read(signUpPageControllerProvider.notifier)
            .setShouldValidateEmail();
      }
      if (password != null && password.isNotEmpty) {
        final passwordStrength =
            PasswordStrengthExtension.calculate(text: password);

        ref
            .read(signUpPageControllerProvider.notifier)
            .setPasswordStrength(passwordStrength);
      }
      _formKey.currentState?.validate();
    });
  }

  /// Handles the form submission.
  Future<void> _submit(
    BuildContext context,
    SignUpPageController controller,
    String email,
    String password,
    MightyThemeController themeController,
  ) async {
    // Validate the form fields
    if (!_formKey.currentState!.validate()) return;

    // Perform the submission using the provided controller
    await controller.signUp(
      email: email,
      password: password,
      validate: _formKey.currentState!.validate,
      postSignUp: () {
        // Show a snackbar with the submission result
        if (!context.mounted) return;
        const snackbarMessage =
            '''Signed you up successfully! \nPlease verify your email address to Sign In.''';
        if (snackbarMessage.isEmpty) return;
        MightySnackBar.show(
          context,
          themeController,
          snackbarMessage,
          actionLabel: 'Open inbox',
          onTab: () async {
            await EmailAppsUI.show(
              context: context,
              themeController: themeController,
              animationController: _animationController,
            );
          },
        );
      },
    );
  }

  /// Changes the current page to the specified page with email and
  /// password parameters.
  void _changePage(
    BuildContext context,
    String page,
    String email,
    String password,
  ) {
    context.goNamed(
      page,
      queryParameters: {'email': email, 'password': password},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the theme and authentication page state
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    final signUpPage = ref.watchAndListenStateProviderError(
      context,
      signUpPageControllerProvider,
      signUpPageControllerProvider.notifier,
    );
    final state = signUpPage.state.value!;

    // Controllers for email and password text fields with initial values
    final emailTextController =
        useTextEditingController(text: widget.email ?? '');
    final passwordController =
        useTextEditingController(text: widget.password ?? '');

    return Scaffold(
      backgroundColor: theme.controller.mainBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
            child: Form(
              key: _formKey, // Associates the form key with the Form widget
              child: SingleChildScrollView(
                child: SpacedColumn(
                  spacing: SpaceTokens.medium,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displays the title of the authentication page
                    Text(
                      'Create\nAccount!',
                      style: theme.controller.headline1,
                    ),

                    // Email text field for sign-up
                    MightyTextFormField(
                      onFocusLost: signUpPage.controller.setShouldValidateEmail,
                      validator: signUpPage.controller.emailValidator,
                      controller: emailTextController,
                      mightyThemeController: theme.controller,
                      labelText: 'Your e-mail address',
                      hintText: 'Please enter your e-mail address',
                      textInputType: TextInputType.emailAddress,
                    ),

                    // Password text field for sign-up
                    AuthCheckedPasswordField(
                      passwordController: passwordController,
                      themeController: theme.controller,
                      obscurePassword: state.obscurePassword,
                      toggleObscurePassword:
                          signUpPage.controller.toggleObscurePassword,
                      onChanged: (value, isValid, strength) {
                        signUpPage.controller.setPasswordStrength(
                          strength,
                        );
                      },
                    ),

                    // Button to sign up
                    MightyActionButton.primary(
                      themeController: theme.controller,
                      label: 'Sign me Up!',
                      onPressed: !state.isSubmitEnabled
                          ? null
                          : () {
                              // Trigger the form submission
                              _submit(
                                context,
                                signUpPage.controller,
                                emailTextController.text,
                                passwordController.text,
                                theme.controller,
                              );
                            },
                      isLoading: signUpPage.state.isLoading,
                    ),

                    // Social sign-up buttons
                    AuthSocialButtons(
                      controller: theme.controller,
                      googleBtnText: 'Sign up with Google',
                      googleBtnAction: () async {},
                      appleBtnText: 'Sign up with Apple',
                      appleBtnAction: () {},
                    ),

                    // Footer action for navigation and agreements
                    AuthActionFooter(
                      controller: theme.controller,
                      pageSwitchActionText: 'Sign in here!',
                      pageSwitchQuestion: 'Already have an account? ',
                      pageSwitchAction: () => _changePage(
                        context,
                        AppRoute.signIn,
                        emailTextController.text,
                        passwordController.text,
                      ),
                      agreementOnActionText:
                          'By creating an Account, I agree to our ',
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
