import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_validation.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/mighty_password_strength.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_page_controller.g.dart';

/// Represents the state for the 'Forgot Password' page, indicating
/// whether email validation is needed.
class ForgotPasswordPageState {
  /// Constructs a `ForgotPasswordPageState`.
  ForgotPasswordPageState({
    this.shouldValidateEmail = false,
  });

  /// Indicates whether email validation is needed.
  final bool shouldValidateEmail;

  /// Copies the current state with optional modifications.
  ForgotPasswordPageState copyWith({
    bool? obscurePassword,
    bool? isSubmit,
    bool? shouldValidateEmail,
    MightyPasswordStrength? passwordStrength,
    bool? isEmailValid,
  }) {
    return ForgotPasswordPageState(
      shouldValidateEmail: shouldValidateEmail ?? this.shouldValidateEmail,
    );
  }
}

/// A Riverpod controller for handling actions and state related to
/// the 'Forgot Password' page.
@riverpod
class ForgotPasswordPageController extends _$ForgotPasswordPageController
    with EmailValidator {
  @override
  FutureOr<ForgotPasswordPageState> build() {
    return ForgotPasswordPageState();
  }

  /// Sends a request to reset the password using the provided email.
  Future<void> sendForgotPassword({
    required String email,
    required bool Function() validate,
    required void Function() postSubmit,
  }) async {
    state = AsyncData(state.value!.copyWith(shouldValidateEmail: true));

    if (!validate()) return;

    state = const AsyncLoading();
    final authRepo = ref.read(authRepositoryProvider);

    await authRepo.sendPasswordResetEmail(
      email,
    );
    postSubmit();

    state = AsyncData(state.value!);
  }

  /// Sets the password strength in the current state.
  void setPasswordStrength(MightyPasswordStrength? passwordStrength) {
    state = AsyncData(
      state.value!.copyWith(
        passwordStrength: passwordStrength,
      ),
    );
  }

  /// Validates the email input and updates the state with the
  /// validation result.
  String? emailValidator(String? value) {
    final shouldValidateEmail = state.value!.shouldValidateEmail;
    if (!shouldValidateEmail) return null;

    final error = validateEmail(value);
    state = AsyncData(
      state.value!.copyWith(
        isEmailValid: error?.isEmpty ?? true,
      ),
    );
    return error;
  }
}
