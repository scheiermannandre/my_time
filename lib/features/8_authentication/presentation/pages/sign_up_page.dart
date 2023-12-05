import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/modals/mighty_snack_bar.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/core/widgets/text_input_field.dart';
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
        final snackbarMessage = context.loc.authSignUpSnackbarMessage;
        if (snackbarMessage.isEmpty) return;
        MightySnackBar.show(
          context,
          snackbarMessage,
          actionLabel: context.loc.authSnackbarActionLabel,
          onTab: () async {
            await EmailAppsUI.show(
              context: context,
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
                      context.loc.authSignUpPageHeader,
                      style: TextStyleTokens.getHeadline1(null),
                    ),

                    // Email text field for sign-up
                    TextInputField(
                      onFocusLost: signUpPage.controller.setShouldValidateEmail,
                      validator: (value) =>
                          signUpPage.controller.emailValidator(context, value),
                      controller: emailTextController,
                      labelText: context.loc.authPagesEmailFieldLabel,
                      hintText: context.loc.authPagesEmailFieldHint,
                      textInputType: TextInputType.emailAddress,
                    ),

                    // Password text field for sign-up
                    AuthCheckedPasswordField(
                      passwordController: passwordController,
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
                    ActionButton.primary(
                      onPressed: !state.isSubmitEnabled
                          ? null
                          : () async {
                              // Trigger the form submission
                              await _submit(
                                context,
                                signUpPage.controller,
                                emailTextController.text,
                                passwordController.text,
                              );
                            },
                      isLoading: signUpPage.state.isLoading,
                      child: Text(context.loc.authSignInPageSubmitButtonLabel),
                    ),

                    // Social sign-up buttons
                    AuthSocialButtons(
                      googleBtnText:
                          context.loc.authSignUpPageGoogleButtonLabel,
                      googleBtnAction: () async {},
                      appleBtnText: context.loc.authSignUpPageAppleButtonLabel,
                      appleBtnAction: () {},
                    ),

                    // Footer action for navigation and agreements
                    AuthActionFooter(
                      pageSwitchActionText: context.loc.authSignUpFooterSignIp,
                      pageSwitchQuestion:
                          context.loc.authSignUpFooterHaveAccount,
                      pageSwitchAction: () => _changePage(
                        context,
                        AppRoute.signIn,
                        emailTextController.text,
                        passwordController.text,
                      ),
                      agreementOnActionText:
                          context.loc.authSignUpFooterAgreementOn,
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
