// ignore_for_file: one_member_abstracts

import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// Repository for the ProjectTimerPage that gives access to the time entries.
abstract class TimeEntriesRepository {
  /// Will save the time entry.
  Future<bool> saveTimeEntry(TimeEntryModel entry);
}
