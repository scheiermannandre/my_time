import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/authentication_widget.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/reauthentication_page_controller.dart';

/// Widget representing the sign-in/authentication page.
class ReauthenticationPage extends HookConsumerWidget {
  /// Constructs a [ReauthenticationPage].
  ReauthenticationPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watchAndListenStateProviderError(
      context,
      reauthenticationPageControllerProvider,
      reauthenticationPageControllerProvider.notifier,
    );
    final state = signIn.state.value!;
    final userMail = ref.read(authRepositoryProvider).currentUser?.email ?? '';
    // Controllers for email and password text fields with initial values
    final emailTextController = useTextEditingController(text: userMail);
    final passwordController = useTextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(),
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
                    AuthenticationWidget(
                      emailFieldReadOnly: true,
                      title: context.loc.profileReauthenticateDialogHeader,
                      emailTextController: emailTextController,
                      onFocusLost: signIn.controller.setShouldValidateEmail,
                      validator: signIn.controller.emailValidator,
                      passwordController: passwordController,
                      obscurePassword: state.obscurePassword,
                      toggleObscurePassword:
                          signIn.controller.toggleObscurePassword,
                      onChanged: (value, isValid, strength) {},
                      isSubmitEnabled: true,
                      onSubmit: () async {
                        final isSuccess =
                            await signIn.controller.reauthenticate(
                          email: emailTextController.text,
                          password: passwordController.text,
                          validate: _formKey.currentState!.validate,
                        );

                        if (!isSuccess) return;
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      },
                      submitButtonLabel:
                          context.loc.profileReauthenticateSubmitBtnLabel,
                      isLoading: signIn.state.isLoading,
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
