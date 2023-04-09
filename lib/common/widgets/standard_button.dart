import 'package:flutter/material.dart';

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
        onPressed: (() {
          if (onPressed != null) {
            onPressed!();
          }
        }),
        child: isLoading
            ? const CircularProgressIndicator()
            : Opacity(
                opacity: opacitiy,
                child: Text(
                  text,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
      ),
    );
  }
}
