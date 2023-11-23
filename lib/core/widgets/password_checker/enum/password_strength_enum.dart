// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/password_checker/dict/common_passwords.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// The abstract class for the password strength enum.
// abstract class PasswordStrengthItem {
//   /// The color for every status.
//   Color get statusColor;

//   /// The percentual width of every status.
//   double get widthPerc;

//   /// The widget to show for every status under the bar.
//   Widget? get statusWidget => null;
// }

enum PasswordStrength {
  /// The password is empty state.
  empty,

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
}

/// The default enum for the password strength.
extension PasswordStrengthExtension on PasswordStrength {
  /// The color for every status.
  Color get statusColor {
    switch (this) {
      case PasswordStrength.alreadyExposed:
        return const Color(0xffF11919);
      case PasswordStrength.veryWeak:
        return const Color(0xffF9856D);
      case PasswordStrength.weak:
        return const Color(0xffF49B1E);
      case PasswordStrength.medium:
        return const Color(0xffF4DE1E);
      case PasswordStrength.strong:
        return const Color(0xffA8E234);
      case PasswordStrength.veryStrong:
        return const Color(0xff52CC15);
      default:
        return const Color(0xffF11919);
    }
  }

  /// The percentual width of every status.
  double get widthPerc {
    switch (this) {
      case PasswordStrength.alreadyExposed:
        return 0.075;
      case PasswordStrength.veryWeak:
        return 0.20;
      case PasswordStrength.weak:
        return 0.4;
      case PasswordStrength.medium:
        return 0.6;
      case PasswordStrength.strong:
        return 0.8;
      case PasswordStrength.veryStrong:
        return 1;
      default:
        return 0;
    }
  }

  /// The widget to show for every status under the bar.
  Widget get statusWidget {
    return PasswordMessage(
      info: _info,
      message: _message,
      statusColor: statusColor,
      showIcon: _showIcon,
    );
  }

  bool get _showIcon {
    switch (this) {
      case PasswordStrength.alreadyExposed:
        return true;
      case PasswordStrength.veryWeak:
        return false;
      case PasswordStrength.weak:
        return false;
      case PasswordStrength.medium:
        return false;
      case PasswordStrength.strong:
        return false;
      case PasswordStrength.veryStrong:
        return true;
      default:
        return false;
    }
  }

  String get _info {
    switch (this) {
      case PasswordStrength.alreadyExposed:
        return 'Already exposed';
      case PasswordStrength.veryWeak:
        return 'Very weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very strong';
      default:
        return '';
    }
  }

  String get _message {
    switch (this) {
      case PasswordStrength.alreadyExposed:
        return '''Very common password that many have used before you''';
      case PasswordStrength.veryWeak:
        return '''Oh dear, using that password is like leaving your front door wide open''';
      case PasswordStrength.weak:
        return '''Oops, using that password is like leaving your key in the lock.''';
      case PasswordStrength.medium:
        return '''Hmm, using that password is like locking your front door, but leaving the key under the mat.''';
      case PasswordStrength.strong:
        return '''Good, using that password is like locking your front door and keeping the key in a safety deposit box.''';
      case PasswordStrength.veryStrong:
        return '''Fantastic, using that password makes you as secure as Fort Knox.''';
      default:
        return '';
    }
  }

  /// Returns the [PasswordStrength] from the [text] value.
  static PasswordStrength? calculate({required String text}) {
    if (text.isEmpty) {
      return PasswordStrength.empty;
    }

    if (commonDictionary[text] ?? false) {
      return PasswordStrength.alreadyExposed;
    }

    if (text.length < 8) {
      return PasswordStrength.veryWeak;
    }
    var counter = 0;

    if (text.contains(RegExp('[a-z]'))) counter++;
    if (text.contains(RegExp('[A-Z]'))) counter++;
    if (text.contains(RegExp('[0-9]'))) counter++;
    if (text.contains(RegExp(r'[!@#\$%&*()?£\-_=]'))) counter++;
    if (text.length > 10) counter++;

    switch (counter) {
      case 1:
        return PasswordStrength.veryWeak;
      case 2:
        return PasswordStrength.weak;
      case 3:
        return PasswordStrength.medium;
      case 4:
        return PasswordStrength.strong;
      case 5:
        return PasswordStrength.veryStrong;
      default:
        return PasswordStrength.veryWeak;
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

/// The widget that shows the a message regarding the password strength.
class PasswordMessage extends ConsumerStatefulWidget {
  /// Creates a [PasswordMessage] widget.
  const PasswordMessage({
    required this.message,
    required this.statusColor,
    required this.showIcon,
    required this.info,
    super.key,
  });

  /// Additional information about the password strength.
  final String info;

  /// A message describing the password strength.
  final String message;

  /// The color representing the status of the password strength.
  final Color statusColor;

  /// Indicates whether to show an icon for the password strength.
  final bool showIcon;

  @override
  PasswordMessageState createState() => PasswordMessageState();
}

/// The state for the [PasswordMessage] widget.
class PasswordMessageState extends ConsumerState<PasswordMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _duration = 200.ms;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0,
      vsync: this,
      duration: _duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    if (widget.showIcon) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Expanded(
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: widget.statusColor),
              const SizedBox(width: SpaceTokens.small),
            ],
          )
              .animate(controller: _controller, autoPlay: false)
              .custom(
                duration: _duration,
                builder: (context, value, child) {
                  return SizeTransition(
                    sizeFactor: _controller,
                    axis: Axis.horizontal,
                    child: child,
                  );
                },
              )
              .fade(
                duration: _duration,
              ),
          Expanded(
            child: SpacedColumn(
              spacing: SpaceTokens.verySmall,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info,
                  style: theme.controller.smallHeadline,
                ),
                Text(
                  widget.message,
                  style: theme.controller.small,
                ),
              ],
            ),
          ),
          const SizedBox(width: SpaceTokens.small),
          IconButton(
            icon: Icon(Icons.info, color: theme.controller.secondaryTextColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
