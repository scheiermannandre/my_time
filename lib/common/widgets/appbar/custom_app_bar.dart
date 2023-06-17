import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/router/app_route.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final ScrollController? controller;
  final TabBar? bottom;
  final List<Widget>? actions;
  CustomAppBar({super.key, required this.title, this.controller, this.actions, this.bottom})
      : preferredSize = Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight * 2);

  @override
  late Size preferredSize;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool showElevation = false;
  int appBarRows = 1;
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
        color: Theme.of(context).colorScheme.primary,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          ResponsiveAlign(
            maxContentWidth: double.infinity,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(4, 10, 10, 4),
              height: kToolbarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  gapW8,
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  gapW8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widget.actions != null
                        ? List<Widget>.generate(widget.actions!.length,
                                (index) => _itemBuilder(context, index))
                            .toList()
                        : [],
                  ),
                ],
              ),
            ),
          ),
           widget.bottom != null
                      ? widget.bottom!
                      : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
