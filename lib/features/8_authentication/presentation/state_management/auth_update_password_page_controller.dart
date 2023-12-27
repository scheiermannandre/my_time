import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_handle_mode.dart';
import 'package:my_time/foundation/core/widgets/password_checker/password_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_update_password_page_controller.g.dart';

/// Represents the state for the reset password page,
/// including email handle mode, password visibility, password strength,
/// and password reset success status.
class AuthUpdatePasswordPageState {
  /// Constructs an `AuthResetPasswordPageState`.
  AuthUpdatePasswordPageState({
    this.obscurePassword = true,
    this.passwordStrength,
  });

  /// Represents whether the password is currently obscured.
  final bool obscurePassword;

  /// Represents the password strength.
  final PasswordStrength? passwordStrength;

  /// Returns whether the submission of the password is enabled
  /// based on its strength.
  bool get isSubmitEnabled {
    if (passwordStrength == null) {
      return false;
    }
    return passwordStrength!.enumValue.index >=
        PasswordStrengthEnum.strong.index;
  }

  /// Copies the current state with optional modifications.
  AuthUpdatePasswordPageState copyWith({
    EmailHandleMode? emailHandleMode,
    bool? obscurePassword,
    PasswordStrength? passwordStrength,
  }) {
    return AuthUpdatePasswordPageState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}

/// A Riverpod controller for managing the reset password page's
/// state and actions.
@riverpod
class AuthUpdatePasswordPageController
    extends _$AuthUpdatePasswordPageController {
  @override
  FutureOr<AuthUpdatePasswordPageState> build() {
    return AuthUpdatePasswordPageState();
  }

  /// Resets the password using the provided new password and OOB code.
  Future<void> updatePassword(String newPassword) async {
    state = const AsyncLoading();
    final value = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .updatePassword(newPassword: newPassword),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = AsyncData(state.value!);
    }
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
  void setPasswordStrength(PasswordStrength? passwordStrength) {
    state = AsyncData(
      state.value!.copyWith(
        passwordStrength: passwordStrength,
      ),
    );
  }
}
