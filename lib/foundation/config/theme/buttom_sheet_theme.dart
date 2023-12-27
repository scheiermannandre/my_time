import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';

/// Defines the appearance of the application's buttom sheet.
class ButtomSheetTheme extends BottomSheetThemeData {
  /// Constructs a [ButtomSheetTheme] for customizing buttom sheet appearance.
  const ButtomSheetTheme({
    super.shape,
    super.showDragHandle,
    super.dragHandleSize,
    super.modalBarrierColor,
    super.shadowColor,
    super.backgroundColor,
  });

  /// Constructs a light-themed [ButtomSheetTheme].
  factory ButtomSheetTheme.light() {
    return ButtomSheetTheme._getButtomSheetTheme(
      LightThemeColorTokens.darkestColor,
      LightThemeColorTokens.lightestColor,
    );
  }

  /// Constructs a dark-themed [ButtomSheetTheme].
  factory ButtomSheetTheme.dark() {
    return ButtomSheetTheme._getButtomSheetTheme(
      DarkThemeColorTokens.lightestColor,
      DarkThemeColorTokens.darkestColor,
    );
  }

  /// Internal method for generating a [ButtomSheetTheme] with specified colors.
  factory ButtomSheetTheme._getButtomSheetTheme(
    Color modalBarrierColor,
    Color backgroundColor,
  ) {
    return ButtomSheetTheme(
      backgroundColor: backgroundColor,
      showDragHandle: true,
      dragHandleSize: const Size(56, 6),
      modalBarrierColor: modalBarrierColor.withOpacity(.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CornerRadiusTokens.large),
        ),
      ),
    );
  }
}
