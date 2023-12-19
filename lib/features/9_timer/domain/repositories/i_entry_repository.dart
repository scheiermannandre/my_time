import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';

/// Repository for the EntryEntity.
abstract class IEntryRepository {
  /// Creates a new Entry.
  Future<void> createEntry(RegularEntryEntity entry);

  /// Creates new DayOffEntry.
  Future<void> createDayOffEntries(
    String groupId,
    String projectId,
    List<DayOffEntryEntity> entries,
  );

  /// Updates an existing EntryEntity.
  Future<void> updateEntry(RegularEntryEntity entry);

  /// Deletes an existing EntryEntity.
  Future<void> deleteEntry(RegularEntryEntity entry);
}
