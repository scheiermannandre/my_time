import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_validation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_page_controller.g.dart';

/// Represents the state for the 'Sign Up' page, including password
/// visibility, email validation status, password strength, and email validity.
class SignUpPageState {
  /// Constructs a `SignUpPageState`.
  SignUpPageState({
    this.obscurePassword = true,
    this.shouldValidateEmail = false,
    this.passwordStrength,
    this.isEmailValid = false,
  });

  /// Indicates whether the password is obscured (hidden).
  final bool obscurePassword;

  /// Indicates whether email validation is needed.
  final bool shouldValidateEmail;

  /// Represents the password strength.
  final PasswordStrength? passwordStrength;

  /// Indicates whether the entered email is valid.
  final bool isEmailValid;

  /// Determines whether the submit button is enabled based on email
  /// validity and password strength.
  bool get isSubmitEnabled {
    if (passwordStrength == null) {
      return false;
    }

    return passwordStrength!.index >= PasswordStrength.strong.index &&
        isEmailValid;
  }

  /// Copies the current state with optional modifications.
  SignUpPageState copyWith({
    bool? obscurePassword,
    bool? shouldValidateEmail,
    PasswordStrength? passwordStrength,
    bool? isEmailValid,
  }) {
    return SignUpPageState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      shouldValidateEmail: shouldValidateEmail ?? this.shouldValidateEmail,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

/// A Riverpod controller for managing the state and actions related
/// to the 'Sign Up' page.
@riverpod
class SignUpPageController extends _$SignUpPageController with EmailValidator {
  @override
  FutureOr<SignUpPageState> build() {
    return SignUpPageState();
  }

  /// Attempts to sign up a user using the provided email and password.
  Future<void> signUp({
    required String email,
    required String password,
    required bool Function() validate,
    required void Function() postSignUp,
  }) async {
    state = AsyncData(state.value!);

    if (!validate()) return;

    state = const AsyncLoading();
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.createUserWithEmailAndPassword(
      email,
      password,
    );

    state = AsyncData(state.value!);

    postSignUp();
  }

  /// Sets the flag to indicate email validation is needed.
  void setShouldValidateEmail() {
    state = AsyncData(
      state.value!.copyWith(
        shouldValidateEmail: true,
      ),
    );
  }

  /// Validates the email input and updates the state with the
  /// validation result.
  String? emailValidator(String? value) {
    final shouldValidateEmail = state.value!.shouldValidateEmail;
    if (!shouldValidateEmail) {
      return null;
    }
    final error = validateEmail(value);
    state = AsyncData(
      state.value!.copyWith(
        isEmailValid: error?.isEmpty ?? true,
      ),
    );
    return error;
  }

  /// Toggles the visibility of the password.
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
