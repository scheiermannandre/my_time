import 'package:flutter/material.dart';

/// Widget that shows an error message.
class ErrorMessageWidget extends StatelessWidget {
  /// Constructor for the [ErrorMessageWidget].
  const ErrorMessageWidget(this.errorMessage, {super.key});

  /// Error message to display.
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
    );
  }
}
