import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/standard_button.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/foundation/config/config.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends StatelessWidget {
  /// Constructor for the [EmptyPlaceholderWidget].
  const EmptyPlaceholderWidget({required this.message, super.key});

  /// Message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            StandardButton(
              onPressed: () => context.goNamed(AppRoute.home),
              text: 'Go Home',
            ),
          ],
        ),
      ),
    );
  }
}
