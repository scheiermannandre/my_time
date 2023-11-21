// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

/// The default enum for the password strength.
enum MightyPasswordStrength implements PasswordStrengthItem {
  /// The password is already exposed state.
  alreadyExposed,

  /// The password is very weak state.
  veryWeak,

  /// The password is weak state.
  weak,

  /// The password is medium state.
  medium,

  /// The password is strong state.
  strong,

  /// The password is very strong state.
  veryStrong;

  /// The color for every status.
  @override
  Color get statusColor {
    switch (this) {
      case MightyPasswordStrength.alreadyExposed:
        return const Color(0xffF11919);
      case MightyPasswordStrength.veryWeak:
        return const Color(0xffF9856D);
      case MightyPasswordStrength.weak:
        return const Color(0xffF49B1E);
      case MightyPasswordStrength.medium:
        return const Color(0xffF4DE1E);
      case MightyPasswordStrength.strong:
        return const Color(0xffA8E234);
      case MightyPasswordStrength.veryStrong:
        return const Color(0xff52CC15);
      default:
        return const Color(0xffF11919);
    }
  }

  /// The percentual width of every status.
  @override
  double get widthPerc {
    switch (this) {
      case MightyPasswordStrength.alreadyExposed:
        return 0.075;
      case MightyPasswordStrength.veryWeak:
        return 0.20;
      case MightyPasswordStrength.weak:
        return 0.4;
      case MightyPasswordStrength.medium:
        return 0.6;
      case MightyPasswordStrength.strong:
        return 0.8;
      case MightyPasswordStrength.veryStrong:
        return 1;
    }
  }

  /// The widget to show for every status under the bar.
  @override
  Widget? get statusWidget {
    return Expanded(child: _makeStatus ?? const SizedBox.shrink());
  }

  Widget? get _makeStatus {
    switch (this) {
      case MightyPasswordStrength.alreadyExposed:
        return Row(
          children: [
            Icon(Icons.error, color: statusColor),
            const SizedBox(width: 5),
            const Expanded(
              child: Text(
                '''Already exposed\nVery common password that many have used before you''',
              ),
            ),
          ],
        );
      case MightyPasswordStrength.veryWeak:
        return const Text(
          '''Very Weak!\nOh dear, using that password is like leaving your front door wide open''',
        );
      case MightyPasswordStrength.weak:
        return const Text(
          '''Weak!\nOops, using that password is like leaving your key in the lock.''',
        );
      case MightyPasswordStrength.medium:
        return const Text(
          '''Medium!\nHmm, using that password is like locking your front door, but leaving the key under the mat.''',
        );
      case MightyPasswordStrength.strong:
        return const Text(
          '''Strong!\nGood, using that password is like locking your front door and keeping the key in a safety deposit box.''',
        );
      case MightyPasswordStrength.veryStrong:
        return Row(
          children: [
            Icon(Icons.check_circle, color: statusColor),
            const SizedBox(width: 5),
            const Expanded(
              child: Text(
                '''Very Strong\nFantastic, using that password makes you as secure as Fort Knox.''',
              ),
            ),
          ],
        );
      default:
        return null;
    }
  }

  /// Returns the [MightyPasswordStrength] from the [text] value.
  static MightyPasswordStrength? calculate({required String text}) {
    if (text.isEmpty) {
      return null;
    }

    if (commonDictionary[text] ?? false) {
      return MightyPasswordStrength.alreadyExposed;
    }

    if (text.length < 8) {
      return MightyPasswordStrength.veryWeak;
    }
    var counter = 0;

    if (text.contains(RegExp('[a-z]'))) counter++;
    if (text.contains(RegExp('[A-Z]'))) counter++;
    if (text.contains(RegExp('[0-9]'))) counter++;
    if (text.contains(RegExp(r'[!@#\$%&*()?£\-_=]'))) counter++;
    if (text.length > 10) counter++;

    switch (counter) {
      case 1:
        return MightyPasswordStrength.veryWeak;
      case 2:
        return MightyPasswordStrength.weak;
      case 3:
        return MightyPasswordStrength.medium;
      case 4:
        return MightyPasswordStrength.strong;
      case 5:
        return MightyPasswordStrength.veryStrong;
      default:
        return MightyPasswordStrength.veryWeak;
    }
  }

  /// Instructions for the password strength.
  static String get instructions {
    return 'Enter a password that contains:\n\n'
        '• At least 8 characters\n'
        '• At least 1 lowercase letter\n'
        '• At least 1 uppercase letter\n'
        '• At least 1 digit\n'
        '• At least 1 special character\n'
        '• More than 10 characters';
  }
}
