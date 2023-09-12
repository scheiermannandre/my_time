import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

/// Key for the bottom sheet.
const bottomSheetKey = Key('bottomSheet');

/// Shows a bottom sheet with widgets.
Future<void> showBottomSheetWithWidgets({
  required BuildContext context,
  required AnimationController bottomSheetController,
  required List<Widget> widgets,
  VoidCallback? whenComplete,
}) async {
  return showModalBottomSheet<void>(
    backgroundColor: GlobalProperties.backgroundColor,
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) => FractionallySizedBox(
      key: bottomSheetKey,
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: GlobalProperties.dragIndicatorColor,
                    border: Border.all(
                      color: GlobalProperties.dragIndicatorColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              ...widgets,
            ],
          ),
        ),
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
