import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/modals/ok_alert_dialog.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_password_field.dart';
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
    await showOkAlertDialog(context, title, content);
    if (!context.mounted) return;
    context.goNamed(AppRoute.signIn);
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
          child: Center(
            child: SingleChildScrollView(
              child: SpacedColumn(
                spacing: SpaceTokens.medium,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the title of the authentication page
                  Text(
                    context.loc.authResetPasswordPageHeader,
                    style: TextStyleTokens.getHeadline1(null),
                  ),
                  // Password text field for sign-up
                  AuthCheckedPasswordField(
                    passwordController: passwordController,
                    obscurePassword: state.obscurePassword,
                    toggleObscurePassword:
                        authPasswordResetPage.controller.toggleObscurePassword,
                    onChanged: (value, isValid, strength) {
                      authPasswordResetPage.controller.setPasswordStrength(
                        strength,
                      );
                    },
                  ),
                  ActionButton.primary(
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
                    child: Text(
                      context.loc.authResetPasswordPageSubmitButtonLabel,
                    ),
                  ),
                  ActionButton.secondary(
                    onPressed: () async {
                      context.goNamed(AppRoute.signIn);
                    },
                    child: Text(context.loc.deleteEntryCancelBtnLabel),
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
