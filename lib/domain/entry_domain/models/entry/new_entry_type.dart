import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';

/// The type of an entry.
enum NewEntryType {
  /// Regular entry.
  work,

  /// Entry for sick leave.
  sick,

  /// Entry for vacation.
  vacation,

  /// Entry for public holiday.
  publicHoliday,
}

/// Extension for the [NewEntryType].
extension EntryTypeExtension on NewEntryType {
  /// Returns the display name of the [NewEntryType] depending on the
  /// current locale.
  String displayName(BuildContext context) {
    switch (this) {
      case NewEntryType.work:
        return context.loc.entryTypeLabelWork;
      case NewEntryType.sick:
        return context.loc.entryTypeLabelSickLeave;
      case NewEntryType.vacation:
        return context.loc.entryTypeLabelVacation;
      case NewEntryType.publicHoliday:
        return context.loc.entryTypeLabelPublicHoliday;
    }
  }
}
