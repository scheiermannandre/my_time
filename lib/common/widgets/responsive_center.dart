import 'package:flutter/material.dart';
import 'package:my_time/constants/breakpoints.dart';

class ResponsiveAlign extends StatelessWidget {
  const ResponsiveAlign({
    super.key,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    required this.child,
  });
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: maxContentWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class ResponsiveSliverAlign extends StatelessWidget {
  const ResponsiveSliverAlign({
    super.key,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    required this.child,
  });
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveAlign(
        maxContentWidth: maxContentWidth,
        padding: padding,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
