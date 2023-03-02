import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final ScrollController? controller;
  final List<IconButton>? actions;
  CustomAppBar({super.key, required this.title, this.controller, this.actions})
      : preferredSize = const Size.fromHeight(kToolbarHeight * 2);

  @override
  late Size preferredSize;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool showElevation = false;
  int appBarRows = 2;
  EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);

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

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
        child: widget.actions![index]);
  }

  void pop() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: GlobalProperties.secondaryAccentColor,
        boxShadow: showElevation
            ? <BoxShadow>[
                const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0))
              ]
            : null,
      ),
      child: SafeArea(
        child: Column(children: [
          ResponsiveAlign(
            maxContentWidth: double.infinity,
            child: Container(
              color: GlobalProperties.secondaryAccentColor,
              padding: const EdgeInsets.fromLTRB(4, 10, 10, 4),
              height: kToolbarHeight,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: widget.actions != null
                          ? List<Widget>.generate(widget.actions!.length,
                              (index) => _itemBuilder(context, index)).toList()
                          : [],
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: ResponsiveAlign(
              padding: padding,
              child: Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 28,
                    color: GlobalProperties.textAndIconColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
