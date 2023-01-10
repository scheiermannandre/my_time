import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/widgets/custom_flexible_spacebar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 600);
    controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalProperties.BackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: GlobalProperties.TextAndIconColor,
                  )),
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              // automaticallyImplyLeading: true,
              // leading: Icon(Icons.arrow_back),
              expandedHeight: 150,
              floating: false,
              pinned: true,
              flexibleSpace: CustomFlexibleSpaceBar(
                titlePaddingTween: EdgeInsetsTween(
                    begin: const EdgeInsets.only(left: 16.0, bottom: 16),
                    end: const EdgeInsets.only(left: 55.0, bottom: 16)),
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                title: const Text(
                  'Settings',
                  style: TextStyle(color: GlobalProperties.TextAndIconColor),
                ),
                //background: Placeholder(),
                // foreground: ,
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: GlobalProperties.BackgroundColor,
                      transitionAnimationController: controller,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => Container(
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
                                      color:
                                          GlobalProperties.DragIndicatorColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Default"),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: GlobalProperties
                                              .PrimaryAccentColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .TextAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: GlobalProperties
                                              .SecondaryAccentColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .TextAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              GlobalProperties.TextAndIconColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .TextAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: GlobalProperties.ShadowColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .TextAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  trailing: Container(
                      padding: EdgeInsets.all(8),
                      width: 100,
                      child: Text("Default")),
                  title: Text('Theme ${index + 1}', textScaleFactor: 1),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
