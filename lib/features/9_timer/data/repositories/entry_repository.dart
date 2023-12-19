import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/9_timer/data/datasources/firestore_entry_data_source.dart';
import 'package:my_time/features/9_timer/data/models/entry_model.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/repositories/i_entry_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entry_repository.g.dart';

/// Entry repository which enables the communication between the
/// data and domain layer for entries.
class EntryRepository implements IEntryRepository {
  /// Constructor for the EntryRepository.
  EntryRepository({required this.ref});

  /// Reference to the Ref object to work with Riverpod.
  final Ref ref;

  @override
  Future<void> createEntry(RegularEntryEntity entry) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).createEntry(
          uid,
          entry.groupId,
          entry.projectId,
          EntryModel.fromEntity(entry),
        );
  }

  @override
  Future<void> createDayOffEntries(
    String groupId,
    String projectId,
    List<DayOffEntryEntity> entries,
  ) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).createDayOffEnries(
          uid,
          groupId,
          projectId,
          entries.map(EntryModel.fromEntity).toList(),
        );
  }

  @override
  Future<void> deleteEntry(RegularEntryEntity entry) {
    // TODO: implement deleteEntry
    throw UnimplementedError();
  }

  @override
  Future<void> updateEntry(RegularEntryEntity entry) {
    // TODO: implement updateEntry
    throw UnimplementedError();
  }
}

@riverpod

/// A provider for the [EntryRepository].
EntryRepository entryRepository(EntryRepositoryRef ref) {
  return EntryRepository(ref: ref);
}
