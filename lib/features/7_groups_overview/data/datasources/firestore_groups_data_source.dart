import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firebase_firestore_extension.dart';
import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_groups_data_source.g.dart';

/// An class representing a Firebase data source for managing
class FirestoreGroupsDataSource {
  /// Constructs a [FirestoreGroupsDataSource] with the specified [firestore].
  FirestoreGroupsDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  List<GroupModel> _querySnapshotToGroups(QuerySnapshot<GroupModel> snapshot) {
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  /// Creates a new group with the specified [group].
  Future<void> createGroup(String uid, GroupModel group) async {
    await _firestore.groupsCollection(uid).doc(group.id).set(group.toMap());
  }

  /// Deletes a group with the specified [groupId].
  Future<void> deleteGroup(String uid, String groupId) async {
    await _firestore.groupDocument(uid, groupId).delete();
  }

  /// Stream to listen for changes to the list of groups.
  Stream<List<GroupModel>> watchGroups(String uid) {
    return _firestore.groupsQuery(uid).snapshots().map(_querySnapshotToGroups);
  }

  /// Fetches the list of groups.
  Future<List<GroupModel>> fetchGroups(String uid) {
    return _firestore.groupsQuery(uid).get().then(_querySnapshotToGroups);
  }

  /// Fetches the list of groups.
  Future<Map<String, dynamic>> fetchGroup(String uid, String groupId) {
    return _firestore
        .groupDocumentRaw(uid, groupId)
        .get()
        .then((value) => value.data()!);
  }
}

/// Riverpod provider for creating an instance of [FirestoreGroupsDataSource].
@riverpod
FirestoreGroupsDataSource groupFirestoreDataSource(
  GroupFirestoreDataSourceRef ref,
) {
  return FirestoreGroupsDataSource(FirebaseFirestore.instance);
}
