import 'package:flutter/material.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/notch.dart';

/// Callback function signature for building the content of the
/// MightyBottomSheet.
typedef BottomSheetWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

/// A customizable bottom sheet that adapts its appearance based on the
/// provided theme.
class MightyBottomSheet extends StatelessWidget {
  /// Constructs a [MightyBottomSheet] with required parameters.
  const MightyBottomSheet({
    required this.themeController,
    required this.maxChildSize,
    required this.minChildSize,
    required this.builder,
    required this.draggableScrollableController,
    super.key,
  });

  /// The theme controller for adapting the bottom sheet's appearance.
  final MightyThemeController themeController;

  /// The maximum height of the bottom sheet when expanded.
  final double maxChildSize;

  /// The minimum height of the bottom sheet when collapsed.
  final double minChildSize;

  /// The builder function for constructing the content of the bottom sheet.
  final BottomSheetWidgetBuilder builder;

  /// The controller for the draggable scrollable sheet.
  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      draggableScrollableController: draggableScrollableController,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      backgroundColor: themeController.mainBackgroundColor,
      shadowColor: themeController.themeMode == SystemThemeMode.light
          ? LightThemeColorTokens.lightColor
          : DarkThemeColorTokens.black,
      notchColor: themeController.nonDecorativeBorderColor,
      cornerRadius: CornerRadiusTokens.large,
      builder: builder,
    );
  }
}

/// A customizable bottom sheet that supports dynamic resizing
/// based on its child's size.
class BottomSheet extends StatefulWidget {
  /// Constructs a [BottomSheet] with required parameters.
  const BottomSheet({
    required this.minChildSize,
    required this.maxChildSize,
    required this.cornerRadius,
    required this.backgroundColor,
    required this.shadowColor,
    required this.notchColor,
    required this.builder,
    required this.draggableScrollableController,
    super.key,
  });

  /// The minimum height of the bottom sheet when collapsed.
  final double minChildSize;

  /// The maximum height of the bottom sheet when expanded.
  final double maxChildSize;

  /// The corner radius of the bottom sheet's border.
  final double cornerRadius;

  /// The background color of the bottom sheet.
  final Color backgroundColor;

  /// The shadow color of the bottom sheet.
  final Color shadowColor;

  /// The color of the notch displayed at the top of the bottom sheet.
  final Color notchColor;

  /// The builder function for constructing the content of the bottom sheet.
  final BottomSheetWidgetBuilder builder;

  /// The controller for the draggable scrollable sheet.
  final DraggableScrollableController draggableScrollableController;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  final GlobalKey _childKey = GlobalKey();
  late double childHeight;

  @override
  void initState() {
    super.initState();
    childHeight = widget.maxChildSize;
    _addPostFrameCallback();
  }

  /// Adds a post frame callback to wait until the child is
  /// rendered and get its size.
  void _addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSizeOfChild();
    });
  }

  @override
  void didUpdateWidget(BottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _addPostFrameCallback();
  }

  /// Gets the size of the child widget and updates the
  /// maxChildSize accordingly.
  void getSizeOfChild() {
    final renderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    final childSize = renderBox.size;
    final appBarHeight = Scaffold.of(context).appBarMaxHeight!;
    final screenHeight = MediaQuery.of(context).size.height - appBarHeight;

    setState(() {
      childHeight = childSize.height / screenHeight;
      childHeight += .05;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxChildSize =
        childHeight < widget.maxChildSize ? childHeight : widget.maxChildSize;

    return DraggableScrollableSheet(
      controller: widget.draggableScrollableController,
      expand: false,
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 250),
      minChildSize: widget.minChildSize,
      maxChildSize: maxChildSize,
      initialChildSize: widget.minChildSize,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius),
            topRight: Radius.circular(widget.cornerRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(.6, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: SpaceTokens.large),
            child: Column(
              key: _childKey,
              children: [
                Notch(notchColor: widget.notchColor),
                widget.builder(context, scrollController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
