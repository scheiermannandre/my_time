import 'package:my_time/features/9_timer/data/datasources/firestore_entry_data_source.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';

/// Repository for the EntryEntity.
abstract class IEntryRepository {
  /// Creates a new Entry.
  Future<void> createEntry(WorkEntryEntity entry);

  /// Creates new DayOffEntry.
  Future<void> createDayOffEntries(
    String groupId,
    String projectId,
    List<DayOffEntryEntity> entries,
  );

  /// Updates an existing EntryEntity.
  Future<void> updateEntry(EntryEntity entry);

  /// Deletes an existing EntryEntity.
  Future<void> deleteEntry(String groupId, String entryId);

  /// Fetches all entries for a given project.
  Future<PaginatedResult<EntryEntity>> fetchEntries(
    String groupId,
    String projectId,
    int limit, {
    Object? lastSnapshot,
  });

  /// Fetches a single entry.
  Future<EntryEntity> fetchEntry(
    String groupId,
    String entryId,
  );

  /// Streams a single entry.
  Stream<EntryEntity?> streamEntry(
    String groupId,
    String entryId,
  );
}
