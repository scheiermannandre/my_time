// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/layers/application/projects_per_group_screen_service.dart';
import 'package:my_time/layers/interface/dto/group_with_projects_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/router/app_route.dart';

class ProjectsPerGroupScreenState {
  ProjectsPerGroupScreenState({
    this.showElevation = false,
    this.value = const AsyncValue.data(null),
  });
  final bool showElevation;
  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  ProjectsPerGroupScreenState copyWith({
    bool? showElevation,
    AsyncValue<void>? value,
  }) {
    return ProjectsPerGroupScreenState(
      showElevation: showElevation ?? this.showElevation,
      value: value ?? this.value,
    );
  }
}

class ProjectsPerGroupScreenController
    extends StateNotifier<ProjectsPerGroupScreenState> {
  ProjectsPerGroupScreenController({required this.service})
      : super(ProjectsPerGroupScreenState());
  final ProjectsPerGroupScreenService service;

  void pushNamedAddProject(BuildContext context, GroupWithProjectsDTO dto) {
    return context
        .pushNamed(AppRoute.addProject, queryParams: {'gid': dto.group.id});
  }

  void pushNamedProject(
      BuildContext context, List<ProjectDTO> projects, int index) {
    return context
        .pushNamed(AppRoute.project, params: {'pid': projects[index].name});
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    GroupWithProjectsDTO dto,
  ) async {
    {
      bool? deletePressed = await openBottomSheet(
          context: context,
          bottomSheetController: controller,
          title: "Delete Group ${dto.group.name}?",
          message: "All Projects and Entries for the whole Group will be lost!",
          confirmBtnText: "Confirm",
          onCanceled: () {
            Navigator.of(context).pop(false);
          },
          onConfirmed: () {
            Navigator.of(context).pop(true);
          });

      if (deletePressed ?? false) {
        _delete(context, dto);
      }
    }
  }

  Future<void> _delete(BuildContext context, GroupWithProjectsDTO dto) async {
    state = state.copyWith(value: const AsyncLoading());
    if (await service.deleteGroup(dto)) {
      pop(context);
    }
  }

  void changeElevation(ScrollController controller) {
    if (controller.offset > 0) {
      state.copyWith(showElevation: true);
    } else {
      state.copyWith(showElevation: false);
    }
  }
}

final groupsListScreenControllerProvider = StateNotifierProvider.autoDispose<
    ProjectsPerGroupScreenController, ProjectsPerGroupScreenState>((ref) {
  final service = ref.watch(projectsPerGroupScreenServiceProvider);
  return ProjectsPerGroupScreenController(service: service);
});

final dataProvider = StreamProvider.autoDispose
    .family<GroupWithProjectsDTO, String>((ref, groupId) {
  final service = ref.watch(projectsPerGroupScreenServiceProvider);
  return service.watchData(groupId);
});
