import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_time/features/8_authentication/data/models/user_model.dart';

/// An Extension on Firebase Auths [User].
extension UserExtension on User? {
  /// Converts a [User] to a [UserModel].
  UserModel? toUserModel() {
    if (this == null) {
      return null;
    }
    return UserModel(
      uid: this!.uid,
      email: this!.email!,
      emailVerified: this!.emailVerified,
    );
  }
}
