import 'package:flutter/material.dart';
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/util/email_validation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_page_controller.g.dart';

/// Represents the state for the 'Sign In' page, including password
/// visibility, email validation status, and email validity.
class SignInPageState {
  /// Constructs a `SignInPageState`.
  SignInPageState({
    required this.obscurePassword,
    this.shouldValidateEmail = false,
    this.isEmailValid = false,
  });

  /// Indicates whether the password is obscured (hidden).
  final bool obscurePassword;

  /// Indicates whether email validation is needed.
  final bool shouldValidateEmail;

  /// Indicates whether the entered email is valid.
  final bool isEmailValid;

  /// Determines whether the submit button is enabled based on email validity.
  bool get isSubmitEnabled {
    return isEmailValid;
  }

  /// Copies the current state with optional modifications.
  SignInPageState copyWith({
    bool? obscurePassword,
    bool? isSubmit,
    bool? shouldValidateEmail,
    PasswordStrength? passwordStrength,
    bool? isEmailValid,
  }) {
    return SignInPageState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      shouldValidateEmail: shouldValidateEmail ?? this.shouldValidateEmail,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

/// A Riverpod controller for managing the state and actions related
/// to the 'Sign In' page.
@riverpod
class SignInPageController extends _$SignInPageController with EmailValidator {
  @override
  FutureOr<SignInPageState> build() {
    return SignInPageState(
      obscurePassword: true,
    );
  }

  /// Attempts to sign in using the provided email and password.
  Future<void> signIn({
    required String email,
    required String password,
    required bool Function() validate,
  }) async {
    state = AsyncData(state.value!.copyWith(isSubmit: true));

    if (!validate()) return;

    state = const AsyncLoading();
    final authRepo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await authRepo.signInWithEmailAndPassword(
        email,
        password,
      );
      return state.value!;
    });
  }

  /// Toggles the visibility of the password.
  void toggleObscurePassword() {
    state = AsyncData(
      state.value!.copyWith(
        obscurePassword: !state.value!.obscurePassword,
      ),
    );
  }

  /// Sets the flag to indicate email validation is needed.
  void setShouldValidateEmail() {
    state = AsyncData(
      state.value!.copyWith(
        shouldValidateEmail: true,
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

  /// Validates the email input and updates the state with the
  /// validation result.
  String? emailValidator(BuildContext context, String? value) {
    final shouldValidateEmail = state.value!.shouldValidateEmail;
    if (!shouldValidateEmail) {
      return null;
    }
    final error = validateEmail(context, value);
    state = AsyncData(
      state.value!.copyWith(
        isEmailValid: error?.isEmpty ?? true,
      ),
    );
    return error;
  }
}
