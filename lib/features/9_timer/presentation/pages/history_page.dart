import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/modals/mighty_snack_bar.dart';
import 'package:my_time/core/modals/modal_bottom_sheet_ui.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/presentation/state_management/history_page_controller.dart';
import 'package:my_time/router/app_route.dart';

/// EntryHistoryPage
class EntryHistoryPage extends StatefulHookConsumerWidget {
  /// Constructor for EntryHistoryPage
  const EntryHistoryPage({
    required String groupId,
    required String projectId,
    required String projectName,
    super.key,
  })  : _groupId = groupId,
        _pojectId = projectId,
        _projectName = projectName;

  final String _groupId;
  final String _pojectId;
  final String _projectName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EntryHistoryPageState();
}

class _EntryHistoryPageState extends ConsumerState<EntryHistoryPage> {
  Map<String, List<EntryEntity>> _entries = {};
  VoidCallback onDismissedCallback = () {};
  void showSnackbar(EntryEditStatus status) {
    if (status == EntryEditStatus.none) return;
    SnackBarPopUp.show(
      context,
      status == EntryEditStatus.updated
          ? context.loc.entryUpdateSuccessSnackbarMessage
          : context.loc.entryDeleteSuccessSnackbarMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyPage = ref.watchAndListenStateProviderError(
      context,
      historyPageControllerProvider(widget._groupId, widget._pojectId),
      historyPageControllerProvider(widget._groupId, widget._pojectId).notifier,
    );

    final stateAsyncValue = historyPage.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._projectName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
        child: stateAsyncValue.when(
          skipLoadingOnReload: true,
          data: (state) {
            setState(() {
              _entries = state.sortedEntries;
            });
            return PaginatedListView(
              hasReachedEnd: state.hasReachedEnd,
              isLoading: stateAsyncValue.isLoading,
              hasError: stateAsyncValue.hasError,
              fetchData: historyPage.controller.fetchNextEntries,
              children: [
                Column(
                  children: [
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return SpacedColumn(
                          spacing: SpaceTokens.verySmall,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _entries.keys.elementAt(index),
                              style: TextStyleTokens.getHeadline4(null),
                            ),
                            Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  SpaceTokens.small,
                                ),
                                child: ListView.separated(
                                  itemBuilder: (context, innerIndex) {
                                    final entry = _entries.values
                                        .elementAt(index)
                                        .elementAt(innerIndex);
                                    return Dismissible(
                                      key: Key(entry.asString()),
                                      background: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: SpaceTokens.medium,
                                        ),
                                        alignment: Alignment.centerRight,
                                        color: ThemelessColorTokens.red,
                                        child: const Icon(
                                          Icons.delete,
                                          color: ThemelessColorTokens.white,
                                        ).animate().shake(
                                              delay: const Duration(
                                                milliseconds: 100,
                                              ),
                                              rotation: .5,
                                              offset: const Offset(1.5, 1.5),
                                            ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      dismissThresholds: const {
                                        DismissDirection.startToEnd: 0.5,
                                        DismissDirection.endToStart: 0.5,
                                      },
                                      crossAxisEndOffset: .5,
                                      onDismissed: (direction) async {
                                        setState(() {
                                          _entries.values
                                              .elementAt(index)
                                              .removeAt(innerIndex);
                                        });
                                        showSnackbar(EntryEditStatus.deleted);

                                        onDismissedCallback();
                                      },
                                      confirmDismiss: (direction) async {
                                        final confirmed =
                                            await ModalBottomSheetUI
                                                .showConfirmationSheet(
                                          context: context,
                                          title: context.loc.deleteEntryTitle,
                                          message:
                                              context.loc.deleteEntryMessage,
                                        );
                                        if ((confirmed ?? false) == false) {
                                          return false;
                                        }
                                        final result = await historyPage
                                            .controller
                                            .tryDeleteEntry(
                                          entry.id,
                                        );
                                        onDismissedCallback =
                                            result.onDismissedCallback;
                                        return result.success;
                                      },
                                      child: EntryListTile.withEntryEntity(
                                        context: context,
                                        entry: entry,
                                        onTap: () {
                                          final entryId = entry.id;
                                          historyPage.controller.observeEntry(
                                            entryId,
                                            showSnackbar,
                                          );
                                          context.goNamed(
                                            AppRoute.entry,
                                            queryParameters: {
                                              'groupId': widget._groupId,
                                              'projectId': widget._pojectId,
                                              'projectName':
                                                  widget._projectName,
                                              'entryId': entryId,
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount:
                                      _entries.values.elementAt(index).length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: SpaceTokens.medium),
                      itemCount: _entries.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        ),
      ),
    );
  }
}

/// A list tile for an entry.
class EntryListTile extends StatelessWidget {
  /// Creates an EntryListTile.
  const EntryListTile({
    required this.title,
    required this.onTap,
    required this.entryType,
    super.key,
  });

  /// Creates an EntryListTile from an EntryEntity.
  factory EntryListTile.withEntryEntity({
    required BuildContext context,
    required EntryEntity entry,
    required VoidCallback onTap,
  }) {
    if (entry is WorkEntryEntity) {
      return EntryListTile._fromWorkEntryEntity(
        context: context,
        entry: entry,
        onTap: onTap,
      );
    } else //if(entry is DayOffEntryEntity)
    {
      return EntryListTile._fromDayOffEntryEntity(
        context: context,
        entry: entry as DayOffEntryEntity,
        onTap: onTap,
      );
    }
  }

  factory EntryListTile._fromDayOffEntryEntity({
    required BuildContext context,
    required DayOffEntryEntity entry,
    required VoidCallback onTap,
  }) {
    return EntryListTile(
      entryType: entry.type,
      onTap: onTap,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.date.toFormattedWeekDayString(),
            style: TextStyleTokens.body(null),
          ),
          Text(
            entry.type.displayName(context),
            style: TextStyleTokens.bodyMedium(null),
          ),
        ],
      ),
    );
  }

  factory EntryListTile._fromWorkEntryEntity({
    // ignore: avoid_unused_constructor_parameters
    required BuildContext context,
    required WorkEntryEntity entry,
    required VoidCallback onTap,
  }) {
    return EntryListTile(
      entryType: entry.type,
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.date.toFormattedWeekDayString(),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
              Row(
                children: [
                  Text(
                    entry.startTime.toFormattedString(),
                    style: TextStyleTokens.bodyMedium(null),
                  ),
                  Text(
                    ' - ',
                    style: TextStyleTokens.bodyMedium(null),
                  ),
                  Text(
                    entry.endTime.toFormattedString(),
                    style: TextStyleTokens.bodyMedium(null),
                  ),
                ],
              ),
            ],
          ),
          Text(
            entry.totalTime.toFormattedString(),
            style: TextStyleTokens.bodyMedium(null),
          ),
        ],
      ),
    );
  }

  /// The child widget to display
  final Widget title;

  /// The function to call when the tile is tapped.
  final VoidCallback onTap;

  /// The entry type.
  final EntryType entryType;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (entryType) {
      case EntryType.work:
        icon = Icons.work_outline;
      case EntryType.vacation:
        icon = Icons.beach_access_outlined;
      case EntryType.sick:
        icon = Icons.sick_outlined;
      case EntryType.publicHoliday:
        icon = Icons.account_balance_outlined;
    }

    final iconColor = ThemeColorBuilder(context).getGuidingIconColor();
    return ListTile(
      leading: Icon(icon, color: iconColor),
      onTap: onTap,
      title: title,
    );
  }
}

/// Listview that implements pagination
class PaginatedListView extends ConsumerStatefulWidget {
  /// Constructor
  const PaginatedListView({
    required this.fetchData,
    required this.children,
    required this.hasReachedEnd,
    required this.isLoading,
    required this.hasError,
    super.key,
  });

