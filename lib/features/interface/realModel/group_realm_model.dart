import 'package:my_time/features/interface/realModel/project_realm_model.dart';
import 'package:realm/realm.dart';

part 'group_realm_model.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class _Group {
  @PrimaryKey()
  late String id;
  String name = "";
  List<$Project> projects = [];
}

@RealmModel() // define a data model class named `_Car`.
class _GroupRealmModel {
  @PrimaryKey()
  late String id;
  String name = "";
  List<$ProjectRealmModel> projects = [];
}
