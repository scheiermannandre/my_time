import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/size_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

/// A customizable action button widget that can display
/// buttons with or without loading indicators.
class ActionButton extends StatelessWidget {
  /// Constructs an [ActionButton].
  const ActionButton({
    required this.child,
    required this.buttonBuilder,
    this.isLoading = false,
    super.key,
  });

  /// Constructs a primary [ActionButton] with loading capability.
  factory ActionButton.primary({
    required Widget child,
    required Future<void> Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child) => ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  /// Constructs a secondary [ActionButton] with loading capability.
  factory ActionButton.secondary({
    required Widget child,
    required Future<void> Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child) => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  /// Constructs a text [ActionButton] with loading capability.
  factory ActionButton.text({
    required Widget child,
    required Future<void> Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child) => TextButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  /// Constructs an icon [ActionButton] with loading capability.
  factory ActionButton.icon({
    required Widget child,
    required Future<void> Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child) => IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: child,
      ),
    );
  }

  /// The child widget to display within the button.
  final Widget child;

  /// The builder function to create the button widget based on child content.
  final Widget Function(Widget child) buttonBuilder;

  /// A flag to determine whether the button is in a loading state.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return buttonBuilder(_ButtonChild(isLoading: isLoading, child: child));
  }
}

/// Widget used internally for displaying child content or loading
/// indicator within a button.
class _ButtonChild extends StatelessWidget {
  /// Constructs a [_ButtonChild] widget.
  const _ButtonChild({
    required this.child,
    required this.isLoading,
  });

  /// The boolean flag to determine whether to display the loading
  /// indicator or child content.
  final bool isLoading;

  /// The child widget to display within the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpaceTokens.mediumSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: isLoading ? 0 : 1,
            child: child,
          ),
          Visibility(
            visible: isLoading,
            child: const SizedBox(
              height: SizeTokens.x24,
              width: SizeTokens.x24,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
