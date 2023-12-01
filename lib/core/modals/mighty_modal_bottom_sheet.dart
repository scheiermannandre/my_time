import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/core/widgets/notch.dart';

/// Shows a bottom sheet with widgets.
Future<T?> showMightyModalBottomSheet<T>({
  required BuildContext context,
  required AnimationController bottomSheetController,
  required Widget widget,
  VoidCallback? whenComplete,
  double? heightFactor,
}) async {
  const cornerRadius = CornerRadiusTokens.large;
  return showModalBottomSheet<T>(
    barrierColor: Colors.grey.withOpacity(.05),
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius)),
    ),
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, child) {
        // ignore: unused_local_variable
        final themColorBuilder = ThemeColorBuilder(context);
        return ModalBottomSheetBody(
          cornerRadius: cornerRadius,
          heightFactor: heightFactor,
          widget: widget,
          backgroundColor:
              Colors.yellow, // themColorBuilder.mainBackgroundColor,
          notchColor:
              Colors.yellow, //themColorBuilder.nonDecorativeBorderColor,
          // shadowColor: themColorBuilder.themeMode == SystemThemeMode.light
          //     ? LightThemeColorTokens.lightColor
          //     : DarkThemeColorTokens.black,
        );
      },
    ),
  ).whenComplete(
    () {
      if (whenComplete != null) {
        whenComplete();
      }
    },
  );
}

/// A widget representing the body of a modal bottom sheet.
class ModalBottomSheetBody extends StatelessWidget {
  /// Creates a [ModalBottomSheetBody] with the specified parameters.
  const ModalBottomSheetBody({
    required this.widget,
    required this.notchColor,
    required this.backgroundColor,
    // required this.shadowColor,
    super.key,
    this.heightFactor,
    this.cornerRadius = 0,
  });

  /// The widget to be displayed in the body of the modal bottom sheet.
  final Widget widget;

  /// The color of the notch at the top of the modal bottom sheet.
  final Color notchColor;

  /// The background color of the modal bottom sheet.
  final Color backgroundColor;

  /// The factor of the screen height to determine the height of the
  /// modal bottom sheet.
  final double? heightFactor;

  /// The corner radius of the top-left and top-right corners of
  /// the modal bottom sheet.
  final double cornerRadius;

  /// The color of the shadow beneath the modal bottom sheet.
  // final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        decoration: BoxDecoration(
          //color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cornerRadius),
            topRight: Radius.circular(cornerRadius),
          ),
          boxShadow: const [
            BoxShadow(
              //color: shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(.6, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Notch(notchColor: notchColor),
              widget,
            ],
          ),
        ),
      ),
    );
  }
}
