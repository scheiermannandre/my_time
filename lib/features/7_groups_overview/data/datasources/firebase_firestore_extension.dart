import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';

/// Extension class for cleaner acces on groups stored in firebase.
extension FirebaseFirestoreExtension on FirebaseFirestore {
  static String _groupPath(String uid, String groupId) =>
      'users/$uid/groups/$groupId';

  static String _usersGroupsPath(String uid) => 'users/$uid/groups';

  /// Collection reference for the groups of a user.
  CollectionReference<Map<String, dynamic>> groupsCollection(
    String uid,
  ) =>
      collection(_usersGroupsPath(uid));

  /// Document reference for a group of a user.
  DocumentReference<GroupModel> groupDocument(
    String uid,
    String groupId,
  ) =>
      groupDocumentRaw(uid, groupId).withConverter(
        fromFirestore: (doc, _) => GroupModel.fromMap(doc.data()!),
        toFirestore: (GroupModel group, options) => group.toMap(),
      );

  DocumentReference<Map<String, dynamic>> groupDocumentRaw(
    String uid,
    String groupId,
  ) =>
      doc(_groupPath(uid, groupId));

  /// Query for a group of a user.
  Query<GroupModel> groupsQuery(String uid) {
    final usersGroupsCollection = groupsCollection(uid)
        .withConverter(
          fromFirestore: (doc, _) => GroupModel.fromMap(doc.data()!),
          toFirestore: (GroupModel group, options) => group.toMap(),
        )
        .orderBy('createdAt', descending: false);

    return usersGroupsCollection;
  }
}
