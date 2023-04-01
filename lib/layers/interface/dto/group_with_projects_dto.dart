import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class GroupWithProjectsDTO {
  final GroupDTO group;
  final List<ProjectDTO> projects;

  GroupWithProjectsDTO({required this.group, required this.projects});
}
