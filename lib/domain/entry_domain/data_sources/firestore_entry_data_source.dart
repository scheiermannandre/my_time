import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/data/models/entry_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_entry_data_source.g.dart';

/// A class representing a paginated result. This Contains the List of
/// [values] and the [token] to fetch the next page.
class PaginatedResult<T> {
  /// Constructs a [PaginatedResult].
  const PaginatedResult({
    required this.values,
    required this.token,
  });

  /// The list of values.
  final List<T> values;

  /// The token to fetch the next page.
  final Object? token;
}

/// An class representing a Firebase data source for managing
/// [EntryModel]s.
class FirestoreEntryDataSource {
  /// Constructs a [FirestoreEntryDataSource].
  FirestoreEntryDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;
  static String _entryPath(
    String uid,
    String groupId,
    String entryId,
  ) =>
      'users/$uid/groups/$groupId/entries/$entryId';

  /// Document reference for a group of a user.
  DocumentReference<Map<String, dynamic>?> entriesDocument(
    String uid,
    String groupId,
    String entryId,
  ) =>
      _firestore.doc(_entryPath(uid, groupId, entryId)).withConverter(
            fromFirestore: (doc, _) {
              if (doc.exists) {
                return doc.data();
              }
              return null;
            },
            toFirestore: (entryModel, options) => entryModel!,
          );

  /// Saves the [entry] to the database.
  Future<void> createEntry(
    String uid,
    String groupId,
    String entryId,
    Map<String, dynamic> entry,
  ) {
    return entriesDocument(uid, groupId, entryId).set(entry);
  }

  /// Saves the [entries] to the database.
  Future<void> createDayOffEnries(
    String uid,
    String groupId,
    String projectId,
    List<String> entryIds,
    List<Map<String, dynamic>> entries,
  ) {
    final writeBatch = _firestore.batch();

    for (final entry in entries) {
      final index = entries.indexOf(entry);
      writeBatch.set(entriesDocument(uid, groupId, entryIds[index]), entry);
    }
    return writeBatch.commit();
  }

  /// Fetches the [EntryModel] from the database.
  Future<Map<String, dynamic>?> fetchEntry(
    String uid,
    String groupId,
    String entryId,
  ) {
    return entriesDocument(uid, groupId, entryId)
        .get()
        .then((value) => value.data());
  }

  Query<Map<String, dynamic>> entriesQueryRaw(
    String uid,
    String groupId,
  ) {
    return _firestore.collection('users/$uid/groups/$groupId/entries');
  }

  /// Fetches all [EntryModel]s from the database.
  Future<PaginatedResult<T>> fetchEntries<T>(
    String uid,
    String groupId,
    String projectId,
    int limit, {
    Object? lastSnapshot,
  }) async {
    var query = entriesQueryRaw(uid, groupId)
        .where('projectId', isEqualTo: projectId)
        .orderBy('date', descending: true);
    if (lastSnapshot != null) {
      query =
          query.startAfterDocument(lastSnapshot as DocumentSnapshot<Object?>);
    }
    query = query.limit(limit);
    return query.get().then(
      (value) {
        final entries = value.docs.map((e) => e.data()).toList();

        return PaginatedResult<T>(
          values: entries as List<T>,
          token: value.docs.last,
        );
      },
    );
  }

  /// Streams the [EntryModel] from the database.
  Stream<Map<String, dynamic>?> streamEntry(
    String uid,
    String groupId,
    String entryId,
  ) {
    return entriesDocument(uid, groupId, entryId).snapshots().map(
          (snapshot) => snapshot.data(),
        );
  }

  /// Deletes the [EntryModel] from the database.
  Future<void> deleteEntry(
    String uid,
    String groupId,
    String entryId,
  ) {
    return entriesDocument(uid, groupId, entryId).delete();
  }

  /// Updates the [EntryModel] from the database.
  Future<void> updateEntry(
    String uid,
    String groupId,
    String entryId,
    Map<String, dynamic> entry,
  ) {
    return entriesDocument(uid, groupId, entryId).set(entry);
  }

  //////
  /// Analytics
  /// Fetches all Entry from the database that lie in between the range.
  Future<List<Map<String, dynamic>>> fetchEntriesByDateRange(
    String uid,
    String groupId,
    DateTime lowerBoundary,
    DateTime upperBoundary,
  ) async {
    final lower = DateTime(
      lowerBoundary.year,
      lowerBoundary.month,
      lowerBoundary.day,
    );
    final upper = DateTime(
      upperBoundary.year,
      upperBoundary.month,
      upperBoundary.day,
    );

    final query = entriesQueryRaw(uid, groupId).where(
      'date',
      isGreaterThanOrEqualTo: lower.millisecondsSinceEpoch,
      isLessThanOrEqualTo: upper.millisecondsSinceEpoch,
    );

    final data = await query.get().then(
          (value) => value.docs.map((e) => e.data()).toList(),
        );
    return data;
  }
  //////
}

/// Riverpod provider for creating an instance
/// of [FirestoreEntryDataSource].
@riverpod
FirestoreEntryDataSource entryFirestoreDataSource(
  EntryFirestoreDataSourceRef ref,
) {
  return FirestoreEntryDataSource(FirebaseFirestore.instance);
}
