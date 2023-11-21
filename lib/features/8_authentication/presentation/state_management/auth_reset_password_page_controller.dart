import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_handle_mode.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/mighty_password_strength.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_reset_password_page_controller.g.dart';

/// Represents the state for the reset password page,
/// including email handle mode, password visibility, password strength,
/// and password reset success status.
class AuthResetPasswordPageState {
  /// Constructs an `AuthResetPasswordPageState`.
  AuthResetPasswordPageState({
    this.emailHandleMode,
    this.obscurePassword = true,
    this.passwordStrength,
    this.isPasswordResetSuccess,
  });

  /// Represents the email handle mode.
  final EmailHandleMode? emailHandleMode;

  /// Represents whether the password is currently obscured.
  final bool obscurePassword;

  /// Represents the password strength.
  final MightyPasswordStrength? passwordStrength;

  /// Represents whether the password reset was successful.
  final bool? isPasswordResetSuccess;

  /// Returns whether the submission of the password is enabled
  /// based on its strength.
  bool get isSubmitEnabled {
    if (passwordStrength == null) {
      return false;
    }
    return passwordStrength!.index >= MightyPasswordStrength.strong.index;
  }

  /// Copies the current state with optional modifications.
  AuthResetPasswordPageState copyWith({
    EmailHandleMode? emailHandleMode,
    bool? obscurePassword,
    MightyPasswordStrength? passwordStrength,
    bool? isPasswordResetSuccess,
  }) {
    return AuthResetPasswordPageState(
      emailHandleMode: emailHandleMode ?? this.emailHandleMode,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      isPasswordResetSuccess:
          isPasswordResetSuccess ?? this.isPasswordResetSuccess,
    );
  }
}

/// A Riverpod controller for managing the reset password page's
/// state and actions.
@riverpod
class AuthResetPasswordPageController
    extends _$AuthResetPasswordPageController {
  @override
  FutureOr<AuthResetPasswordPageState> build() {
    return AuthResetPasswordPageState();
  }

  /// Resets the password using the provided new password and OOB code.
  Future<void> resetPassword(String newPassword, String oobCode) async {
    state = const AsyncLoading();

    final isPasswordResetSuccess = await ref
        .read(authRepositoryProvider)
        .confirmPasswordReset(newPassword: newPassword, oobCode: oobCode);
    state = AsyncData(
      state.value!.copyWith(isPasswordResetSuccess: isPasswordResetSuccess),
    );
  }

  /// Toggles the visibility of the password field.
  void toggleObscurePassword() {
    state = AsyncData(
      state.value!.copyWith(
        obscurePassword: !state.value!.obscurePassword,
      ),
    );
  }

  /// Sets the password strength in the current state.
  void setPasswordStrength(MightyPasswordStrength? passwordStrength) {
    state = AsyncData(
      state.value!.copyWith(
        passwordStrength: passwordStrength,
      ),
    );
  }
}
