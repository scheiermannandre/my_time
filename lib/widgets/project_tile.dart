import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/main.dart';
import 'package:my_time/widgets/shake_widget.dart';

class ProjectTile2 extends StatefulWidget {
  late String title;
  late Alignment alignment;
  late EdgeInsets padding;
  late Function(String name) remove;

  ProjectTile2(
      {super.key,
      required this.title,
      required this.remove,
      this.alignment = Alignment.center,
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0)});
  bool _isInitialValue = true;
  @override
  State<ProjectTile2> createState() => _ProjectTile2State();
}

class _ProjectTile2State extends State<ProjectTile2>
    with TickerProviderStateMixin {
  late AnimationController bottomSheetController;
  late AnimationController hamburgerClosedAnimationController;

  @override
  initState() {
    super.initState();
    bottomSheetController = BottomSheet.createAnimationController(this);
    bottomSheetController.duration = const Duration(milliseconds: 600);
    bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
    hamburgerClosedAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    hamburgerClosedAnimationController.dispose();
    super.dispose();
  }

  // void animateHamburger() {
  //   setState(() {
  //     isPlaying = !isPlaying;
  //     isPlaying
  //         ? hamburgerClosedAnimationController.forward()
  //         : hamburgerClosedAnimationController.reverse();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final shakeKey = GlobalKey<ShakeWidgetState>();
    double height = MediaQuery.of(context).size.height * 0.075;
    double width = MediaQuery.of(context).size.width * 0.925;
    bool _wasIconShaken = false;
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
                  widget.remove(widget.title);
                },
                duration: const Duration(milliseconds: 250),
                width: width,
                height: widget._isInitialValue ? height : 0,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: GlobalProperties.ShadowColor,
                      blurRadius: 5.0, // soften the shadow
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
                      if (details.progress > 0.1 && !_wasIconShaken) {
                        _wasIconShaken = true;
                        shakeKey.currentState!.shake();
                      }
                      if (details.progress == 0) {
                        _wasIconShaken = false;
                      }
                    },
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (DismissDirection direction) async {
                      bool result = await showModalBottomSheet(
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
                                //const Text("Confirm"),
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
                      return result;
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: Text(
                                "Are you sure you wish to delete ${widget.title}"),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("DELETE")),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        widget._isInitialValue = false;
                      });
                    },
                    key: ValueKey(widget.title),
                    child: Center(
                      child: InkWell(
                        //splashColor: Colors.transparent,
                        //focusColor: Colors.transparent,
                        onTap: () {
                          //GoRouter.of(context).goNamed("/project");
                        },

                        child: Container(
                          height: height,
                          width: width,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: GlobalProperties.ShadowColor,
                                blurRadius: 5.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 5  horizontally
                                  0.0, // Move to bottom 5 Vertically
                                ),
                              )
                            ],
                            color: GlobalProperties.PrimaryAccentColor,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                              //const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
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
