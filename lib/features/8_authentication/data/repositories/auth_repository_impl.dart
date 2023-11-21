import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  ) =>
      ref
          .read(firebaseDataSourceProvider)
          .createUserWithEmailAndPassword(email, password);

  @override
  UserEntity? get currentUser =>
      ref.read(firebaseDataSourceProvider).currentUser?.toEntity();

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) =>
      ref
          .read(firebaseDataSourceProvider)
          .signInWithEmailAndPassword(email, password);

  @override
  Future<void> signOut() => ref.read(firebaseDataSourceProvider).signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      ref.read(firebaseDataSourceProvider).sendPasswordResetEmail(email);

  @override
  Future<bool> confirmPasswordReset({
    required String newPassword,
    required String oobCode,
  }) async {
    return ref
        .read(firebaseDataSourceProvider)
        .confirmPasswordReset(newPassword: newPassword, oobCode: oobCode);
  }

  @override
  Future<bool> checkActionCode({required String oobCode}) async {
    return ref
        .read(firebaseDataSourceProvider)
        .checkActionCode(oobCode: oobCode);
  }

  @override
  Future<bool> verifyEmail({required String oobCode}) async {
    return ref.read(firebaseDataSourceProvider).verifyEmail(oobCode: oobCode);
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
