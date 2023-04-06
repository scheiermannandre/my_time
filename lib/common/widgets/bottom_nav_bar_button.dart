import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';

class NavBarSubmitButton extends StatelessWidget {
  final double btnWidth = Breakpoint.mobile;
  final VoidCallback? onBtnTap;
  final String btnText;
  final bool isLoading;
  final Alignment align;
  final EdgeInsets padding;

  const NavBarSubmitButton(
      {super.key,
      required this.onBtnTap,
      required this.btnText,
      required this.isLoading,
      this.align = Alignment.center,
      this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 0)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: ResponsiveAlign(
        alignment: align,
        maxContentWidth: Breakpoint.desktop,
        padding: padding,
        child: SizedBox(
          width: btnWidth,
          child: ElevatedButton(
            onPressed: onBtnTap,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
              backgroundColor: GlobalProperties.secondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: kBottomNavigationBarHeight / 2,
                    width: kBottomNavigationBarHeight / 2,
                    child: CircularProgressIndicator())
                : Text(
                    btnText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
