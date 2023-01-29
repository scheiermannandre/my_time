import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

Future<dynamic> openBottomSheet({
  required BuildContext context,
  required AnimationController bottomSheetController,
  required String title,
  required String message,
  required String confirmBtnText,
  required Function onCanceled,
  required Function onConfirmed,
}) async {
  return await showModalBottomSheet(
    backgroundColor: GlobalProperties.PrimaryAccentColor,
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (context) => FractionallySizedBox(
      //heightFactor: 0.9,
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
                  color: GlobalProperties.DragIndicatorColor,
                  border: Border.all(
                    color: GlobalProperties.DragIndicatorColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                //fontSize: 18,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () => onCanceled(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 16,
                        color: GlobalProperties.SecondaryAccentColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                    backgroundColor: GlobalProperties.SecondaryAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),
                  onPressed: () => onConfirmed(),
                  child: Text(
                    confirmBtnText,
                    style: const TextStyle(
                        fontSize: 16, color: GlobalProperties.TextAndIconColor),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15))
              ],
            ),
          ],
        )),
      ),
    ),
  );
}
