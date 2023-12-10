import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/size_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

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
    required void Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => ElevatedButton(
        onPressed: !isLoading ? onPressed : null,
        child: child,
      ),
    );
  }

  /// Constructs a secondary [ActionButton] with loading capability.
  factory ActionButton.secondary({
    required Widget child,
    required void Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => OutlinedButton(
        onPressed: !isLoading ? onPressed : null,
        child: child,
      ),
    );
  }

  /// Constructs a text [ActionButton] with loading capability.
  factory ActionButton.text({
    required Widget child,
    required void Function()? onPressed,
    bool isLoading = false,
    ButtonStyle? style,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => TextButton(
        style: style,
        onPressed: !isLoading ? onPressed : null,
        child: child,
      ),
    );
  }

  /// Constructs an icon [ActionButton] with loading capability.
  factory ActionButton.icon({
    required Widget child,
    required void Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => IconButton(
        onPressed: !isLoading ? onPressed : null,
        icon: child,
      ),
    );
  }

  /// Constructs an icon [ActionButton] with loading capability.
  factory ActionButton.iconWithBackground({
    required Widget child,
    required BuildContext context,
    required void Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => Container(
        decoration: ShapeDecoration(
          color: ThemeColorBuilder(context).getActionsColor(),
          shape: const CircleBorder(),
        ),
        child: IconButton(
          padding: const EdgeInsets.all(SpaceTokens.medium),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: !isLoading ? onPressed : null,
          icon: child,
        ),
      ),
    );
  }

  /// Constructs an icon [ActionButton] with loading capability.
  factory ActionButton.iconWithBackgroundAndLabel({
    required Widget child,
    required String label,
    required BuildContext context,
    required void Function()? onPressed,
    bool isLoading = false,
    Key? key,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ActionButton(
      key: key,
      isLoading: isLoading,
      child: child,
      buttonBuilder: (child, isLoading) => TextButton(
        style: Theme.of(context).textButtonTheme.style?.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(SpaceTokens.verySmall),
              ),
              iconColor:
                  MaterialStateProperty.all<Color>(colorScheme.onPrimary),
              foregroundColor:
                  MaterialStateProperty.all<Color>(colorScheme.onBackground),
            ),
        onPressed: !isLoading ? onPressed : null,
        child: SizedBox(
          width: SizeTokens.x72,
          child: SpacedColumn(
            spacing: SpaceTokens.verySmall,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(SpaceTokens.medium),
                decoration: ShapeDecoration(
                  color: ThemeColorBuilder(context).getActionsColor(),
                  shape: const CircleBorder(),
                ),
                child: child,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyleTokens.bodyMedium(null),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The child widget to display within the button.
  final Widget child;

  /// The builder function to create the button widget based on child content.
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(Widget child, bool isLoading) buttonBuilder;

  /// A flag to determine whether the button is in a loading state.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return buttonBuilder(
      _ButtonChild(isLoading: isLoading, child: child),
      isLoading,
    );
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
    return Stack(
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
    );
  }
}
