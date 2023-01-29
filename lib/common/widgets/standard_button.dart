import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class StandardButton extends StatelessWidget {
  const StandardButton(
      {super.key,
      required this.text,
      this.isLoading = false,
      this.onPressed,
      this.width,
      this.height,
      this.opacitiy = 1.0});
  final String text;
  final bool isLoading;
  final Function? onPressed;
  final double? width;
  final double? height;
  final double opacitiy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed != null ? () => onPressed!() : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
          backgroundColor: GlobalProperties.SecondaryAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Opacity(
                opacity: opacitiy,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: GlobalProperties.TextAndIconColor),
                ),
              ),
      ),
    );
  }
}
