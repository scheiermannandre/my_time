import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_time/features/8_authentication/data/datasources/helper_extensions/user_extension.dart';
import 'package:my_time/features/8_authentication/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_data_source.g.dart';

/// A data source for managing authentication in Firebase.
class FirebaseDataSource {
  /// Constructs a [FirebaseDataSource] and initializes it
  /// with a [firebaseAuth].
  FirebaseDataSource({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  /// Signs in with the given [email] and [password].
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!userCredentials.user!.emailVerified) {
      await signOut();
    }
  }

  /// Creates a new user with the given [email] and [password].
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await verifyEmailAdress();
    await signOut();
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  /// Sends a verification email to the current user.
  Future<void> verifyEmailAdress() async {
    return _firebaseAuth.currentUser!.sendEmailVerification();
  }

  /// Sends a password reset email to the given [email].
  Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  /// Confirms and fulfills the password reset that was requested by the user.
  Future<void> confirmPasswordReset({
    required String newPassword,
    required String oobCode,
  }) async {
    await _firebaseAuth.confirmPasswordReset(
      newPassword: newPassword,
      code: oobCode,
    );
  }

  /// Checks the validity of the given [oobCode].
  Future<void> checkActionCode({required String oobCode}) async {
    await _firebaseAuth.checkActionCode(oobCode);
  }

  /// Verifies the user with the given [oobCode].
  Future<void> verifyEmail({required String oobCode}) async {
    await _firebaseAuth.applyActionCode(oobCode);
  }

  /// Returns a stream of [UserModel] objects representing the current user,
  /// when changes on the AuthState occur.
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.userChanges().map((user) => user?.toUserModel());
  }

  /// Returns the current user.
  UserModel? get currentUser => _firebaseAuth.currentUser?.toUserModel();
}

/// Riverpod provider for creating an instance of [FirebaseDataSource].
@riverpod
FirebaseDataSource firebaseDataSource(
  FirebaseDataSourceRef ref,
) {
  return FirebaseDataSource(firebaseAuth: FirebaseAuth.instance);
}
