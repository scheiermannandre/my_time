import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/8_authentication/data/datasources/firebase_data_source.dart';
import 'package:my_time/features/8_authentication/domain/entities/user_entity.dart';
import 'package:my_time/features/8_authentication/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

/// A repository for managing authentication.
class AuthRepositoryImpl implements AuthRepository {
  /// Constructs a [AuthRepositoryImpl] and initializes it.
  AuthRepositoryImpl({required this.ref});

  /// Reference to Riverpod.
  final Ref ref;

  @override
  Stream<UserEntity?> get authStateChanges => ref
      .read(firebaseDataSourceProvider)
      .authStateChanges
      .map((userModel) => userModel?.toEntity());

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await ref
          .read(firebaseDataSourceProvider)
          .createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const CustomAppException.userAlreadyExists();
      } else if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
      throw CustomAppException.unexpected(e.message ?? '');
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  UserEntity? get currentUser =>
      ref.read(firebaseDataSourceProvider).currentUser?.toEntity();

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await ref
          .read(firebaseDataSourceProvider)
          .signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw const CustomAppException.invalidCredentials();
      } else if (e.code == 'user-disabled') {
        throw const CustomAppException.userDisabled();
      } else if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      } else if (e.code == 'email-not-verified') {
        throw const CustomAppException.emailNotVerified();
      }
      throw CustomAppException.unexpected(e.message ?? '');
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await ref.read(firebaseDataSourceProvider).signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await ref.read(firebaseDataSourceProvider).sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<bool> confirmPasswordReset({
    required String newPassword,
    required String oobCode,
  }) async {
    try {
      await ref
          .read(firebaseDataSourceProvider)
          .confirmPasswordReset(newPassword: newPassword, oobCode: oobCode);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
      return false;
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<bool> checkActionCode({required String oobCode}) async {
    try {
      await ref
          .read(firebaseDataSourceProvider)
          .checkActionCode(oobCode: oobCode);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
      return false;
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<bool> verifyEmail({required String oobCode}) async {
    try {
      await ref.read(firebaseDataSourceProvider).verifyEmail(oobCode: oobCode);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
      return false;
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      await ref
          .read(firebaseDataSourceProvider)
          .reauthenticate(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw const CustomAppException.invalidCredentials();
      } else if (e.code == 'user-disabled') {
        throw const CustomAppException.userDisabled();
      } else if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
      throw CustomAppException.unexpected(e.message ?? '');
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await ref.read(firebaseDataSourceProvider).updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await ref.read(firebaseDataSourceProvider).deleteUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const CustomAppException.networkRequestFailed();
      }
    } on Exception catch (e) {
      throw CustomAppException.unexpected(e.toString());
    }
  }
}

/// Riverpod provider for [AuthRepositoryImpl].
@riverpod
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref: ref);
}

/// Riverpod provider for streaming the current user.
@riverpod
Stream<UserEntity?> currentUserStream(CurrentUserStreamRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
