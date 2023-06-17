import 'package:flutter/material.dart';

class DayTabItem extends StatelessWidget {
  const DayTabItem({
    super.key,
    required this.onTap,
    required this.weekDay,
    required this.date,
  });
  final Function() onTap;
  final String weekDay;
  final String date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 44, right: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(weekDay, style: const TextStyle(fontSize: 10)),
            Text(date, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
