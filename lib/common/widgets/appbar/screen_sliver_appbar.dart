import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/appbar/custom_flexible_spacebar.dart';
import 'package:my_time/common/widgets/responsive_center.dart';

/// A [SliverAppBar] with a custom [FlexibleSpaceBar].
class ScreenSliverAppBar extends StatefulWidget {
  /// Constructor for the [ScreenSliverAppBar].
  const ScreenSliverAppBar({
    super.key,
    this.leadingIconButton,
    this.title = '',
  });

  /// Leading icon button.
  final IconButton? leadingIconButton;

  /// Title of the app bar.
  final String title;

  @override
  State<ScreenSliverAppBar> createState() => _ScreenSliverAppBarState();
}

class _ScreenSliverAppBarState extends State<ScreenSliverAppBar> {
  bool _isLeadingConfigured() {
    return widget.leadingIconButton != null;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: _isLeadingConfigured() ? [widget.leadingIconButton!] : null,
      backgroundColor: Theme.of(context).colorScheme.primary,
      expandedHeight: 175,
      pinned: true,
      flexibleSpace: ResponsiveAlign(
        child: CustomFlexibleSpaceBar(
          titlePaddingTween: EdgeInsetsTween(
            begin: const EdgeInsets.only(left: 10),
            end: const EdgeInsets.only(left: 10, bottom: 14),
          ),
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          background: ColoredBox(
            color: Theme.of(context).colorScheme.primary,
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
                      ),
                    ),
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
