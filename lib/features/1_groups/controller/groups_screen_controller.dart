import 'package:my_time/common/common.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/router/app_route.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_screen_controller.g.dart';

class GroupsScreenState {
  GroupsScreenState({this.isPlaying = false});
  final bool isPlaying;
  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  String toString() => 'GroupsListState(isPlaying: $isPlaying)';

  @override
  bool operator ==(covariant GroupsScreenState other) {
    if (identical(this, other)) return true;

    return other.isPlaying == isPlaying;
  }

  @override
  int get hashCode => isPlaying.hashCode;

  GroupsScreenState copyWith({
    bool? isPlaying,
  }) {
    return GroupsScreenState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

@riverpod
class GroupsScreenController extends _$GroupsScreenController {
  @override
  FutureOr<GroupsScreenState> build() {
    return GroupsScreenState();
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
          title: Text(
            context.loc.privacy,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => PolicyDialog(
                mdFileName: "privacy_policy.md",
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            context.loc.terms,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => PolicyDialog(
                mdFileName: "terms_of_use.md",
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            context.loc.thirdParty,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: "My Time",
              applicationVersion: "1.0.0",
            );
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

  void pushNamedGroups(BuildContext context, GroupsScreenModel dto, int index) {
    context.pushNamed(AppRoute.group,
        pathParameters: {'gid': dto.groups[index].id});
  }

  void onProjectTileTap(
      BuildContext context, List<ProjectModel> projects, int index) {
    context.pushNamed(AppRoute.project, pathParameters: {
      'pid': projects[index].id,
    });
    state.value!.expansionTile.currentState!.collapse();
  }
}

final groupsDataProvider = StreamProvider.autoDispose<GroupsScreenModel>((ref) {
  final groupsService = ref.watch(deviceStorageGroupsRepositoryProvider);
  return groupsService.streamGroups();
});
