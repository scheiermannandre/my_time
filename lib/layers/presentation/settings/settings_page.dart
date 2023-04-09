import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/appbar/custom_flexible_spacebar.dart';
import 'package:my_time/global/globals.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  )),
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                  style: TextStyle(color: GlobalProperties.textAndIconColor),
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
                      backgroundColor: Theme.of(context).colorScheme.background,
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
                                    color: GlobalProperties.dragIndicatorColor,
                                    border: Border.all(
                                      color:
                                          GlobalProperties.dragIndicatorColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Default"),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .textAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: GlobalProperties.primaryColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .textAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              GlobalProperties.textAndIconColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .textAndIconColor),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: GlobalProperties.shadowColor,
                                          border: Border.all(
                                              color: GlobalProperties
                                                  .textAndIconColor),
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
                      padding: const EdgeInsets.all(8),
                      width: 100,
                      child: const Text("Default")),
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
