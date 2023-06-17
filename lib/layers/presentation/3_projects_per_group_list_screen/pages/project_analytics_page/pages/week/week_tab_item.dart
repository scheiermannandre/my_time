import 'package:flutter/material.dart';

class WeekTabItem extends StatelessWidget {
  const WeekTabItem({
    super.key,
    required this.onTap,
    required this.week,
    required this.dateSpan,
  });
  final Function() onTap;
  final String week;
  final String dateSpan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 44, right: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(week, style: const TextStyle(fontSize: 16)),
            Text(dateSpan, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
