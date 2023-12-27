import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_change_password_widget.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/auth_reset_password_page_controller.dart';
import 'package:my_time/foundation/config/config.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';
import 'package:my_time/foundation/core/util/extentions/widget_ref_extension.dart';

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
    await ModalDialogUI.showOk(
      context: context,
      title: title,
      content: content,
    );
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
    return AuthChangePasswordWidget(
      title: context.loc.authResetPasswordPageHeader,
      passwordController: passwordController,
      obscurePassword: state.obscurePassword,
      toggleObscurePassword:
          authPasswordResetPage.controller.toggleObscurePassword,
      onChanged: (value, isValid, strength) {
        authPasswordResetPage.controller.setPasswordStrength(
          strength,
        );
      },
      isSubmitEnabled: state.isSubmitEnabled,
      onSubmit: () async {
        await authPasswordResetPage.controller.resetPassword(
          passwordController.text,
          widget.oobCode,
        );
      },
      submitButtonLabel: context.loc.authResetPasswordPageSubmitButtonLabel,
      isLoading: authPasswordResetPage.state.isLoading,
      onCancel: () async {
        context.goNamed(AppRoute.signIn);
      },
      cancelButtonLabel: context.loc.deleteEntryCancelBtnLabel,
    );
  }
}
