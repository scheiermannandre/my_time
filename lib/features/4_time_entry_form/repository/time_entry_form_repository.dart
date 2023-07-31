import 'package:my_time/features/4_time_entry_form/domain/time_entry.dart';

abstract class TimeEntryFormRepository {
  Future<bool> addTimeEntry(TimeEntryModel entry);
  Future<bool> updateTimeEntry(TimeEntryModel entry);
  Future<bool> deleteEntry(TimeEntryModel entry);
  Future<TimeEntryModel> getEntryById(String id);
  Future<List<TimeEntryModel>> getTimeEntriesByProjectId(String projectId);
}
