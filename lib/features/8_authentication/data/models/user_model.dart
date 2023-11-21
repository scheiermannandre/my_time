import 'package:my_time/features/8_authentication/domain/entities/user_entity.dart';

/// Represents a user model with essential user details.
class UserModel {
  /// Constructs a [UserModel] with required parameters:
  /// [uid], [email], and [emailVerified].
  UserModel({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  /// The unique identifier associated with the user.
  final String uid;

  /// The email address of the user.
  final String email;

  /// Indicates whether the user's email is verified or not.
  final bool emailVerified;

  /// Converts the user model to a [UserEntity] object.
  ///
  /// Returns a [UserEntity] object with the same [uid], [email],
  /// and [emailVerified].
  UserEntity? toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      emailVerified: emailVerified,
    );
  }
}
