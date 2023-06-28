import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final ScrollController? controller;

  const CustomAppBar(
      {Key? key, required this.title, this.actions, this.controller})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool showElevation = false;

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.addListener(changeElevation);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeElevation() {
    setState(() {
      if (widget.controller!.offset > 0) {
        showElevation = true;
      } else {
        showElevation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: showElevation ? 4 : 0,
      title: Text(widget.title),
      actions: widget.actions,
    );
  }
}
