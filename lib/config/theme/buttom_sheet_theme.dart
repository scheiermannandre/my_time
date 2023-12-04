import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';

/// Defines the appearance of the application's buttom sheet.
class ButtomSheetTheme extends BottomSheetThemeData {
  /// Constructs a [ButtomSheetTheme] for customizing buttom sheet appearance.
  const ButtomSheetTheme({
    super.shape,
    super.showDragHandle,
    super.dragHandleSize,
    super.modalBarrierColor,
    super.shadowColor,
  });

  /// Constructs a light-themed [ButtomSheetTheme].
  factory ButtomSheetTheme.light() {
    return ButtomSheetTheme._getButtomSheetTheme(
      LightThemeColorTokens.darkestColor,
    );
  }

  /// Constructs a dark-themed [ButtomSheetTheme].
  factory ButtomSheetTheme.dark() {
    return ButtomSheetTheme._getButtomSheetTheme(
      DarkThemeColorTokens.lightestColor,
    );
  }

  /// Internal method for generating a [ButtomSheetTheme] with specified colors.
  factory ButtomSheetTheme._getButtomSheetTheme(
    Color modalBarrierColor,
  ) {
    return ButtomSheetTheme(
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
