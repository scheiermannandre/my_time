// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/layers/application/projects_per_group_screen_service.dart';
import 'package:my_time/layers/interface/dto/group_with_projects_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'projects_per_group_screen_controller.g.dart';

class ProjectsPerGroupScreenState {
  ProjectsPerGroupScreenState({
    this.showElevation = false,
  });
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final bool showElevation;

  ProjectsPerGroupScreenState copyWith({
    bool? showElevation,
  }) {
    return ProjectsPerGroupScreenState(
      showElevation: showElevation ?? this.showElevation,
    );
  }
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
    return context
        .pushNamed(AppRoute.addProject, queryParams: {'gid': dto.group.id});
  }

  void pushNamedProject(
      BuildContext context, List<ProjectDTO> projects, int index) {
    return context
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
      bool? deletePressed = await openBottomSheet(
          context: context,
          bottomSheetController: controller,
          title: AppLocalizations.of(context)!.deleteGroupTitle(dto.group.name),
          message: AppLocalizations.of(context)!.deleteGroupMessage,
          confirmBtnText:
              AppLocalizations.of(context)!.deleteGroupConfirmBtnLabel,
          cancelBtnText:
              AppLocalizations.of(context)!.deleteGroupCancelBtnLabel,
          onCanceled: () {
            Navigator.of(context).pop(false);
          },
          onConfirmed: () {
            Navigator.of(context).pop(true);
          });

      if (deletePressed ?? false) {
        if (mounted) {
          _delete(context, dto);
        }
      }
    }
  }

  Future<void> _delete(BuildContext context, GroupWithProjectsDTO dto) async {
    state = const AsyncLoading();
    final result =
        await ref.read(projectsPerGroupScreenServiceProvider).deleteGroup(dto);
    if (result) {
      await ref.refresh(homePageDataProvider.future);
      if (mounted) {
        pop(context);
      }
    }
  }

  void changeElevation(ScrollController controller) {
    if (controller.offset > 0) {
      state = AsyncData(state.value!.copyWith(showElevation: true));
    } else {
      state = AsyncData(state.value!.copyWith(showElevation: false));
    }
  }
}

final groupWithProjectsDTOProvider = StreamProvider.autoDispose
    .family<GroupWithProjectsDTO, String>((ref, groupId) {
  final service = ref.watch(projectsPerGroupScreenServiceProvider);
  return service.watchData(groupId);
});
