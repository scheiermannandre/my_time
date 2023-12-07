import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_change_password_widget.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/auth_update_password_page_controller.dart';

/// Page widget handling the password reset functionality.
class AuthUpdatePasswordPage extends StatefulHookConsumerWidget {
  /// Constructs an [AuthUpdatePasswordPage].
  const AuthUpdatePasswordPage({
    super.key,
  });

  @override
  AuthEmailHandlerPageState createState() => AuthEmailHandlerPageState();
}

/// The state of the [AuthUpdatePasswordPage].
class AuthEmailHandlerPageState extends ConsumerState<AuthUpdatePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final authPasswordResetPage = ref.watchStateProvider(
      context,
      authUpdatePasswordPageControllerProvider,
      authUpdatePasswordPageControllerProvider.notifier,
    );
    final state = authPasswordResetPage.state.value!;

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
        await authPasswordResetPage.controller.updatePassword(
          passwordController.text,
        );

        if (!context.mounted) return;
        Navigator.of(context).pop(true);
      },
      submitButtonLabel: context.loc.authResetPasswordPageSubmitButtonLabel,
      isLoading: authPasswordResetPage.state.isLoading,
      onCancel: () {
        Navigator.of(context).pop();
      },
      cancelButtonLabel: context.loc.deleteEntryCancelBtnLabel,
    );
  }
}
