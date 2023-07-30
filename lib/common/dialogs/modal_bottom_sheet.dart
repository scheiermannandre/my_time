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
  required Future<bool> Function() onConfirmed,
  Future<void> Function(bool, bool)? whenCompleted,
}) async {
  return await showModalBottomSheet(
    backgroundColor: GlobalProperties.backgroundColor,
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (context) => ModalBottomSheet(
      title: title,
      message: message,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      onCanceled: onCanceled,
      onConfirmed: onConfirmed,
      whenCompleted: whenCompleted,
    ),
  );
}

class ModalBottomSheet extends StatefulWidget {
  final String title;
  final String message;
  final String confirmBtnText;
  final String cancelBtnText;
  final Function onCanceled;
  final Future<bool> Function() onConfirmed;
  final Future<void> Function(bool, bool)? whenCompleted;

  const ModalBottomSheet(
      {super.key,
      required this.title,
      required this.message,
      required this.confirmBtnText,
      required this.cancelBtnText,
      required this.onCanceled,
      required this.onConfirmed,
      required this.whenCompleted});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
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
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: !isLoading ? () => widget.onCanceled() : null,
                  child: Text(
                    widget.cancelBtnText,
                  ),
                ),
                ElevatedButton(
                  onPressed: !isLoading
                      ? () async {
                          setState(() {
                            isLoading = true;
                          });
                          final bool confirmed = await widget.onConfirmed();
                          if (confirmed) {
                            if (widget.whenCompleted != null) {
                              await widget.whenCompleted!(confirmed, mounted);
                            }
                            if (mounted) {
                              Navigator.of(context).pop(true);
                            }
                          }
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      : null,
                  child: !isLoading
                      ? Text(
                          widget.confirmBtnText,
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      : const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15))
              ],
            ),
          ],
        )),
      ),
    );
  }
}