  /// Method that fetches the
  final Future<void> Function() fetchData;

  /// The children to display
  final List<Widget> children;

  /// Whether the stream is done
  final bool hasReachedEnd;

  /// Whether the data fetch is in progress
  final bool isLoading;

  /// Whether fetching new data finished with an error
  final bool hasError;

  @override
  ConsumerState<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends ConsumerState<PaginatedListView> {
  late final ScrollController controller;
  int cachedCurrentListLength = 0;
  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _scrollListener() async {
    final nextPageTrigger = 0.8 * controller.position.maxScrollExtent;

    // _scrollController fetches the next paginated data when the
    // current postion of the user on the screen has surpassed
    if (controller.position.pixels > nextPageTrigger &&
        !widget.isLoading &&
        !widget.hasReachedEnd) {
      await widget.fetchData.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: [
        ...widget.children,
        if (widget.isLoading)
          const Padding(
            padding: EdgeInsets.only(
              top: SpaceTokens.medium,
              bottom: SpaceTokens.veryLarge,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (widget.hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: SpaceTokens.medium,
              bottom: SpaceTokens.veryLarge,
            ),
            child: Text(
              context.loc.paginationError,
              textAlign: TextAlign.center,
            ),
          ),
        if (widget.hasReachedEnd)
          Padding(
            padding: const EdgeInsets.only(
              top: SpaceTokens.medium,
              bottom: SpaceTokens.veryLarge,
            ),
            child: Text(
              context.loc.paginationDataEnd,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
