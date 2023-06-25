import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/bottom_sheet_dialog.dart';
import 'package:my_time/common/dialogs/policy_dialog.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
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

  void pushNamedGroups(BuildContext context, HomePageDTO dto, int index) {
    context.pushNamed(AppRoute.group,
        pathParameters: {'gid': dto.groups[index].id});
  }

  void onProjectTileTap(
      BuildContext context, List<ProjectDTO> projects, int index) {
    context.pushNamed(AppRoute.project, pathParameters: {
      'pid': projects[index].id,
    });
    state.value!.expansionTile.currentState!.collapse();
  }
}

final homePageDataProvider = StreamProvider.autoDispose<HomePageDTO>((ref) {
  final homePageService = ref.watch(homePageServiceProvider);
  return homePageService.watchData();
});
