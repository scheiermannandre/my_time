import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/logic/project.dart';
import 'package:my_time/widgets/shake_widget.dart';

class CustomTile extends StatefulWidget {
  late Widget widget;
  late String title;
  late Alignment alignment;
  late EdgeInsets padding;
  late Function(String title) onProjectDeleted;

  CustomTile(
      {super.key,
      required this.widget,
      required this.title,
      required this.onProjectDeleted,
      this.alignment = Alignment.center,
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0)});
  bool _isInitialValue = true;
  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> with TickerProviderStateMixin {
  late AnimationController bottomSheetController;

  @override
  initState() {
    super.initState();
    bottomSheetController = BottomSheet.createAnimationController(this);
    bottomSheetController.duration = const Duration(milliseconds: 600);
    bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
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
    //double width = MediaQuery.of(context).size.width * 0.925;
    bool wasIconShaken = false;
    return Padding(
      padding: widget.padding,
      child: Align(
        alignment: widget.alignment,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                key: ValueKey(widget.title),
                onEnd: () {
                  widget.onProjectDeleted(widget.title);
                },
                duration: const Duration(milliseconds: 250),
                //width: width,
                height: widget._isInitialValue ? height : 0,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: GlobalProperties.ShadowColor,
                      blurRadius: 1.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 5  horizontally
                        0.0, // Move to bottom 5 Vertically
                      ),
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
                    //dismissThresholds: ,
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
                      bool? result = await showModalBottomSheet(
                        backgroundColor: GlobalProperties.PrimaryAccentColor,
                        transitionAnimationController: bottomSheetController,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
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
                                      color:
                                          GlobalProperties.DragIndicatorColor,
                                      border: Border.all(
                                        color:
                                            GlobalProperties.DragIndicatorColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                Text(
                                  "Are you sure you wish to delete ${widget.title}?",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                const Text(
                                  "All your tracked times for this Project will be also deleted and you won't be able to restore your data!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    //fontSize: 18,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: GlobalProperties
                                                .SecondaryAccentColor),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 12.5, 0, 12.5),
                                        backgroundColor: GlobalProperties
                                            .SecondaryAccentColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: GlobalProperties
                                                .TextAndIconColor),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 15))
                                  ],
                                ),
                              ],
                            )),
                          ),
                        ),
                      );
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
                        onTap: () async {
                          Navigator.of(context).pushNamed("/project");
                        },
                        child: Container(
                            height: height,
                            //width: width,
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
        ),
      ),
    );
  }
}
