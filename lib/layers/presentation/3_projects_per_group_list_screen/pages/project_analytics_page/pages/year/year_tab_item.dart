import 'package:flutter/material.dart';

class YearTabItem extends StatelessWidget {
  const YearTabItem({
    super.key,
    required this.onTap,
    required this.year,
  });
  final Function() onTap;
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
            Text(year, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
