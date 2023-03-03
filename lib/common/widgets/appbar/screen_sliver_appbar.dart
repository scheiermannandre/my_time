// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/appbar/custom_flexible_spacebar.dart';
import 'package:my_time/common/widgets/responsive_center.dart';

import 'package:my_time/global/globals.dart';

class ScreenSliverAppBar extends StatefulWidget {
  late IconButton? leadingIconButton;
  late String title;
  ScreenSliverAppBar({
    Key? key,
    this.leadingIconButton,
    this.title = "",
  }) : super(key: key);

  @override
  State<ScreenSliverAppBar> createState() => _ScreenSliverAppBarState();
}

class _ScreenSliverAppBarState extends State<ScreenSliverAppBar> {
  bool _isLeadingConfigured() {
    return widget.leadingIconButton == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: _isLeadingConfigured() ? [widget.leadingIconButton!] : null,
      backgroundColor: GlobalProperties.secondaryAccentColor,
      expandedHeight: 175,
      floating: false,
      pinned: true,
      flexibleSpace: ResponsiveAlign(
        child: CustomFlexibleSpaceBar(
          titlePaddingTween: EdgeInsetsTween(
              begin: const EdgeInsets.only(left: 10.0, bottom: 0),
              end: const EdgeInsets.only(left: 10.0, bottom: 14)),
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          title: Text(
            widget.title,
            style: const TextStyle(
                color: GlobalProperties.textAndIconColor,
                fontSize: 24,
                fontWeight: FontWeight.normal),
          ),
          background: Container(
            color: GlobalProperties.secondaryAccentColor,
            child: Stack(
              fit: StackFit.expand, // expand stack
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 75,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 0,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
