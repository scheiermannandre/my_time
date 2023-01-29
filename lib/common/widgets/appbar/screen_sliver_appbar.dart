// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:my_time/common/widgets/appbar/custom_flexible_spacebar.dart';
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
      //leading: widget.leadingIconButton,
      actions: _isLeadingConfigured() ? [widget.leadingIconButton!] : null,
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
        title: Text(
          widget.title,
          style: const TextStyle(color: GlobalProperties.TextAndIconColor),
        ),
        //background: Placeholder(),
        // foreground: ,
      ),
    );
  }
}
