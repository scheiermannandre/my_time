import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/widgets/custom_flexible_spacebar.dart';
import 'package:my_time/widgets/custom_tile.dart';

class GroupsPage extends StatefulWidget {
  late List<String> groups;
  GroupsPage({super.key, required this.groups});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> with TickerProviderStateMixin {
  late AnimationController bottomSheetController;
  late List<String> groups = widget.groups;
  bool addGroup = false;
  EdgeInsets padding = const EdgeInsets.only(top: 3.75, bottom: 3.75);

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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Groups",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12.5),
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            onPressed: () {
              setState(() {
                if (addGroup) {
                  if (controller.text.isNotEmpty) {
                    groups.add(controller.text);
                  }
                  controller.clear();
                  addGroup = false;
                } else {
                  addGroup = true;
                }
              });
            },
            child: Text(
              !addGroup ? "Add Group" : "Save",
              style: const TextStyle(
                  fontSize: 16, color: GlobalProperties.TextAndIconColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> items = [];
    items.add(_buildHeader());
    items.addAll(_buildDropDownItems());
    return items;
  }

  TextEditingController controller = TextEditingController();

  Widget _buildTextFormField() {
    return TextFormField(
      controller: controller,
      cursorColor: GlobalProperties.SecondaryAccentColor,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        hintText: "Add new Group",
      ),
    );
  }

  List<Widget> _buildDropDownItems() {
    List<Widget> items = [];
    if (addGroup) {
      items.add(
        CustomTile(
          title: Random().nextInt(10000000).toString(),
          widget: _buildTextFormField(),
          onProjectDeleted: (name) {
            setState(() {
              addGroup = false;
            });
          },
          padding: padding,
        ),
      );
    }
    for (var element in groups) {
      items.add(
        CustomTile(
          title: element,
          widget: Text(
            element,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
          onProjectDeleted: (name) {
            setState(() {
              groups.remove(name);
            });
          },
          padding: padding,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.BackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              expandedHeight: 150,
              floating: false,
              pinned: true,
              flexibleSpace: CustomFlexibleSpaceBar(
                titlePaddingTween: EdgeInsetsTween(
                    begin: const EdgeInsets.only(left: 16.0, bottom: 16),
                    end: const EdgeInsets.only(left: 16.0, bottom: 16)),
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                title: const Text(
                  'Groups',
                  style: TextStyle(color: GlobalProperties.TextAndIconColor),
                ),
                //background: Placeholder(),
                // foreground: ,
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildChildren(),
                  ),
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
