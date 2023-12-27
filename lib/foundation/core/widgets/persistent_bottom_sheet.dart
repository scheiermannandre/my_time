import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/notch.dart';

/// Callback function signature for building the content of the
/// MightyBottomSheet.
typedef BottomSheetWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

/// A customizable bottom sheet that supports dynamic resizing
/// based on its child's size.
class PersistentBottomSheet extends StatefulWidget {
  /// Constructs a [PersistentBottomSheet] with required parameters.
  const PersistentBottomSheet({
    required this.minChildSize,
    required this.maxChildSize,
    required this.builder,
    required this.draggableScrollableController,
    super.key,
  });

  /// The minimum height of the bottom sheet when collapsed.
  final double minChildSize;

  /// The maximum height of the bottom sheet when expanded.
  final double maxChildSize;

  /// The builder function for constructing the content of the bottom sheet.
  final BottomSheetWidgetBuilder builder;

  /// The controller for the draggable scrollable sheet.
  final DraggableScrollableController draggableScrollableController;

  @override
  State<PersistentBottomSheet> createState() => _PersistentBottomSheetState();
}

class _PersistentBottomSheetState extends State<PersistentBottomSheet> {
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
  void didUpdateWidget(PersistentBottomSheet oldWidget) {
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

    final minHeight =
        childHeight < widget.minChildSize ? childHeight : widget.minChildSize;

    return DraggableScrollableSheet(
      controller: widget.draggableScrollableController,
      expand: false,
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 250),
      minChildSize: minHeight,
      maxChildSize: maxChildSize,
      initialChildSize: minHeight,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(CornerRadiusTokens.large),
            topRight: Radius.circular(CornerRadiusTokens.large),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: SpaceTokens.large),
              child: Column(
                key: _childKey,
                children: [
                  Notch(notchColor: Theme.of(context).colorScheme.shadow),
                  widget.builder(context, scrollController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
