import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final Duration duration;
  const TimeDisplay({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours.remainder(24));
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
      alignment: Alignment.center,
      height: 250,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
      child: Container(
        alignment: Alignment.center,
        height: 245,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hours,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  ":",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  minutes,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            Text(
              seconds,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            )
          ],
        ),
      ),
    );
  }
}
