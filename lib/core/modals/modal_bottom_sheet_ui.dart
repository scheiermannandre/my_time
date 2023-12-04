import 'package:flutter/material.dart';

/// A utility class for showing bottom sheets.
class ModalBottomSheetUI {
  /// Shows a bottom sheet with widgets.
  static Future<T?> show<T>({
    required BuildContext context,
    required AnimationController bottomSheetController,
    required Widget widget,
    VoidCallback? whenComplete,
    double? heightFactor,
  }) async {
    return showModalBottomSheet<T>(
      transitionAnimationController: bottomSheetController,
      isScrollControlled: true,
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: heightFactor,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: widget,
        ),
      ),
    ).whenComplete(
      () {
        if (whenComplete != null) {
          whenComplete();
        }
      },
    );
  }
}
