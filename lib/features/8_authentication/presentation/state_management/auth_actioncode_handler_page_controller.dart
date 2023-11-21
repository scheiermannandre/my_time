import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_actioncode_handler_page_controller.g.dart';

/// Represents the state for handling authentication action codes,
/// including whether the OOB code is valid and if the email is verified.
class AuthActionCodeHandlerPageState {
  /// Constructs an `AuthActionCodeHandlerPageState`.
  AuthActionCodeHandlerPageState({
    this.isOobCodeValid,
    this.isEmailVerified = false,
  });

  /// Represents whether the OOB code is valid.
  final bool? isOobCodeValid;

  /// Represents whether the email is verified.
  final bool isEmailVerified;

  /// Copies the current state with optional modifications.
  AuthActionCodeHandlerPageState copyWith({
    bool? isOobCodeValid,
    bool? isEmailVerified,
  }) {
    return AuthActionCodeHandlerPageState(
      isOobCodeValid: isOobCodeValid ?? this.isOobCodeValid,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}

/// A Riverpod controller for handling authentication action codes.
@riverpod
class AuthActionCodeHandlerPageController
    extends _$AuthActionCodeHandlerPageController {
  @override
  FutureOr<AuthActionCodeHandlerPageState> build() {
    return AuthActionCodeHandlerPageState();
  }

  /// Checks the validity of the action code and verifies the email
  /// if specified.
  Future<void> checkActionCode({
    required String oobCode,
    required bool verifyEmail,
  }) async {
    var isOobCodeValid = false;
    var isEmailVerified = false;

    state = const AsyncLoading();

    isOobCodeValid = await ref
        .read(authRepositoryProvider)
        .checkActionCode(oobCode: oobCode);

    if (verifyEmail && isOobCodeValid) {
      isEmailVerified =
          await ref.read(authRepositoryProvider).verifyEmail(oobCode: oobCode);
    }
    state = AsyncData(
      state.value!.copyWith(
        isOobCodeValid: isOobCodeValid,
        isEmailVerified: isEmailVerified,
      ),
    );
  }
}
