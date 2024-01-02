import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/domain/entry_domain/data_sources/firestore_entry_data_source.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/9_timer/data/models/entry_model.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_entry_repository.g.dart';

/// Entry repository which enables the communication between the
/// data and domain layer for entries.
class AnalyticsEntryRepository {
  /// Constructor for the EntryRepository.
  AnalyticsEntryRepository({required this.ref});

  /// Reference to the Ref object to work with Riverpod.
  final Ref ref;

  Future<List<NewEntryModel>> fetchEntriesByDateRange(
    String groupId,
    DateTime lowerboundary,
    DateTime upperboundary,
  ) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(entryFirestoreDataSourceProvider)
        .fetchEntriesByDateRange(
          uid,
          groupId,
          lowerboundary,
          upperboundary,
        )
        .then((value) => value.map(NewEntryModelFactory.fromMap).toList());
  }

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
}

@riverpod

/// A provider for the [AnalyticsEntryRepository].
AnalyticsEntryRepository analyticsEntryRepository(
  AnalyticsEntryRepositoryRef ref,
) {
  return AnalyticsEntryRepository(ref: ref);
}

@riverpod

/// A provider to fetch the [EntryEntity].
Future<List<NewEntryModel>> fetchEntryEntitiesByDateRange(
  FetchEntryEntitiesByDateRangeRef ref,
  String groupId,
  DateTime lowerboundary,
  DateTime upperboundary,
) {
  return ref
      .read(analyticsEntryRepositoryProvider)
      .fetchEntriesByDateRange(groupId, lowerboundary, upperboundary);
}

@riverpod

/// A provider to fetch the [EntryEntity].
FutureOr<NewEntryModel> fetchAnalyticsEntry(
  FetchAnalyticsEntryRef ref,
  String groupId,
  String entryId,
) {
  return ref
      .watch(analyticsEntryRepositoryProvider)
      .fetchEntry(groupId, entryId);
}
