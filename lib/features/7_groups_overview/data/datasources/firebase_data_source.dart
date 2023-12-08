import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_data_source.g.dart';

/// An class representing a Firebase data source for managing
class FirestoreGroupsDataSource {
  /// Constructs a [FirestoreGroupsDataSource] with the specified [firestore].
  FirestoreGroupsDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  static String _groupPath(String uid, String groupId) =>
      'users/$uid/groups/$groupId';

  static String _usersGroupsPath(String uid) => 'users/$uid/groups';

  CollectionReference<Map<String, dynamic>> _groupsCollection(
    String uid,
  ) =>
      _firestore.collection(_usersGroupsPath(uid));

  DocumentReference<Map<String, dynamic>> _groupDocument(
    String uid,
    String groupId,
  ) =>
      _firestore.doc(_groupPath(uid, groupId));

  Query<GroupModel> _groupsQuery(String uid) {
    final usersGroupsCollection = _groupsCollection(uid)
        .withConverter(
          fromFirestore: (doc, _) => GroupModel.fromMap(doc.data()!),
          toFirestore: (GroupModel group, options) => group.toMap(),
        )
        .orderBy('createdAt', descending: false);

    return usersGroupsCollection;
  }

  List<GroupModel> _querySnapshotToGroups(QuerySnapshot<GroupModel> snapshot) {
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  /// Creates a new group with the specified [group].
  Future<void> createGroup(String uid, GroupModel group) async {
    await _groupsCollection(uid).doc(group.id).set(group.toMap());
  }

  /// Deletes a group with the specified [groupId].
  Future<void> deleteGroup(String uid, String groupId) async {
    await _groupDocument(uid, groupId).delete();
  }

  /// Stream to listen for changes to the list of groups.
  Stream<List<GroupModel>> watchGroups(String uid) {
    return _groupsQuery(uid).snapshots().map(_querySnapshotToGroups);
  }

  /// Fetches the list of groups.
  Future<List<GroupModel>> fetchGroups(String uid) {
    return _groupsQuery(uid).get().then(_querySnapshotToGroups);
  }
}

/// Riverpod provider for creating an instance of [FirestoreGroupsDataSource].
@riverpod
FirestoreGroupsDataSource groupFirestoreDataSource(
  GroupFirestoreDataSourceRef ref,
) {
  return FirestoreGroupsDataSource(FirebaseFirestore.instance);
}
