import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class HomePageDTO {
  final List<GroupDTO> groups;
  final List<ProjectDTO> projects;
  HomePageDTO({this.groups = const [], this.projects = const []});
}
