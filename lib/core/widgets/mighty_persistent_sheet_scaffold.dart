import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_bottom_sheet.dart';

/// A scaffold with a persistent bottom sheet that can be dragged to
/// reveal more content.
class MightyPersistentSheetScaffold extends StatelessWidget {
  /// Constructs a [MightyPersistentSheetScaffold] with the required parameters.
  MightyPersistentSheetScaffold({
    required this.themeController,
    required this.bottomSheetWidgetBuilder,
    required this.minChildSize,
    required this.maxChildSize,
    super.key,
    this.appBar,
    this.body,
  })  : assert(
            maxChildSize <= 1 && maxChildSize > 0,
            'maxChildSize must be '
            'between 0 and 1'),
        assert(
            minChildSize <= maxChildSize &&
                minChildSize >= 0 &&
                minChildSize <= 1,
            'minChildSize must be '
            'between 0 and 1 and smaller than or equal to maxChildSize');

  /// The theme controller for adapting the scaffold's appearance.
  final MightyThemeController themeController;

  /// The app bar displayed at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The main body of the scaffold.
  final Widget? body;

  /// A builder function that constructs the content of the bottom sheet.
  final BottomSheetWidgetBuilder? bottomSheetWidgetBuilder;

  /// The minimum fraction of the screen height occupied by the bottom sheet.
  final double minChildSize;

  /// The maximum fraction of the screen height occupied by the bottom sheet.
  final double maxChildSize;

  /// The controller for the draggable scrollable widget.
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  /// Hides the bottom sheet by animating it to the minimum child size.
  void hideBottomSheet() {
    if (!draggableScrollableController.isAttached) return;
    draggableScrollableController.animateTo(
      minChildSize,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.mainBackgroundColor,
      appBar: appBar,
      body: Listener(
        onPointerDown: (event) {
          hideBottomSheet();
        },
        // ColoredBox is necessary because the listener seems to react on
        // Material widgets. Wrapping in Material has more parameters to
        // configure than the ColoredBox.
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final appBarHeight = Scaffold.of(context).appBarMaxHeight!;
                  final screenHeight =
                      MediaQuery.of(context).size.height - appBarHeight;
                  final bodyHeight = screenHeight * (1 - minChildSize);
                  return body != null
                      ? SizedBox(
                          height: bodyHeight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpaceTokens.medium,
                            ),
                            child: body,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: bottomSheetWidgetBuilder != null
          ? MightyBottomSheet(
              draggableScrollableController: draggableScrollableController,
              themeController: themeController,
              maxChildSize: maxChildSize,
              minChildSize: minChildSize,
              builder: bottomSheetWidgetBuilder!,
            )
          : null,
    );
  }
}
