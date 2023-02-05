import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class RoundedLabeldButton extends StatelessWidget {
  final IconData icon;
  final String text;
  late Function onPressed;
  RoundedLabeldButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      padding: const EdgeInsets.all(2.5),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: GlobalProperties.secondaryAccentColor,
            child: IconButton(
              onPressed: () {
                onPressed();
              },
              icon: Icon(icon),
              color: GlobalProperties.textAndIconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: GlobalProperties.textAndIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
