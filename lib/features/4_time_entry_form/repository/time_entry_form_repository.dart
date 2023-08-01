import 'package:my_time/features/4_time_entry_form/domain/time_entry.dart';

/// Repository for the time entry form feature.
abstract class TimeEntryFormRepository {
  /// Will add a new TimeEntry to the database.
  Future<bool> addTimeEntry(TimeEntryModel entry);

  /// Will update a TimeEntry in the database.
  Future<bool> updateTimeEntry(TimeEntryModel entry);

  /// Will delete a TimeEntry from the database.
  Future<bool> deleteEntry(TimeEntryModel entry);

  /// Will get a TimeEntry from the database by id.
  Future<TimeEntryModel> getEntryById(String id);

  /// Will get all TimeEntries from the database by project id.
  Future<List<TimeEntryModel>> getTimeEntriesByProjectId(String projectId);
}
