import 'package:flutter/material.dart';

/// A rounded button with a label.
class RoundedLabeldButton extends StatelessWidget {
  /// Constructor for the [RoundedLabeldButton].
  const RoundedLabeldButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    super.key,
  });

  /// Icon of the button.
  final IconData icon;

  /// Text of the button.
  final String text;

  /// Callback for the button.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      padding: const EdgeInsets.all(2.5),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
