import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';

/// The type of an entry.
enum EntryType {
  /// Regular entry.
  work,

  /// Entry for sick leave.
  sick,

  /// Entry for vacation.
  vacation,

  /// Entry for public holiday.
  publicHoliday,
}

/// Extension for the [EntryType].
extension EntryTypeExtension on EntryType {
  /// Returns the display name of the [EntryType] depending on the
  /// current locale.
  String displayName(BuildContext context) {
    switch (this) {
      case EntryType.work:
        return context.loc.entryTypeLabelWork;
      case EntryType.sick:
        return context.loc.entryTypeLabelSickLeave;
      case EntryType.vacation:
        return context.loc.entryTypeLabelVacation;
      case EntryType.publicHoliday:
        return context.loc.entryTypeLabelPublicHoliday;
    }
  }
}
