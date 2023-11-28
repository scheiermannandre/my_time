// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/int_extensions.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/modals/mighty_ok_alert_dialog.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/password_checker/dict/common_passwords.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// Enum for the password strength.
enum PasswordStrengthEnum {
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

/// Class that holds the password strength as encoded int and as an enum.
class PasswordStrength {
  /// Constructor
  PasswordStrength({
    required this.numericalValue,
    required this.enumValue,
  });

  /// Password strength encoded as integer, the bits tell which conditions are
  /// fulfilled.
  final int numericalValue;

  /// Password strength encoded as enum.
  final PasswordStrengthEnum enumValue;
}

/// The default enum for the password strength.
extension PasswordStrengthExtension on PasswordStrength {
  /// The color for every status.
  Color get statusColor {
    switch (enumValue) {
      case PasswordStrengthEnum.alreadyExposed:
        return ThemelessColorTokens.red;
      case PasswordStrengthEnum.veryWeak:
        return ThemelessColorTokens.darkOrange;
      case PasswordStrengthEnum.weak:
        return ThemelessColorTokens.lightOrange;
      case PasswordStrengthEnum.medium:
        return ThemelessColorTokens.yellow;
      case PasswordStrengthEnum.strong:
        return ThemelessColorTokens.lightGreen;
      case PasswordStrengthEnum.veryStrong:
        return ThemelessColorTokens.green;
      default:
        return ThemelessColorTokens.red;
    }
  }

  /// The percentual width of every status.
  double get widthPerc {
    switch (enumValue) {
      case PasswordStrengthEnum.alreadyExposed:
        return 0.075;
      case PasswordStrengthEnum.veryWeak:
        return 0.20;
      case PasswordStrengthEnum.weak:
        return 0.4;
      case PasswordStrengthEnum.medium:
        return 0.6;
      case PasswordStrengthEnum.strong:
        return 0.8;
      case PasswordStrengthEnum.veryStrong:
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
      passwordStrength: this,
    );
  }

  bool get _showIcon {
    switch (enumValue) {
      case PasswordStrengthEnum.alreadyExposed:
        return true;
      case PasswordStrengthEnum.veryWeak:
        return false;
      case PasswordStrengthEnum.weak:
        return false;
      case PasswordStrengthEnum.medium:
        return false;
      case PasswordStrengthEnum.strong:
        return false;
      case PasswordStrengthEnum.veryStrong:
        return true;
      default:
        return false;
    }
  }

  String get _info {
    switch (enumValue) {
      case PasswordStrengthEnum.alreadyExposed:
        return 'Already exposed';
      case PasswordStrengthEnum.veryWeak:
        return 'Very weak';
      case PasswordStrengthEnum.weak:
        return 'Weak';
      case PasswordStrengthEnum.medium:
        return 'Medium';
      case PasswordStrengthEnum.strong:
        return 'Strong';
      case PasswordStrengthEnum.veryStrong:
        return 'Very strong';
      default:
        return '';
    }
  }

  String get _message {
    switch (enumValue) {
      case PasswordStrengthEnum.alreadyExposed:
        return '''Very common password that many have used before you''';
      case PasswordStrengthEnum.veryWeak:
        return '''Oh dear, using that password is like leaving your front door wide open''';
      case PasswordStrengthEnum.weak:
        return '''Oops, using that password is like leaving your key in the lock.''';
      case PasswordStrengthEnum.medium:
        return '''Hmm, using that password is like locking your front door, but leaving the key under the mat.''';
      case PasswordStrengthEnum.strong:
        return '''Good, using that password is like locking your front door and keeping the key in a safety deposit box.''';
      case PasswordStrengthEnum.veryStrong:
        return '''Fantastic, using that password makes you as secure as Fort Knox.''';
      default:
        return '';
    }
  }

