import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

Future<dynamic> openBottomSheet({
  required BuildContext context,
  required AnimationController bottomSheetController,
  required String title,
  required String message,
  required String confirmBtnText,
  required String cancelBtnText,
  required Function onCanceled,
  required Function onConfirmed,
}) async {
  return await showModalBottomSheet(
    backgroundColor: GlobalProperties.backgroundColor,
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
                  color: GlobalProperties.dragIndicatorColor,
                  border: Border.all(
                    color: GlobalProperties.dragIndicatorColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () => onCanceled(),
                  child: Text(
                    cancelBtnText,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => onConfirmed(),
                  child: Text(
                    confirmBtnText,
                    style: Theme.of(context).textTheme.titleSmall,
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
