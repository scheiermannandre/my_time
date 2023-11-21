import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/core/modals/mighty_ok_alert_dialog.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_circular_progress_indicator.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_handle_mode.dart';
import 'package:my_time/features/8_authentication/presentation/state_management/auth_actioncode_handler_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// A page widget handling various actions based on an authentication code.
class AuthActionCodeHandlerPage extends ConsumerStatefulWidget {
  /// Constructs an [AuthActionCodeHandlerPage] with required parameters:
  /// [oobCode] and [mode].
  ///
  /// The [oobCode] represents the out-of-band code used for authentication,
  /// and the [mode] denotes the type of email handle mode.
  AuthActionCodeHandlerPage({
    required this.oobCode,
    required String mode,
    super.key,
  }) : mode = EmailHandleModeExtension.fromString(mode);

  /// The out-of-band code for authentication.
  final String oobCode;

  /// The email handle mode indicating the type of action to be performed.
  final EmailHandleMode mode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthActionCodeHandlerPageState();
}

class _AuthActionCodeHandlerPageState
    extends ConsumerState<AuthActionCodeHandlerPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = ref as BuildContext;

      await ref
          .read(authActionCodeHandlerPageControllerProvider.notifier)
          .checkActionCode(
            oobCode: widget.oobCode,
            verifyEmail: widget.mode == EmailHandleMode.verifyEmail,
          );
      final state = ref.read(authActionCodeHandlerPageControllerProvider);
      if (!state.value!.isOobCodeValid!) return;
      if (!context.mounted) return;

      if (widget.mode == EmailHandleMode.resetPassword) {
        // ignore: cascade_invocations
        context.pushReplacementNamed(
          AppRoute.resetPassword,
          pathParameters: {'oobCode': widget.oobCode},
        );
      }
    });
  }

  Future<void> handleStateChange(
    BuildContext context,
    AsyncValue<AuthActionCodeHandlerPageState>? previous,
    AsyncValue<AuthActionCodeHandlerPageState> next,
  ) async {
    var title = '';
    var content = '';
    final newState = next.value!;

    if (newState.isOobCodeValid == null) return;

    if (!newState.isOobCodeValid!) {
      title = 'Your request could not be completed!';
      content = 'The given ActionCode is invalid or has expired.';

      await showMessageAndReturnToAuth(context, title, content);
      return;
    }

    if (widget.mode != EmailHandleMode.verifyEmail) return;

    if (newState.isEmailVerified) {
      title = 'Your Email has been verified!';
      content = 'You can now sign in.';
    } else {
      title = 'Your Email could not be verified!';
      content = 'You probably have already verified your Email.';
    }
    if (!context.mounted) return;
    await showMessageAndReturnToAuth(context, title, content);
  }

  Future<void> showMessageAndReturnToAuth(
    BuildContext context,
    String title,
    String content,
  ) async {
    await showMightyOkAlertDialog(context, title, content);

    if (!context.mounted) return;

    context.pushReplacementNamed(AppRoute.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final state = ref.watch(authActionCodeHandlerPageControllerProvider);

    ref.listen(
      authActionCodeHandlerPageControllerProvider,
      (previous, next) => handleStateChange(context, previous, next),
    );

    return Scaffold(
      backgroundColor: theme.controller.mainBackgroundColor,
      body: state.when(
        data: (_) => const Center(),
        error: (err, stack) => const Center(),
        loading: () => Center(
          child: MightyCircularProgressIndicator(
            themeController: theme.controller,
          ),
        ),
      ),
    );
  }
}
