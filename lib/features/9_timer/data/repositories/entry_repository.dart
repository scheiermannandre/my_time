import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/domain/entry_domain/data_sources/firestore_entry_data_source.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
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
  Future<void> createEntry(NewWorkEntryModel entry) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).createEntry(
          uid,
          entry.groupId,
          entry.id,
          entry.toMap(),
        );
  }

  @override
  Future<void> createDayOffEntries(
    String groupId,
    String projectId,
    List<NewDayOffEntryModel> entries,
  ) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).createDayOffEnries(
          uid,
          groupId,
          projectId,
          entries.map((entry) => entry.id).toList(),
          entries.map((entry) => entry.toMap()).toList(),
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
  Future<void> updateEntry(NewEntryModel entry) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(entryFirestoreDataSourceProvider).updateEntry(
          uid,
          entry.groupId,
          entry.id,
          entry.toMap(),
        );
  }

  @override
  Future<PaginatedResult<NewEntryModel>> fetchEntries(
    String groupId,
    String projectId,
    int limit, {
    Object? lastSnapshot,
  }) {
    try {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      return ref
          .read(entryFirestoreDataSourceProvider)
          .fetchEntries<Map<String, dynamic>>(
            uid,
            groupId,
            projectId,
            limit,
            lastSnapshot: lastSnapshot,
          )
          .then(
            (value) => PaginatedResult<NewEntryModel>(
              token: value.token,
              values: value.values.map(NewEntryModelFactory.fromMap).toList(),
            ),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NewEntryModel> fetchEntry(
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
        .then((value) => NewEntryModelFactory.fromMap(value!));
  }

  @override
  Stream<NewEntryModel?> streamEntry(
    String groupId,
    String entryId,
  ) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(entryFirestoreDataSourceProvider)
        .streamEntry(
          uid,
          groupId,
          entryId,
        )
        .map(
          (value) => value != null ? NewEntryModelFactory.fromMap(value) : null,
        );
  }
}

@riverpod

/// A provider for the [EntryRepository].
EntryRepository entryRepository(EntryRepositoryRef ref) {
  return EntryRepository(ref: ref);
}

@riverpod

/// A provider to fetch the [EntryEntity].
Future<PaginatedResult<NewEntryModel>> fetchEntryEntities(
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
FutureOr<NewEntryModel> fetchEntry(
  FetchEntryRef ref,
  String groupId,
  String entryId,
) {
  return ref.watch(entryRepositoryProvider).fetchEntry(groupId, entryId);
}

@riverpod

/// A provider to stream the [EntryEntity].
Stream<NewEntryModel?> streamEntry(
  StreamEntryRef ref,
  String groupId,
  String entryId,
) {
  return ref.watch(entryRepositoryProvider).streamEntry(groupId, entryId);
}
