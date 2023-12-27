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
  Future<void> createEntry(WorkEntryEntity entry) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).createEntry(
          uid,
          entry.groupId,
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
  Future<void> deleteEntry(String groupId, String entryId) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).deleteEntry(
          uid,
          groupId,
          entryId,
        );
  }

  @override
  Future<void> updateEntry(EntryEntity entry) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).updateEntry(
          uid,
          entry.groupId,
          EntryModel.fromEntity(entry),
        );
  }

  @override
  Future<PaginatedResult<EntryEntity>> fetchEntries(
    String groupId,
    String projectId,
    int limit, {
    Object? lastSnapshot,
  }) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(entryFirestoreDataSourceProvider)
        .fetchEntries<EntryModel>(
          uid,
          groupId,
          projectId,
          limit,
          lastSnapshot: lastSnapshot,
        )
        .then(
          (value) => PaginatedResult<EntryEntity>(
            token: value.token,
            values: value.values.map((e) => e.toEntity()).toList(),
          ),
        );
  }

  @override
  Future<EntryEntity> fetchEntry(
    String groupId,
    String entryId,
  ) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(entryFirestoreDataSourceProvider)
        .fetchEntry(
          uid,
          groupId,
          entryId,
        )
        .then((value) => value!.toEntity());
  }

  @override
  Stream<EntryEntity?> streamEntry(
    String groupId,
    String entryId,
  ) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(entryFirestoreDataSourceProvider)
        .streamEntry<EntryModel?>(
          uid,
          groupId,
          entryId,
        )
        .map((value) => value?.toEntity());
  }
}

@riverpod

/// A provider for the [EntryRepository].
EntryRepository entryRepository(EntryRepositoryRef ref) {
  return EntryRepository(ref: ref);
}

@riverpod

/// A provider to fetch the [EntryEntity].
Future<PaginatedResult<EntryEntity>> fetchEntryEntities(
  FetchEntryEntitiesRef ref,
  String groupId,
  String projectId,
  int startAt,
  int limit,
) {
  return ref
      .read(entryRepositoryProvider)
      .fetchEntries(groupId, projectId, startAt);
}

@riverpod

/// A provider to fetch the [EntryEntity].
FutureOr<EntryEntity> fetchEntry(
  FetchEntryRef ref,
  String groupId,
  String entryId,
) {
  return ref.watch(entryRepositoryProvider).fetchEntry(groupId, entryId);
}

@riverpod

/// A provider to stream the [EntryEntity].
Stream<EntryEntity?> streamEntry(
  StreamEntryRef ref,
  String groupId,
  String entryId,
) {
  return ref.watch(entryRepositoryProvider).streamEntry(groupId, entryId);
}
