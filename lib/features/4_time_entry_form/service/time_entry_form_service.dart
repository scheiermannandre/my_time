import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TimeEntryFormService {
  final TimeEntryFormRepository _timeEntryFormRepository;
  TimeEntryFormService(this._timeEntryFormRepository);
  Future<TimeEntryModel> getEntryById(String id) async =>
      await _timeEntryFormRepository.getEntryById(id);

  Future<bool> deleteEntry(TimeEntryModel entry) async =>
      await _timeEntryFormRepository.deleteEntry(entry);
  Future<bool> updateTimeEntry(TimeEntryModel entry) async =>
      await _timeEntryFormRepository.updateTimeEntry(entry);

  Future<bool> addTimeEntry(TimeEntryModel newEntry) async {
    final existingEntries = await _timeEntryFormRepository
        .getTimeEntriesByProjectId(newEntry.projectId);
    if (_checkSameDateEntries(newEntry, existingEntries)) {
      throw const CustomAppException.timeRangesOverlap();
    }

    return await _timeEntryFormRepository.addTimeEntry(newEntry);
  }

  bool _checkSameDateEntries(
      TimeEntryModel newEntry, List<TimeEntryModel> currentEntries) {
    final entriesSameDate = currentEntries.where((element) {
      final elementDate = DateFormat('yyyy-MM-dd').format(element.startTime);
      final entryDate = DateFormat('yyyy-MM-dd').format(newEntry.startTime);
      if (elementDate == entryDate) {
        return true;
      }
      return false;
    });
    bool dateRangesOverlap = false;

    for (var element in entriesSameDate) {
      dateRangesOverlap = newEntry.checkEntriesIntersect(element);
      if (dateRangesOverlap) {
        break;
      }
    }
    return dateRangesOverlap;
  }
}

final timeEntryFormServiceProvider = Provider<TimeEntryFormService>((ref) {
  return TimeEntryFormService(ref.read(timeEntryFormRepositoryProvider));
});
