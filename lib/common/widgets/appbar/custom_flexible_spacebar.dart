import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// See also:
///
///  * [SliverAppBar], which implements the expanding and contracting.
///  * [AppBar], which is used by [SliverAppBar].
///  * <https://material.io/design/components/app-bars-top.html#behavior>
class CustomFlexibleSpaceBar extends StatefulWidget {
  /// Creates a flexible space bar.
  ///
  /// Most commonly used in the [AppBar.flexibleSpace] field.
  const CustomFlexibleSpaceBar({
    super.key,
    this.title,
    this.foreground,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.titlePaddingTween,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
  });

  /// The primary contents of the flexible space bar when expanded.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The primary contents of the flexible space bar when expanded.
  final Widget? foreground;

  /// Shown behind the [title] when expanded.
  ///
  /// Typically an [Image] widget with [Image.fit] set to [BoxFit.cover].
  final Widget? background;

  /// Whether the title should be centered.
  ///
  /// By default this property is true if the current target platform
  /// is [TargetPlatform.iOS] or [TargetPlatform.macOS], false otherwise.
  final bool? centerTitle;

  /// Collapse effect while scrolling.
  ///
  /// Defaults to [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Stretch effect while over-scrolling.
  ///
  /// Defaults to include [StretchMode.zoomBackground].
  final List<StretchMode> stretchModes;

  /// Defines how far the [title] is inset from either the widget's
  /// bottom-left or its center.
  ///
  /// Typically this property is used to adjust how far the title is
  /// is inset from the bottom-left and it is specified along with
  /// [centerTitle] false.
  ///
  /// By default the value of this property is
  /// `EdgeInsetsDirectional.only(start: 72, bottom: 16)` if the title is
  /// not centered, `EdgeInsetsDirectional.only(start: 0, bottom: 16)`
  /// otherwise.
  final EdgeInsetsGeometry? titlePadding;

  /// Defines how far the [title] is inset from either the widget's
  final EdgeInsetsTween? titlePaddingTween;

  @override
  CustomFlexibleSpaceBarState createState() => CustomFlexibleSpaceBarState();
}

/// The current state of a [CustomFlexibleSpaceBar].
class CustomFlexibleSpaceBarState extends State<CustomFlexibleSpaceBar> {
  bool? _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) {
      return widget.centerTitle;
    }
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) return Alignment.bottomCenter;
    final textDirection = Directionality.of(context);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0;
      case CollapseMode.parallax:
        final deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        assert(
          settings != null,
          'A FlexibleSpaceBar must be wrapped in the widget returned '
          'by FlexibleSpaceBar.createSettings().',
        );

        final children = <Widget>[];

        final deltaExtent = settings!.maxExtent - settings.minExtent;

        // 0.0 -> Expanded
        // 1.0 -> Collapsed to toolbar
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);

        // background
        if (widget.background != null) {
          final double fadeStart = max(0, 1.0 - kToolbarHeight / deltaExtent);
          const fadeEnd = 1.0;
          assert(fadeStart <= fadeEnd, 'The fadeStart must be <= fadeEnd');
          final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
          var height = settings.maxExtent;

          // StretchMode.zoomBackground
          if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
              constraints.maxHeight > height) {
            height = constraints.maxHeight;
          }
          children.add(
            Positioned(
              top: _getCollapsePadding(t, settings),
              left: 0,
              right: 0,
              height: height,
              child: Opacity(
                // IOS is relying on this semantics node to correctly traverse
                // through the app bar when it is collapsed.
                alwaysIncludeSemantics: true,
                opacity: opacity,
                child: widget.background,
              ),
            ),
          );

          // StretchMode.blurBackground
          if (widget.stretchModes.contains(StretchMode.blurBackground) &&
              constraints.maxHeight > settings.maxExtent) {
            final blurAmount =
                (constraints.maxHeight - settings.maxExtent) / 10;
            children.add(
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurAmount,
                    sigmaY: blurAmount,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            );
          }
        }

        // title
        if (widget.title != null) {
          final theme = Theme.of(context);

          Widget? title;
          switch (theme.platform) {
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              title = widget.title;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              title = Semantics(
                namesRoute: true,
                child: widget.title,
              );
          }

          // StretchMode.fadeTitle
          if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
              constraints.maxHeight > settings.maxExtent) {
            final stretchOpacity = 1 -
                (((constraints.maxHeight - settings.maxExtent) / 100)
                    .clamp(0.0, 1.0));
            title = Opacity(
              opacity: stretchOpacity,
              child: title,
            );
          }

          final opacity = settings.toolbarOpacity;
          if (opacity > 0.0) {
            var titleStyle = theme.primaryTextTheme.titleLarge;
            titleStyle = titleStyle!
                .copyWith(color: titleStyle.color?.withOpacity(opacity));
            final effectiveCenterTitle = _getEffectiveCenterTitle(theme);
            final padding = widget.titlePadding ??
                widget.titlePaddingTween?.transform(t) ??
                EdgeInsetsDirectional.only(
                  start: effectiveCenterTitle! ? 0.0 : 72.0,
                  bottom: 16,
                );
            final scaleValue = Tween<double>(begin: 1.5, end: 1).transform(t);
            final scaleTransform = Matrix4.identity()
              ..scale(scaleValue, scaleValue, 1);
            final titleAlignment = _getTitleAlignment(effectiveCenterTitle!);
            children.add(
              Container(
                padding: padding,
                child: Transform(
                  alignment: titleAlignment,
                  transform: scaleTransform,
                  child: Align(
                    alignment: titleAlignment,
                    child: DefaultTextStyle(
                      style: titleStyle,
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            width: constraints.maxWidth / scaleValue,
                            alignment: titleAlignment,
                            child: title,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        if (widget.foreground != null) {
          children.add(widget.foreground!);
        }

        return ClipRect(child: Stack(children: children));
      },
    );
  }
}
