import 'package:flutter/material.dart';

/// Custom AppBar with dynamic elevation visibility.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Constructor for the [CustomAppBar].
  const CustomAppBar({
    required String title,
    super.key,
    List<Widget>? actions,
    ScrollController? controller,
  })  : _controller = controller,
        _actions = actions,
        _title = title;
  final String _title;
  final List<Widget>? _actions;
  final ScrollController? _controller;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool showElevation = false;

  @override
  void initState() {
    if (widget._controller != null) {
      widget._controller!.addListener(changeElevation);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeElevation() {
    setState(() {
      if (widget._controller!.offset > 0) {
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
      title: Text(widget._title),
      actions: widget._actions,
    );
  }
}
