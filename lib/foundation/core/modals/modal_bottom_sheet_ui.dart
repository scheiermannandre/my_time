import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';

/// A utility class for showing bottom sheets.
class ModalBottomSheetUI {
  /// Shows a bottom sheet with widgets.
  static Future<T?> showPage<T>({
    required BuildContext context,
    required Widget widget,
    AnimationController? bottomSheetController,
    VoidCallback? whenComplete,
    double? heightFactor,
  }) async {
    return showModalBottomSheet<T>(
      transitionAnimationController: bottomSheetController,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => _ModalBottomSheet._fullPage(child: widget),
    ).whenComplete(
      () {
        whenComplete?.call();
      },
    );
  }

  /// Shows a bottom sheet that is intended to be used as a confirmation
  /// before performing an action.
  static Future<bool?> showConfirmationSheet({
    required BuildContext context,
    required String title,
    required String message,
    AnimationController? bottomSheetController,
    VoidCallback? whenComplete,
    double? heightFactor,
  }) async {
    return showModalBottomSheet<bool?>(
      transitionAnimationController: bottomSheetController,
      isScrollControlled: true,
      context: context,
      builder: (context) => _ModalBottomSheet.confirmation(
        context: context,
        title: title,
        message: message,
      ),
    ).whenComplete(
      () {
        whenComplete?.call();
      },
    );
  }

  /// Shows a bottom sheet with widgets that sizes it self depending
  /// on the height of the content.
  static Future<T?> showDynamic<T>({
    required BuildContext context,
    required Widget widget,
    AnimationController? bottomSheetController,
    VoidCallback? whenComplete,
    double? heightFactor,
  }) async {
    return showModalBottomSheet<T>(
      transitionAnimationController: bottomSheetController,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => _ModalBottomSheet._dynamic(
        heightFactor: heightFactor,
        child: widget,
      ),
    ).whenComplete(
      () {
        whenComplete?.call();
      },
    );
  }
}

class _ModalBottomSheet extends StatelessWidget {
  const _ModalBottomSheet({
    required this.child,
    required this.isFullPage,
    this.heightFactor,
  });

  factory _ModalBottomSheet.confirmation({
    required BuildContext context,
    required String title,
    required String message,
    double? heightFactor,
  }) {
    return _ModalBottomSheet._dynamic(
      heightFactor: heightFactor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
        child: SpacedColumn(
          spacing: SpaceTokens.veryLarge,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SpacedColumn(
              spacing: SpaceTokens.verySmall,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyleTokens.getHeadline4(null),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyleTokens.bodyMedium(null),
                ),
              ],
            ),
            SpacedColumn(
              spacing: SpaceTokens.medium,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ActionButton.text(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(context.loc.deleteEntryCancelBtnLabel),
                ),
                ActionButton.primary(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(context.loc.deleteEntryConfirmBtnLabel),
                ),
                const SizedBox(
                  height: SpaceTokens.medium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  factory _ModalBottomSheet._dynamic({
    required Widget child,
    double? heightFactor,
  }) {
    return _ModalBottomSheet(
      isFullPage: false,
      heightFactor: heightFactor,
      child: child,
    );
  }

  factory _ModalBottomSheet._fullPage({required Widget child}) {
    return _ModalBottomSheet(
      isFullPage: true,
      heightFactor: 1,
      child: child,
    );
  }

  final Widget child;
  final bool isFullPage;
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FractionallySizedBox(
          heightFactor: heightFactor,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: isFullPage ? constraints.maxHeight : null,
              width: isFullPage ? constraints.maxWidth : null,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
