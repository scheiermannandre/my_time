import 'package:flutter/material.dart';

/// Standard button widget.
class StandardButton extends StatelessWidget {
  /// Constructor for the [StandardButton].
  const StandardButton({
    required this.text,
    super.key,
    this.isLoading = false,
    this.onPressed,
    this.width,
    this.height,
    this.opacitiy = 1.0,
  });

  /// Text to display on the button.
  final String text;

  /// Whether the button is loading.
  final bool isLoading;

  /// Function to call when the button is pressed.
  final VoidCallback? onPressed;

  /// Width of the button.
  final double? width;

  /// Height of the button.
  final double? height;

  /// Opacity of the button.
  final double opacitiy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : Opacity(
                opacity: opacitiy,
                child: Text(
                  text,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
      ),
    );
  }
}
