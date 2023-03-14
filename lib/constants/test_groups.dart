import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

/// Test products to be used until a data source is implemented
final kTestGroups = [
  GroupDTO(
    name: "Group 1",
  ),
  // GroupDTO(
  //   name: "Group 2",
  // ),
  // GroupDTO(
  //   name: "Group 3",
  // ),
  // GroupDTO(
  //   name: "Group 1",
  // ),
  // GroupDTO(
  //   name: "Group 2",
  // ),
  // GroupDTO(
  //   name: "Group 3",
  // ),
  // GroupDTO(
  //   name: "Group 1",
  // ),
  // GroupDTO(
  //   name: "Group 2",
  // ),
  // GroupDTO(
  //   name: "Group 3",
  // ),
];

final kTestProjects = [
  ProjectDTO(name: "Project 1", parentId: kTestGroups[0].id),
];
