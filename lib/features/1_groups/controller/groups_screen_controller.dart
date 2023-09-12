import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_screen_controller.g.dart';

/// State of the GroupsScreen.
class GroupsScreenState {
  /// Creates a [GroupsScreenState].
  GroupsScreenState({this.isPlaying = false});

  /// Returns true if the hamurger animation is ongoing.
  final bool isPlaying;

  /// The key of the [CustomExpansionTile].
  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();

  /// The key of the [RefreshIndicator].
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  /// Copy Method, so that the [GroupsScreenState] can be updated and still be
  /// immutable.
  GroupsScreenState copyWith({
    bool? isPlaying,
  }) {
    return GroupsScreenState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// Controller for the GroupsScreen.
@riverpod
class GroupsScreenController extends _$GroupsScreenController {
  /// Key to find the terms of use ListTile in a Test
  static const termsOfUseKey = Key('termsOfUse');

  /// Key to find the privacyolicy ListTile in a Test
  static const privacyPolicyKey = Key('privacyPolicy');

  /// Key to find the third party licenses ListTile in a Test
  static const thirdPartyLicenseKey = Key('thirdPartyLicense');
  @override
  FutureOr<GroupsScreenState> build() {
    return GroupsScreenState();
  }

  void _animateHamburger() {
    state =
        AsyncData(state.value!.copyWith(isPlaying: !state.value!.isPlaying));
  }

  /// Handles the tap on the hamburger icon.
  void onHamburgerTab(BuildContext context, AnimationController controller) {
    _animateHamburger();
    showBottomSheetWithWidgets(
      context: context,
      bottomSheetController: controller,
      widgets: [
        ListTile(
          key: privacyPolicyKey,
          title: Text(
            context.loc.privacy,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => PolicyDialog(
                mdFileName: 'privacy_policy.md',
              ),
            );
          },
        ),
        ListTile(
          key: termsOfUseKey,
          title: Text(
            context.loc.terms,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => PolicyDialog(
                mdFileName: 'terms_of_use.md',
              ),
            );
          },
        ),
        ListTile(
          key: thirdPartyLicenseKey,
          title: Text(
            context.loc.thirdParty,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'My Time',
              applicationVersion: '1.0.0',
            );
          },
        ),
      ],
      whenComplete: _animateHamburger,
    );
  }

  /// Handles the tap on the add group button.
  void pushNamedAddGroup(BuildContext context) =>
      context.pushNamed(AppRoute.addGroup);

  /// Handles the tap on the add project button.
  void pushNamedAddProject(BuildContext context) =>
      context.pushNamed(AppRoute.addProject);

  /// Handles the tap on the Group Tile.
  void pushNamedGroup(BuildContext context, GroupsScreenModel dto, int index) {
    context.pushNamed(
      AppRoute.group,
      pathParameters: {'gid': dto.groups[index].id},
    );
  }

  /// Handles the tap on the Project Tile.
  void onProjectTileTap(
    BuildContext context,
    List<ProjectModel> projects,
    int index,
  ) {
    context.pushNamed(
      AppRoute.project,
      pathParameters: {
        'pid': projects[index].id,
      },
    );
    state.value!.expansionTile.currentState!.collapse();
  }
}

/// Provider for the GroupsScreen, that streams the [GroupsScreenModel].
final groupsDataProvider = StreamProvider.autoDispose<GroupsScreenModel>((ref) {
  final groupsService = ref.watch(groupsScreenServiceProvider);
  return groupsService.streamGroupsScreenModel();
});
