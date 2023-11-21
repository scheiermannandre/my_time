import 'package:my_time/features/8_authentication/domain/entities/user_entity.dart';

/// Abstract class representing operations on authentication.
abstract class AuthRepository {
  /// Signs in with the given [email] and [password].
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Creates a new user with the given [email] and [password].
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  /// Signs out the current user.
  Future<void> signOut();

  /// Sends a password reset email to the given [email].
  Future<void> sendPasswordResetEmail(String email);

  /// Checks if the given [oobCode] is valid.
  Future<bool> checkActionCode({
    required String oobCode,
  });

  /// Verifies the email address of the current user.
  Future<bool> verifyEmail({
    required String oobCode,
  });

  /// Confirms and fulfills the password reset that was requested by the user.
  Future<bool> confirmPasswordReset({
    required String newPassword,
    required String oobCode,
  });

  /// Returns a stream of [UserEntity] objects representing the current user,
  /// when changes on the AuthState occur.
  Stream<UserEntity?> get authStateChanges;

  /// Returns the current user entity.
  UserEntity? get currentUser;
}
