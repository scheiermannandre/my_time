import 'package:flutter/material.dart';
import 'package:my_time/constants/breakpoints.dart';

/// A widget that aligns its child and makes it responsive.
class ResponsiveAlign extends StatelessWidget {
  /// Constructor for the [ResponsiveAlign].
  const ResponsiveAlign({
    required this.child,
    super.key,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
  });

  /// Maximum width of the content.
  final double maxContentWidth;

  /// Padding of the content.
  final EdgeInsetsGeometry padding;

  /// Alignment of the content.
  final Alignment alignment;

  /// Child of the widget.
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

/// A widget that aligns its child and makes it responsive in a Sliver.
class ResponsiveSliverAlign extends StatelessWidget {
  /// Constructor for the [ResponsiveSliverAlign].
  const ResponsiveSliverAlign({
    required this.child,
    super.key,
    this.maxContentWidth = Breakpoint.desktop,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
  });

  /// Maximum width of the content.
  final double maxContentWidth;

  /// Padding of the content.
  final EdgeInsetsGeometry padding;

  /// Alignment of the content.
  final Alignment alignment;

  /// Child of the widget.
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
