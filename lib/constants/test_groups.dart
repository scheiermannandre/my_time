import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

final Map<String, GroupDTO> kTestGroupsMap = {};

final Map<String, List<ProjectDTO>> kTestProjectsMap = {
  "favourites": [],
};

final Map<String, List<TimeEntryDTO>> kTestTimeEntriesMap = {};

// Test products to be used until a data source is implemented
final kTestGroups = [
  GroupDTO(
    name: "Group 1",
  ),
  GroupDTO(
    name: "Group 2",
  ),
  GroupDTO(
    name: "Group 3",
  ),
  GroupDTO(
    name: "Group 1",
  ),
  GroupDTO(
    name: "Group 2",
  ),
  GroupDTO(
    name: "Group 3",
  ),
  GroupDTO(
    name: "Group 1",
  ),
  GroupDTO(
    name: "Group 2",
  ),
  GroupDTO(
    name: "Group 3",
  ),
];

final kTestProjects = [
  ProjectDTO(name: "Project 1", groupId: kTestGroups[0].id),
];
