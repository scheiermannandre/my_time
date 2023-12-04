import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

/// Defines the appearance of the application's list tiles.
class TileTheme extends ListTileThemeData {
  /// Constructs a [TileTheme] for customizing list tile appearance.
  const TileTheme({
    super.contentPadding,
    super.shape,
  });

  /// Constructs a light-themed [TileTheme].
  factory TileTheme.light() {
    return TileTheme._get();
  }

  /// Constructs a dark-themed [TileTheme].
  factory TileTheme.dark() {
    return TileTheme._get();
  }

  factory TileTheme._get() {
    return const TileTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(CornerRadiusTokens.small)),
      ),
    );
  }
}
