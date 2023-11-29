import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailValidator {
  /// Validates the given [value] as an email address.
  String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.emailValidationEmptyEmail;
    }
    if (!_isEmail(value)) {
      return context.loc.emailValidationInvalidEmail;
    }
    return null;
  }

  bool _isEmail(String value) {
    try {
      const regexSource = r'^\S+@\S+\.\S+$';
      // https://regex101.com/
      final regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
