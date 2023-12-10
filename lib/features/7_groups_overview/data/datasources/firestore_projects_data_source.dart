import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firebase_firestore_extension.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_projects_data_source.g.dart';

/// An class representing a Firebase data source for managing
class FirestoreProjectsDataSource {
  /// Constructs a [FirestoreProjectsDataSource] with the specified [firestore].
  FirestoreProjectsDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;

  /// Deletes a project with the specified [projectId].
  Future<void> deleteProject(
    String uid,
    String groupId,
    String projectId,
    Map<String, dynamic> project,
  ) async {
    return _firestore.groupsCollection(uid).doc(groupId).update({
      'projects.$projectId': FieldValue.delete(),
    });
  }

  /// Creates a new group with the specified [project].
  Future<void> addProject(
    String uid,
    ProjectModel project,
  ) async {
    return _firestore.groupsCollection(uid).doc(project.groupId).update({
      'projects.${project.id}': project.toMap(),
    });
  }

  /// Fetch a project with the specified [projectId].
  Future<ProjectModel> fetchProject(
    String uid,
    String groupId,
    String projectId,
  ) async {
    return _firestore
        .groupDocument(uid, groupId)
        .get()
        .then((value) => value.data()!)
        .then(
          (group) =>
              group.projects.firstWhere((project) => project.id == projectId),
        );
  }
}

/// Riverpod provider for creating an instance of [FirestoreProjectsDataSource].
@riverpod
FirestoreProjectsDataSource projectsFirestoreDataSource(
  ProjectsFirestoreDataSourceRef ref,
) {
  return FirestoreProjectsDataSource(FirebaseFirestore.instance);
}
