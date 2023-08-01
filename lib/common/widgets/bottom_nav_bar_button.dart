import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

/// Button that is displayed instead of the bottom navigation bar.
class NavBarSubmitButton extends StatelessWidget {
  /// Creates a [NavBarSubmitButton].
  const NavBarSubmitButton({
    required this.onBtnTap,
    required this.btnText,
    required this.isLoading,
    super.key,
    this.align = Alignment.center,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
  });

  /// Width of the button.
  double get btnWidth => Breakpoint.mobile;

  /// Callback that is called when the button is tapped.
  final VoidCallback? onBtnTap;

  /// Text of the button.
  final String btnText;

  /// Whether the button is loading.
  final bool isLoading;

  /// Alignment of the button.
  final Alignment align;

  /// Padding of the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ResponsiveAlign(
        alignment: align,
        padding: padding,
        child: SizedBox(
          width: btnWidth,
          child: ElevatedButton(
            onPressed: onBtnTap,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
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
