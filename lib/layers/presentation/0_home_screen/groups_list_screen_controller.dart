import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/bottom_sheet_dialog.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/layers/application/home_page_service.dart';
import 'package:my_time/layers/domain/home_page_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_list_screen_controller.g.dart';

class GroupsListState {
  GroupsListState({this.isPlaying = false});
  final bool isPlaying;
  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  String toString() => 'GroupsListState(isPlaying: $isPlaying)';

  @override
  bool operator ==(covariant GroupsListState other) {
    if (identical(this, other)) return true;

    return other.isPlaying == isPlaying;
  }

  @override
  int get hashCode => isPlaying.hashCode;

  GroupsListState copyWith({
    bool? isPlaying,
  }) {
    return GroupsListState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

@riverpod
class GroupsListScreenController extends _$GroupsListScreenController {
  @override
  FutureOr<GroupsListState> build() {
    return GroupsListState();
  }

  void animateHamburger() {
    state =
        AsyncData(state.value!.copyWith(isPlaying: !state.value!.isPlaying));
  }

  void onHamburgerTab(BuildContext context, AnimationController controller) {
    animateHamburger();
    showBottomSheetWithWidgets(
      context: context,
      bottomSheetController: controller,
      widgets: [
        ListTile(
          trailing: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            GoRouter.of(context).go("/settings");
          },
        ),
      ],
      whenComplete: () => animateHamburger(),
    );
  }

  void pushNamedAddGroup(BuildContext context) =>
      context.pushNamed(AppRoute.addGroup);

  void pushNamedAddProject(BuildContext context) =>
      context.pushNamed(AppRoute.addProject);

  void pushNamedGroups(BuildContext context, HomePageDTO dto, int index) {
    return context
        .pushNamed(AppRoute.group, params: {'gid': dto.groups[index].id});
  }

  void onProjectTileTap(
      BuildContext context, List<ProjectDTO> projects, int index) {
    context.pushNamed(AppRoute.project, params: {
      'pid': projects[index].name,
    });
    state.value!.expansionTile.currentState!.collapse();
  }
}



// final groupsListScreenControllerProvider = StateNotifierProvider.autoDispose<
//     GroupsListScreenController, GroupsListState>((ref) {
//   final service = ref.watch(homePageServiceProvider);
//   return GroupsListScreenController(homePageService: service);
// });

final homePageDataProvider = StreamProvider.autoDispose<HomePageDTO>((ref) {
  final homePageService = ref.watch(homePageServiceProvider);
  return homePageService.watchData();
});
