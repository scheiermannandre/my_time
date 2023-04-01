
import 'package:my_time/layers/interface/dto/project.dart';
import 'package:realm/realm.dart';

part 'group.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class _Group {
  @PrimaryKey()
  late String id;
  String name = "";
  List<$Project> projects =[];
}