  /// Returns the [PasswordStrengthEnum] from the [text] value.
  static PasswordStrength? calculate({required String text}) {
    if (text.isEmpty) {
      return PasswordStrength(
        numericalValue: 0,
        enumValue: PasswordStrengthEnum.empty,
      );
    }

    // if (commonDictionary[text] ?? false) {
    //   return PasswordStrengthEnum.alreadyExposed;
    // }
    var binaryCounter = 0;
    var strength = PasswordStrengthEnum.veryWeak;

    if (text.length > 8) {
      binaryCounter = binaryCounter | 32;
    }
    if (text.contains(RegExp('[a-z]'))) {
      binaryCounter = binaryCounter | 16;
    }
    if (text.contains(RegExp('[A-Z]'))) {
      binaryCounter = binaryCounter | 8;
    }
    if (text.contains(RegExp('[0-9]'))) {
      binaryCounter = binaryCounter | 4;
    }
    if (text.contains(RegExp(r'[!@#\$%&*()?£\-_=]'))) {
      binaryCounter = binaryCounter | 2;
    }
    if (text.length > 10) {
      binaryCounter = binaryCounter | 1;
    }

    final minLengthBit = binaryCounter.getBit(5);
    final charVariationsSum = binaryCounter.sumBitsInRange(1, 4);
    final maxLengthBit = binaryCounter.getBit(0);

    if (!minLengthBit || charVariationsSum == 11) {
      strength = PasswordStrengthEnum.veryWeak;
    } else if (charVariationsSum == 2) {
      strength = PasswordStrengthEnum.weak;
    } else if (charVariationsSum == 3) {
      strength = PasswordStrengthEnum.medium;
    } else if (!maxLengthBit && charVariationsSum == 4) {
      strength = PasswordStrengthEnum.strong;
    } else if (maxLengthBit && charVariationsSum == 4) {
      strength = PasswordStrengthEnum.veryStrong;
    }
    if (commonDictionary[text] ?? false) {
      strength = PasswordStrengthEnum.alreadyExposed;
    }
    return PasswordStrength(
      numericalValue: binaryCounter,
      enumValue: strength,
    );
  }

  /// Instructions for the password strength.
  List<String> get _instructionsList {
    return [
      'At least 8 characters',
      'At least 1 lowercase letter',
      'At least 1 uppercase letter',
      'At least 1 digit',
      'At least 1 special character',
      'More than 10 characters',
    ];
  }

  /// Gets the values for each instruction if it is fulfilled or not
  List<bool> get _instructionsFulfilment {
    return [
      numericalValue.getBit(5),
      numericalValue.getBit(4),
      numericalValue.getBit(3),
      numericalValue.getBit(2),
      numericalValue.getBit(1),
      numericalValue.getBit(0),
    ];
  }

  ///
  Map<String, bool> get sortedInstructionFulfilmentMap {
    final instructions = _instructionsList;
    final fulfilment = _instructionsFulfilment;
    final instructionsMap = <String, bool>{};
    for (var i = 0; i < instructions.length; i++) {
      instructionsMap[instructions[i]] = fulfilment[i];
    }

    // Convert the map entries to a list and sort by the values
    final sortedEntries = instructionsMap.entries.toList()
      ..sort((a, b) => a.value ? 1 : -1);

    // Convert the sorted entries back into a map
    final sortedMap = {
      for (final entry in sortedEntries) entry.key: entry.value,
    };
    return sortedMap;
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
    required this.passwordStrength,
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

  /// Value of the password strength.
  final PasswordStrength passwordStrength;

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
            onPressed: () {
              showMightyOkAlertDialogCustomContent(
                context,
                'Password Policies',
                PasswordInstructions(
                  instructions:
                      widget.passwordStrength.sortedInstructionFulfilmentMap,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// The widget that shows the instructions for the password strength.
class PasswordInstructions extends ConsumerWidget {
  /// Creates a [PasswordInstructions] widget.
  const PasswordInstructions({required this.instructions, super.key});

  /// The instructions for the password strength classified by fulfilled or not.
  final Map<String, bool> instructions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    final textStyle = theme.controller.small;
    return SingleChildScrollView(
      child: Column(
        children: instructions.keys.map((instruction) {
          final fulfilled = instructions[instruction] ?? false;
          return _buildInstruction(instruction, fulfilled, textStyle);
        }).toList(),
      ),
    );
  }

  Widget _buildInstruction(
    String instruction,
    bool fulfilled,
    TextStyle textStyle,
  ) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check : Icons.close,
          color:
              fulfilled ? ThemelessColorTokens.green : ThemelessColorTokens.red,
        ),
        const SizedBox(width: SpaceTokens.small),
        Text(instruction, style: textStyle),
      ],
    );
  }
}
