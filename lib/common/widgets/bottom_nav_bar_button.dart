import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

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
            child: isLoading
                ? const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    btnText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
          ),
        ),
      ),
    );
  }
}
