import 'package:my_time/features/0_common/realmModel/project_realm_model.dart';
import 'package:realm/realm.dart';

part 'group_realm_model.g.dart';

/// The OLD RealmModel for the Group.
@RealmModel()
class _Group {
  /// The id of the group.
  @PrimaryKey()
  late String id;

  /// The name of the group.
  String name = '';

  /// The list of projects.
  List<$Project> projects = [];
}

/// The NEW RealmModel for the Group.
@RealmModel()
class _GroupRealmModel {
  /// The id of the group.
  @PrimaryKey()
  late String id;

  /// The name of the group.
  String name = '';

  /// The list of projects.
  List<$ProjectRealmModel> projects = [];
}
