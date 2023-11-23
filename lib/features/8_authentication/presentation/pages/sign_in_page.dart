import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_action_footer.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_social_buttons.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/sign_in_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// Widget representing the sign-in/authentication page.
class SignInPage extends StatefulHookConsumerWidget {
  /// Constructs a [SignInPage].
  ///
  /// [email] and [password] parameters are optional and represent
  /// initial values for the corresponding fields.
  const SignInPage({super.key, this.email, this.password});

  /// The optional initial email address displayed in the field.
  final String? email;

  /// The optional initial password displayed in the field.
  final String? password;

  @override
  SignInPageState createState() => SignInPageState();
}

/// The state of the [SignInPage].
class SignInPageState extends ConsumerState<SignInPage> {
  /// The key to uniquely identify the form in the widget tree.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = widget.email;
      if (email == null || email.isEmpty) return;
      ref.read(signInPageControllerProvider.notifier).setShouldValidateEmail();
      _formKey.currentState?.validate();
    });
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
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    final signIn = ref.watchStateProvider(
      context,
      signInPageControllerProvider,
      signInPageControllerProvider.notifier,
    );
    final state = signIn.state.value!;

    // Controllers for email and password text fields with initial values
    final emailTextController = useTextEditingController(
      text: widget.email ?? '',
    );
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
                      'Welcome\nBack!',
                      style: theme.controller.headline1,
                    ),

                    // Email text field for sign-in
                    MightyTextFormField(
                      onFocusLost: signIn.controller.setShouldValidateEmail,
                      validator: signIn.controller.emailValidator,
                      controller: emailTextController,
                      mightyThemeController: theme.controller,
                      labelText: 'Your e-mail address',
                      hintText: 'Please enter your e-mail address',
                      textInputType: TextInputType.emailAddress,
                    ),

                    // Password text field for sign-in
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MightyTextFormField(
                          controller: passwordController,
                          mightyThemeController: theme.controller,
                          labelText: 'Your password',
                          hintText: 'Please enter your password',
                          textInputType: TextInputType.visiblePassword,
                          obscureText: state.obscurePassword,
                          suffixIcon: GestureDetector(
                            onTap: signIn.controller.toggleObscurePassword,
                            child: Icon(
                              state.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: theme.controller.secondaryTextColor,
                            ),
                          ),
                          onChanged: (value, isValid) {},
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: SpaceTokens.small),
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              text: 'Forgot your password?',
                              style: theme.controller.small.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _changePage(
                                      context,
                                      AppRoute.forgotPassword,
                                      emailTextController.text,
                                      passwordController.text,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Button to sign in
                    MightyActionButton.primary(
                      themeController: theme.controller,
                      label: 'Sign me In!',
                      onPressed: !state.isSubmitEnabled
                          ? null
                          : () async {
                              await signIn.controller.signIn(
                                email: emailTextController.text,
                                password: passwordController.text,
                                validate: _formKey.currentState!.validate,
                              );
                            },
                      isLoading: signIn.state.isLoading,
                    ),

                    // Social login buttons
                    AuthSocialButtons(
                      controller: theme.controller,
                      googleBtnText: 'Sign in with Google',
                      googleBtnAction: () {},
                      appleBtnText: 'Sign in with Apple',
                      appleBtnAction: () {},
                    ),

                    // Footer action for navigation and agreements
                    AuthActionFooter(
                      controller: theme.controller,
                      pageSwitchAction: () => _changePage(
                        context,
                        AppRoute.signUp,
                        emailTextController.text,
                        passwordController.text,
                      ),
                      pageSwitchActionText: 'Create one here!',
                      pageSwitchQuestion: "Don't have an account? ",
                      agreementOnActionText: 'By signing in, I agree to our ',
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
