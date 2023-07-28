import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/4_time_entry_form/domain/time_entry.dart';

void main() {
  test(
      'Case 1 - New Entry lies inbetween Existing Entry  -> Intersection -> invalid',
      () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 9, 0);
    final newEntryEnd = DateTime(0, 0, 0, 10, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });

  test(
      'Case 2 - New Entry Start lies inbetween Existing Entry -> Intersection -> invalid',
      () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 9, 0);
    final newEntryEnd = DateTime(0, 0, 0, 14, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });

  test(
      'Case 3 - New Entry Start lies on Existing Entry End -> NO Intersection -> valid',
      () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 12, 0);
    final newEntryEnd = DateTime(0, 0, 0, 14, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, false);
  });

  test('''Case 4 - 
  New Entry Start lies before Existing Entry Start 
  New Entry End lies inbetween Existing Entry
  -> Intersection -> invalid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 6, 0);
    final newEntryEnd = DateTime(0, 0, 0, 9, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });

  test(
      'Case 5 - New Entry End lies on Existing Entry Start -> NO Intersection -> valid',
      () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 12, 0);
    final newEntryEnd = DateTime(0, 0, 0, 14, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, false);
  });

  test('''Case 6 - 
  New Entry Start lies inbetween Existing Entry 
  New Entry End lies on Existing Entry End
  -> Intersection -> invalid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 10, 0);
    final newEntryEnd = DateTime(0, 0, 0, 12, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });
  test('''Case 7 - 
  New Entry Start lies on Existing Entry Start
  New Entry End lies inbetween Existing Entry
  -> Intersection -> invalid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 8, 0);
    final newEntryEnd = DateTime(0, 0, 0, 10, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });

  test('''Case 8 - 
  Existing Entry lies inbetween New Entry
  -> Intersection -> invalid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 7, 0);
    final newEntryEnd = DateTime(0, 0, 0, 13, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });

  test('''Case 9 - 
  New Entry is past Existing Entry
  -> NO Intersection -> valid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 13, 0);
    final newEntryEnd = DateTime(0, 0, 0, 15, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, false);
  });

  test('''Case 10 - 
  New Entry is before Existing Entry
  -> NO Intersection -> valid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 5, 0);
    final newEntryEnd = DateTime(0, 0, 0, 7, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, false);
  });

  test('''Case 11 - 
  New Entry and Existing Entry match 
  -> Intersection -> invalid''', () {
    final existingEntryStart = DateTime(0, 0, 0, 8, 0);
    final existingEntryEnd = DateTime(0, 0, 0, 12, 0);
    final newEntryStart = DateTime(0, 0, 0, 8, 0);
    final newEntryEnd = DateTime(0, 0, 0, 12, 0);
    final existingEntry = TimeEntryModel(
        projectId: "",
        startTime: existingEntryStart,
        endTime: existingEntryEnd,
        totalTime: existingEntryEnd.difference(existingEntryStart),
        breakTime: Duration.zero,
        description: "");

    final newEntry = TimeEntryModel(
        projectId: "",
        startTime: newEntryStart,
        endTime: newEntryEnd,
        totalTime: newEntryEnd.difference(newEntryStart),
        breakTime: Duration.zero,
        description: "");

    bool intersect = newEntry.checkEntriesIntersect(existingEntry);

    expect(intersect, true);
  });
}
