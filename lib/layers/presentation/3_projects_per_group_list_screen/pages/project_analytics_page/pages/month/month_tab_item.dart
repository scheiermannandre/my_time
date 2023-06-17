
import 'package:flutter/material.dart';

class MonthTabItem extends StatelessWidget {
  const MonthTabItem({
    super.key,
    required this.onTap,
    required this.month,
    required this.year,
  });
  final Function() onTap;
  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 44, right: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(month, style: const TextStyle(fontSize: 16)),
            Text(year, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
