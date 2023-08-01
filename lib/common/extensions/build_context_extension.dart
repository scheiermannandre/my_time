// app_localizations_context.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension for the [BuildContext] class, that gives access
/// to Applocalizations.
extension LocalizedBuildContext on BuildContext {
  /// Returns the [AppLocalizations] instance.
  AppLocalizations get loc => AppLocalizations.of(this);
}
