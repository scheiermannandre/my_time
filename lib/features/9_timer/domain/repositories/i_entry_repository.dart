import 'package:my_time/domain/entry_domain/data_sources/firestore_entry_data_source.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';

/// Repository for the EntryEntity.
abstract class IEntryRepository {
  /// Creates a new Entry.
  Future<void> createEntry(NewWorkEntryModel entry);

  /// Creates new DayOffEntry.
  Future<void> createDayOffEntries(
    String groupId,
    String projectId,
    List<NewDayOffEntryModel> entries,
  );

  /// Updates an existing EntryEntity.
  Future<void> updateEntry(NewEntryModel entry);

  /// Deletes an existing EntryEntity.
  Future<void> deleteEntry(String groupId, String entryId);

  /// Fetches all entries for a given project.
  Future<PaginatedResult<NewEntryModel>> fetchEntries(
    String groupId,
    String projectId,
    int limit, {
    Object? lastSnapshot,
  });

  /// Fetches a single entry.
  Future<NewEntryModel> fetchEntry(
    String groupId,
    String entryId,
  );

  /// Streams a single entry.
  Stream<NewEntryModel?> streamEntry(
    String groupId,
    String entryId,
  );
}
