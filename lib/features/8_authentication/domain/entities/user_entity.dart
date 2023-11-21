/// [UserEntity] is an entity class that represents a user and is used to
/// pass user data to the UI layer.
class UserEntity {
  /// Constructs a [UserEntity] with the given [uid] and [email].
  UserEntity({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  /// The unique identifier of the user.
  final String uid;

  /// The email address of the user.
  final String email;

  /// Flag indicating if the user's email address has been verified.
  final bool emailVerified;
}
