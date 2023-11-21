/// Enum representing different email handle modes.
enum EmailHandleMode {
  /// The mode to reset the password.
  resetPassword,

  /// The mode to recover the email.
  recoverEmail,

  /// The mode to verify the email.
  verifyEmail,
}

/// Extension class to convert string to EmailHandleMode enum.
extension EmailHandleModeExtension on EmailHandleMode {
  /// Converts the given string to EmailHandleMode enum.
  static EmailHandleMode fromString(String? value) {
    switch (value) {
      case 'resetPassword':
        return EmailHandleMode.resetPassword;
      case 'recoverEmail':
        return EmailHandleMode.recoverEmail;
      case 'verifyEmail':
        return EmailHandleMode.verifyEmail;
      default:
        throw Exception('Invalid EmailHandleMode value: $value');
    }
  }
}
