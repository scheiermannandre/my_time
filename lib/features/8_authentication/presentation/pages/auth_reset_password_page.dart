import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/modals/mighty_ok_alert_dialog.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/auth_reset_password_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// Page widget handling the password reset functionality.
class AuthRestPasswordPage extends StatefulHookConsumerWidget {
  /// Constructs an [AuthRestPasswordPage] with required parameters: [oobCode].
  const AuthRestPasswordPage({
    required this.oobCode,
    super.key,
  });

  /// The out-of-band code for password reset.
  final String oobCode;

  @override
  AuthEmailHandlerPageState createState() => AuthEmailHandlerPageState();
}

/// The state of the [AuthRestPasswordPage].
class AuthEmailHandlerPageState extends ConsumerState<AuthRestPasswordPage> {
  /// The key to uniquely identify the form in the widget tree.
  final _passNotifier = ValueNotifier<PasswordStrength?>(null);

  Future<void> _handleStateChange(
    BuildContext context,
    AsyncValue<AuthResetPasswordPageState>? previous,
    AsyncValue<AuthResetPasswordPageState> next,
  ) async {
    var title = '';
    var content = '';
    final newState = next.value!;

    if (newState.isPasswordResetSuccess == null) return;

    if (!newState.isPasswordResetSuccess!) {
      title = context.loc.authActionCodeHandlerPasswordResetFailedTitle;
      content = context.loc.authActionCodeHandlerPasswordResetFailedContent;
    } else {
      title = context.loc.authActionCodeHandlerPasswordResetTitle;
      content = context.loc.authActionCodeHandlerPasswordResetContent;
    }
    await showMightyOkAlertDialog(context, title, content);
    if (!context.mounted) return;
    context.goNamed(AppRoute.signIn);
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the theme and authentication page state
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final authPasswordResetPage = ref.watchStateProvider(
      context,
      authResetPasswordPageControllerProvider,
      authResetPasswordPageControllerProvider.notifier,
    );
    final state = authPasswordResetPage.state.value!;

    ref.listen(
      authResetPasswordPageControllerProvider,
      (previous, next) => _handleStateChange(context, previous, next),
    );

    // Controllers for email and password text fields with initial values
    final passwordController = useTextEditingController(text: '');
    _passNotifier.value =
        PasswordStrengthExtension.calculate(text: passwordController.text);
    return Scaffold(
      backgroundColor: theme.controller.mainBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the title of the authentication page
                  Text(
                    context.loc.authResetPasswordPageHeader,
                    style: theme.controller.headline1.copyWith(
                      wordSpacing: 10,
                    ),
                  ),
                  const SizedBox(height: SpaceTokens.medium),
                  MightyTextFormField(
                    controller: passwordController,
                    labelText: context.loc.passwordFieldLabel,
                    hintText: context.loc.passwordFieldHint,
                    textInputType: TextInputType.visiblePassword,
                    obscureText: state.obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: authPasswordResetPage
                          .controller.toggleObscurePassword,
                      child: Icon(
                        state.obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.controller.secondaryTextColor,
                      ),
                    ),
                    onChanged: (value, isValid) {
                      _passNotifier.value =
                          PasswordStrengthExtension.calculate(text: value);
                      authPasswordResetPage.controller.setPasswordStrength(
                        _passNotifier.value,
                      );
                    },
                  ),
                  const SizedBox(height: SpaceTokens.medium),
                  PasswordStrengthChecker(
                    strength: _passNotifier,
                    configuration: PasswordStrengthCheckerConfiguration(
                      borderWidth: 1,
                      borderColor: theme.controller.nonDecorativeBorderColor,
                      externalBorderRadius: const BorderRadius.all(
                        Radius.circular(
                          CornerRadiusTokens.slightySmall,
                        ),
                      ),
                      internalBorderRadius: const BorderRadius.all(
                        Radius.circular(CornerRadiusTokens.verySmall),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpaceTokens.medium),
                  MightyActionButton.primary(
                    themeController: theme.controller,
                    label: context.loc.authResetPasswordPageSubmitButtonLabel,
                    onPressed: !state.isSubmitEnabled
                        ? null
                        : () async {
                            await authPasswordResetPage.controller
                                .resetPassword(
                              passwordController.text,
                              widget.oobCode,
                            );
                          },
                    isLoading: authPasswordResetPage.state.isLoading,
                  ),
                  const SizedBox(height: SpaceTokens.medium),
                  MightyActionButton.secondary(
                    themeController: theme.controller,
                    label: context.loc.deleteEntryCancelBtnLabel,
                    onPressed: () async {
                      context.goNamed(AppRoute.signIn);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
