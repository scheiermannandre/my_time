import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:realm/realm.dart';

/// RealmDb implementation of the [TimeEntriesRepository].
class RealmDbTimeEntriesRepository implements TimeEntriesRepository {
  /// Constructor for the [RealmDbTimeEntriesRepository].
  RealmDbTimeEntriesRepository(this.realm);

  /// The realm instance.
  final Realm realm;

  @override
  Future<bool> saveTimeEntry(TimeEntryModel entry) async {
    final projects =
        realm.all<ProjectRealmModel>().query("id == '${entry.projectId}'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final project = projects.first;
    return _addTimeEntry(project, entry);
  }

  Future<bool> _addTimeEntry(
    ProjectRealmModel project,
    TimeEntryModel entry,
  ) async {
    if (_checkSameDateEntries(entry, project.timeEntries)) {
      throw const app_exception.CustomAppException.timeRangesOverlap();
    }
    await realm.writeAsync(() {
      final newEntryDB = TimeEntryRealmModel(
        entry.id,
        entry.projectId,
        '',
        entry.startTime,
        entry.endTime,
        entry.totalTime.toString(),
        entry.breakTime.toString(),
        description: entry.description,
      );
      project.timeEntries.add(newEntryDB);
    });
    return true;
  }

  bool _checkSameDateEntries(
    TimeEntryModel newEntry,
    List<TimeEntryRealmModel> currentEntries,
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
      final entryDB = _convertEntryFromDB(element);
      dateRangesOverlap = newEntry.checkEntriesIntersect(entryDB);
      if (dateRangesOverlap) {
        break;
      }
    }
    return dateRangesOverlap;
  }

  TimeEntryModel _convertEntryFromDB(TimeEntryRealmModel entryDB) {
    return TimeEntryModel.factory(
      id: entryDB.id,
      projectId: entryDB.projectId,
      startTime: entryDB.startTime.toLocal(),
      endTime: entryDB.endTime.toLocal(),
      totalTime: DurationExtension.parseDuration(entryDB.totalTimeStr),
      breakTime: DurationExtension.parseDuration(entryDB.breakTimeStr),
      description: entryDB.description,
    );
  }
}

/// Provides the [RealmDbTimeEntriesRepository].
final timeEntriesRepositoryProvider =
    Provider<RealmDbTimeEntriesRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbTimeEntriesRepository(realm);
});
