import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class TimeDisplay extends StatelessWidget {
  final Duration duration;
  const TimeDisplay({super.key, required this.duration});

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours.remainder(24));
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
      alignment: Alignment.center,
      height: 250,
      decoration: const BoxDecoration(
          color: GlobalProperties.SecondaryAccentColor, shape: BoxShape.circle),
      child: Container(
        alignment: Alignment.center,
        height: 245,
        decoration: const BoxDecoration(
            color: GlobalProperties.BackgroundColor, shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildText(hours),
                _buildText(":"),
                _buildText(minutes),
              ],
            ),
            Text(
              seconds,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Color(0xff855827)),
            )
          ],
        ),
      ),
    );
  }
}
