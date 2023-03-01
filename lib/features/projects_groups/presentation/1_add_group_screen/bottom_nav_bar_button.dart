import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';

class NavBarButton extends StatelessWidget {
  final double btnWidth = Breakpoint.mobile;
  final Function() onBtnTap;
  const NavBarButton({super.key, required this.onBtnTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: ResponsiveAlign(
        alignment: Alignment.center,
        maxContentWidth: Breakpoint.desktop,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SizedBox(
          width: btnWidth,
          child: ElevatedButton(
            onPressed: () => onBtnTap(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
              backgroundColor: GlobalProperties.secondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            child: const Text(
              "Save",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: GlobalProperties.textAndIconColor),
            ),
          ),
        ),
      ),
    );
  }
}
