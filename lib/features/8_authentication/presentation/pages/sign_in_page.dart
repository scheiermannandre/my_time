import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/core/widgets/text_input_field.dart';
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
    final signIn = ref.watchAndListenStateProviderError(
      context,
      signInPageControllerProvider,
      signInPageControllerProvider.notifier,
    );
    final state = signIn.state.value!;

    // Controllers for email and password text fields with initial values
    final emailTextController = useTextEditingController(
      text: widget.email ?? 'test@test.com',
    );
    final passwordController =
        useTextEditingController(text: widget.password ?? '123123');

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
                      context.loc.authSignInPageHeader,
                      style: TextStyleTokens.getHeadline1(null),
                    ),
                    // Email text field for sign-in
                    TextInputField(
                      onFocusLost: signIn.controller.setShouldValidateEmail,
                      validator: (value) =>
                          signIn.controller.emailValidator(context, value),
                      controller: emailTextController,
                      // mightyThemeController: theme.controller,
                      labelText: context.loc.authPagesEmailFieldLabel,
                      hintText: context.loc.authPagesEmailFieldHint,
                      textInputType: TextInputType.emailAddress,
                    ),

                    // Password text field for sign-in
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextInputField(
                          controller: passwordController,
                          //mightyThemeController: theme.controller,
                          labelText: context.loc.passwordFieldLabel,
                          hintText: context.loc.signInPasswordFieldHint,
                          textInputType: TextInputType.visiblePassword,
                          obscureText: state.obscurePassword,
                          suffixIcon: GestureDetector(
                            onTap: signIn.controller.toggleObscurePassword,
                            child: Icon(
                              state.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              // color: theme.controller.secondaryTextColor,
                            ),
                          ),
                          onChanged: (value, isValid) {},
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: SpaceTokens.small),
                          child: Text.rich(
                            TextSpan(
                              text: context
                                  .loc.authSignInPageForgotPasswordButtonLabel,
                              style:
                                  TextStyleTokens.bodyMedium(null).underline(),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _changePage(
                                      context,
                                      AppRoute.forgotPassword,
                                      emailTextController.text,
                                      passwordController.text,
                                    ),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    ActionButton.primary(
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
                      child: Text(context.loc.authSignInPageSubmitButtonLabel),
                    ),
                    // Social login buttons
                    AuthSocialButtons(
                      googleBtnText: context.loc.authSignInGoogleButtonLabel,
                      googleBtnAction: () {},
                      appleBtnText: context.loc.authSignInAppleButtonLabel,
                      appleBtnAction: () {},
                    ),

                    // Footer action for navigation and agreements
                    AuthActionFooter(
                      pageSwitchAction: () => _changePage(
                        context,
                        AppRoute.signUp,
                        emailTextController.text,
                        passwordController.text,
                      ),
                      pageSwitchQuestion: context.loc.authSignInFooterNoAccount,
                      pageSwitchActionText: context.loc.authSignInFooterSignUp,
                      agreementOnActionText:
                          context.loc.authSignInFooterAgreementOn,
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
