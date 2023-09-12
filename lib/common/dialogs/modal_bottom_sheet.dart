import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

/// Shows a bottom sheet with widgets.
Future<bool?> openBottomSheet({
  required BuildContext context,
  required AnimationController bottomSheetController,
  required String title,
  required String message,
  required String confirmBtnText,
  required String cancelBtnText,
  required VoidCallback onCanceled,
  required Future<bool> Function() onConfirmed,
  Future<void> Function({bool confirmed, bool mounted})? whenCompleted,
}) async {
  return showModalBottomSheet<bool>(
    backgroundColor: GlobalProperties.backgroundColor,
    transitionAnimationController: bottomSheetController,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
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

/// Custom bottom sheet widget.
class ModalBottomSheet extends StatefulWidget {
  /// Constructor for the [ModalBottomSheet].
  const ModalBottomSheet({
    required this.title,
    required this.message,
    required this.confirmBtnText,
    required this.cancelBtnText,
    required this.onCanceled,
    required this.onConfirmed,
    required this.whenCompleted,
    super.key,
  });

  /// Title of the bottom sheet.
  final String title;

  /// Message of the bottom sheet.
  final String message;

  /// Text of the confirm button.
  final String confirmBtnText;

  /// Text of the cancel button.
  final String cancelBtnText;

  /// Callback function that is called when the cancel button is pressed.
  final VoidCallback onCanceled;

  /// Function that returns a [Future] with a [bool] value, when User confirms.
  final Future<bool> Function() onConfirmed;

  /// Callback function that is called when the bottom sheet is closed.
  final Future<void> Function({bool confirmed, bool mounted})? whenCompleted;

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
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
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
                            final confirmed = await widget.onConfirmed();
                            if (confirmed) {
                              if (widget.whenCompleted != null) {
                                await widget.whenCompleted!(
                                  confirmed: confirmed,
                                  mounted: mounted,
                                );
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
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
