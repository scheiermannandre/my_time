import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

abstract class TimeEntriesRepository {
  Future<bool> saveTimeEntry(TimeEntryModel entry);
}
