import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/domain/group_domain/models/group_entity.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firestore_groups_data_source.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_group_repository.g.dart';

class AnalyticsGroupRepository {
  /// Constructor for [AnalyticsGroupRepository].
  AnalyticsGroupRepository({required this.ref});

  /// Reference to Riverpod.
  final Ref ref;

  Future<NewGroupModel> fetchGroup(String groupId) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(groupFirestoreDataSourceProvider)
        .fetchGroup(uid, groupId)
        .then(NewGroupModel.fromMap);
  }
}

@riverpod
AnalyticsGroupRepository analyticsGroupRepository(
    AnalyticsGroupRepositoryRef ref) {
  return AnalyticsGroupRepository(ref: ref);
}
