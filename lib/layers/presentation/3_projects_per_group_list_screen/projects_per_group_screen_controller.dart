// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_result
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/layers/application/projects_per_group_screen_service.dart';
import 'package:my_time/layers/application/projects_screen_service.dart';
import 'package:my_time/layers/interface/dto/group_with_projects_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'projects_per_group_screen_controller.g.dart';

class ProjectsPerGroupScreenState {
  ProjectsPerGroupScreenState();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
}

@riverpod
class ProjectsPerGroupScreenController
    extends _$ProjectsPerGroupScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<ProjectsPerGroupScreenState> build() {
    ref.onDispose(() => current = Object());
    // nothing to do
    return ProjectsPerGroupScreenState();
  }

  void pushNamedAddProject(BuildContext context, GroupWithProjectsDTO dto) {
    context
        .pushNamed(AppRoute.addProject, queryParams: {'gid': dto.group.id});
  }

  void pushNamedProject(
      BuildContext context, List<ProjectDTO> projects, int index) {
    context
        .pushNamed(AppRoute.project, params: {'pid': projects[index].id});
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
      bool? deletePressed = false;
      listener(status) {
        if (status == AnimationStatus.dismissed) {
          _delete(context, dto, deletePressed);
        }
      }

      controller.removeStatusListener(listener);
      controller.addStatusListener(listener);
      deletePressed = await openBottomSheet(
        context: context,
        bottomSheetController: controller,
        title: context.loc.deleteGroupTitle(dto.group.name),
        message: context.loc.deleteGroupMessage,
        confirmBtnText: context.loc.deleteGroupConfirmBtnLabel,
        cancelBtnText: context.loc.deleteGroupCancelBtnLabel,
        onCanceled: () {
          Navigator.of(context).pop(false);
        },
        onConfirmed: () async {
          final result = await ref
              .read(projectsPerGroupScreenServiceProvider)
              .deleteGroup(dto);
          return result;
        },
        whenCompleted: (result, mounted) async {
          if (result) {
            ref.invalidate(homePageDataProvider);
          }
          if (result && !mounted) {
            ref.invalidate(groupWithProjectsDTOProvider(dto.group.id));
          }
          deleteAllTimers(dto.projects);
        },
      );
    }
  }

  Future<bool> deleteAllTimers(List<ProjectDTO> projects) async {
    for (var element in projects) {
      //ref.read(projectsScreenServiceProvider).deleteTimer(element.id);
    }
    return true;
  }

  Future<void> _delete(BuildContext context, GroupWithProjectsDTO dto,
      bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        pop(context);
      }
    }
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}

final groupWithProjectsDTOProvider = StreamProvider.autoDispose
    .family<GroupWithProjectsDTO, String>((ref, groupId) {
  final service = ref.watch(projectsPerGroupScreenServiceProvider);
  return service.watchData(groupId);
});
