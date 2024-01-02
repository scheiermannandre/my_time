import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Enum representing different workplace options.
enum Workplace {
  /// Workplace is remote.
  remote,

  /// Workplace is at the office.
  office,

  /// Workplace is a home office.
  homeOffice,
}

/// Extension for the Workplace enum.
extension WorkplaceExtension on Workplace {
  /// Get the label associated with the workplace.
  String label(BuildContext context) {
    switch (this) {
      case Workplace.remote:
        return context.loc.workplaceRemote; // Remote
      case Workplace.office:
        return context.loc.workplaceOffice; // Office
      case Workplace.homeOffice:
        return context.loc.workplaceHomeOffice; // Home Office
    }
  }
}
