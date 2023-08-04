import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

/// Service for the time entry form feature.
class TimeEntryFormService {
  /// Constructor for the [TimeEntryFormService].
  TimeEntryFormService(this._timeEntryFormRepository);

  /// The [TimeEntryFormRepository] instance.
  final TimeEntryFormRepository _timeEntryFormRepository;

  /// Will get a TimeEntry from the database by id.
  Future<TimeEntryModel> getEntryById(String id) async =>
      _timeEntryFormRepository.getEntryById(id);

  /// Will delete a TimeEntry from the database.
  Future<bool> deleteEntry(TimeEntryModel entry) async =>
      _timeEntryFormRepository.deleteEntry(entry);

  /// Will update a TimeEntry in the database.
  Future<bool> updateTimeEntry(TimeEntryModel entry) async =>
      _timeEntryFormRepository.updateTimeEntry(entry);

  /// Will add a new TimeEntry to the database.
  Future<bool> addTimeEntry(TimeEntryModel newEntry) async {
    final existingEntries = await _timeEntryFormRepository
        .getTimeEntriesByProjectId(newEntry.projectId);
    if (_checkSameDateEntries(newEntry, existingEntries)) {
      throw const CustomAppException.timeRangesOverlap();
    }

    return _timeEntryFormRepository.addTimeEntry(newEntry);
  }

  bool _checkSameDateEntries(
    TimeEntryModel newEntry,
    List<TimeEntryModel> currentEntries,
  ) {
    final entriesSameDate = currentEntries.where((element) {
      final elementDate = DateFormat('yyyy-MM-dd').format(element.startTime);
      final entryDate = DateFormat('yyyy-MM-dd').format(newEntry.startTime);
      if (elementDate == entryDate) {
        return true;
      }
      return false;
    });
    var dateRangesOverlap = false;

    for (final element in entriesSameDate) {
      dateRangesOverlap = newEntry.checkEntriesIntersect(element);
      if (dateRangesOverlap) {
        break;
      }
    }
    return dateRangesOverlap;
  }
}

/// Provides a [TimeEntryFormService] instance.
final timeEntryFormServiceProvider = Provider<TimeEntryFormService>((ref) {
  return TimeEntryFormService(ref.read(timeEntryFormRepositoryProvider));
});
