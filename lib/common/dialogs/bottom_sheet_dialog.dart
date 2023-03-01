import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

Future<dynamic> showBottomSheetWithWidgets({
  required BuildContext context,
  required AnimationController bottomSheetController,
  Function()? whenComplete,
  required List<Widget> widgets,
}) async {
  return await showModalBottomSheet(
    backgroundColor: GlobalProperties.primaryAccentColor,
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: GlobalProperties.dragIndicatorColor,
                    border: Border.all(
                      color: GlobalProperties.dragIndicatorColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
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
