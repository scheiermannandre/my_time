import 'package:flutter/material.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/dissmissible_tile/shake_widget.dart';

class DismissibleTile extends StatefulWidget {
  late Widget widget;
  late String title;
  late Function(String title) onDeleted;
  late Function? onTileTab;

  DismissibleTile(
      {super.key,
      required this.widget,
      required this.title,
      required this.onDeleted,
      this.onTileTab});
  late bool _isInitialValue = true;
  @override
  State<DismissibleTile> createState() => _DismissibleTileState();
}

class _DismissibleTileState extends State<DismissibleTile>
    with TickerProviderStateMixin {
  late AnimationController bottomSheetController;

  @override
  initState() {
    super.initState();
    bottomSheetController = BottomSheet.createAnimationController(this);
    bottomSheetController.duration = const Duration(milliseconds: 600);
    bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
    widget.onTileTab ??= () {};
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakeKey = GlobalKey<ShakeWidgetState>();
    double height = MediaQuery.of(context).size.height * 0.075;
    bool wasIconShaken = false;
    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            key: ValueKey(widget.title),
            onEnd: () {
              widget.onDeleted(widget.title);
              setState(() {});
            },
            duration: const Duration(milliseconds: 250),
            height: widget._isInitialValue ? height : 0,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: GlobalProperties.ShadowColor,
                  blurRadius: 1.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                )
              ],
              color: Colors.red,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget._isInitialValue
                    ? ShakeWidget(
                        key: shakeKey,
                        shakeCount: 1.5,
                        shakeDuration: const Duration(milliseconds: 375),
                        child: const Icon(
                          Icons.delete,
                          color: GlobalProperties.BackgroundColor,
                        ),
                      )
                    : const SizedBox.shrink(),
                const Padding(padding: EdgeInsets.only(right: 20))
              ],
            ),
          ),
        ),
        widget._isInitialValue
            ? Dismissible(
                onUpdate: (details) {
                  if (details.progress > 0.1 && !wasIconShaken) {
                    wasIconShaken = true;
                    shakeKey.currentState!.shake();
                  }
                  if (details.progress == 0) {
                    wasIconShaken = false;
                  }
                },
                direction: DismissDirection.endToStart,
                confirmDismiss: (DismissDirection direction) async {
                  bool? result = await openBottomSheet(
                      context: context,
                      bottomSheetController: bottomSheetController,
                      title: "Are you sure you wish to delete?",
                      message: "everything will be deleted",
                      onCanceled: () => Navigator.of(context).pop(false),
                      onConfirmed: () => Navigator.of(context).pop(true),
                      confirmBtnText: "Continue");
                  if (result == null) {
                    return false;
                  } else {
                    return result;
                  }
                },
                onDismissed: (direction) {
                  setState(() {
                    widget._isInitialValue = false;
                  });
                },
                key: ValueKey(widget.title),
                child: Center(
                  child: InkWell(
                    onTap: widget.onTileTab != null
                        ? () => widget.onTileTab!()
                        : null,
                    child: Container(
                        height: height,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: GlobalProperties.PrimaryAccentColor,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: widget.widget),
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
