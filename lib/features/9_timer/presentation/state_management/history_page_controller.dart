import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/domain/entry_domain/data_sources/firestore_entry_data_source.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/data/repositories/entry_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_page_controller.g.dart';

/// Status that indicates whether an entry has been updated or deleted.
enum EntryEditStatus {
  /// Indicates that the entry has not been updated or deleted.
  none,

  /// Indicates that the entry has been updated.
  updated,

  /// Indicates that the entry has been deleted.
  deleted,
}

/// State for the history page containing the data.
class HistoryPageState {
  /// Creates a new instance of the [HistoryPageState] class.
  HistoryPageState({
    required this.entries,
    required this.lastBatchCount,
    required this.lastSnapshot,
  }) {
    _convertToMap(entries);
  }

  /// The number of entries to be fetched per batch.
  static const int limit = 30;

  /// The list of entries.
  final List<NewEntryModel> entries;

  /// The number of entries fetched in the last batch.
  final int lastBatchCount;

  /// The last snapshot of the entries.
  final Object? lastSnapshot;

  /// The entries grouped by month and year.
  final Map<String, List<NewEntryModel>> _sortedEntries = {};

  /// The entries grouped by month and year.
  Map<String, List<NewEntryModel>> get sortedEntries => _sortedEntries;

  /// Indicates whether the end of the list has been reached.
  bool get hasReachedEnd => lastBatchCount < limit;

  void _convertToMap(List<NewEntryModel> entries) {
    for (final entry in entries) {
      final key = entry.date.toMonthAndYearString();
      if (!_sortedEntries.containsKey(key)) {
        _sortedEntries[key] = [];
      }
      _sortedEntries[key]!.add(entry);
    }
  }

  /// Creates a copy of the [HistoryPageState] with the given fields
  /// replaced with the new values.
  HistoryPageState copyWith({
    List<NewEntryModel>? entries,
    int? lastBatchCount,
    Object? lastSnapshot,
  }) {
    return HistoryPageState(
      entries: entries ?? this.entries,
      lastBatchCount: lastBatchCount ?? this.lastBatchCount,
      lastSnapshot: lastSnapshot ?? lastSnapshot,
    );
  }
}

@riverpod

/// Controller for the history page.
class HistoryPageController extends _$HistoryPageController {
  ProviderSubscription<AsyncValue<NewEntryModel?>>? _subscription;

  @override
  FutureOr<HistoryPageState> build(
    String groupId,
    String projectId,
  ) async {
    final paginatedResult = await _fetchEntries(groupId, projectId, null);
    return HistoryPageState(
      entries: paginatedResult.values,
      lastBatchCount: paginatedResult.values.length,
      lastSnapshot: paginatedResult.token,
    );
  }

  Future<PaginatedResult<NewEntryModel>> _fetchEntries(
    String groupId,
    String projectId,
    Object? lastSnapshot,
  ) =>
      ref.read(entryRepositoryProvider).fetchEntries(
            groupId,
            projectId,
            HistoryPageState.limit,
            lastSnapshot: lastSnapshot,
          );

  /// Fetches the next batch of entries for a given [groupId] and [projectId].
  Future<void> fetchNextEntries() async {
    state = const AsyncLoading();
    final paginatedResult = await AsyncValue.guard(
      () => _fetchEntries(groupId, projectId, state.value!.lastSnapshot),
    );

    if (paginatedResult is AsyncError) {
      state = AsyncError(paginatedResult.error!, StackTrace.current);
    }

    final result = paginatedResult.value!;
    final entries = state.value!.entries..addAll(result.values);

    state = AsyncData(
      state.value!.copyWith(
        lastBatchCount: result.values.length,
        lastSnapshot: result.token,
        entries: entries,
      ),
    );
  }

  /// Observes a single entry and changes the state if the entry changes.
  void observeEntry(
    String entryId,
    void Function(EntryEditStatus) showSnackbar,
  ) {
    _subscription?.close();
    _subscription = ref.listen<AsyncValue<NewEntryModel?>>(
      streamEntryProvider(groupId, entryId),
      (previous, next) {
        if (previous is! AsyncData || next is! AsyncData) return;

        final previousAsStr = previous?.value?.asString() ?? '';
        final nextAsStr = next.value?.asString() ?? '';

        if (previousAsStr.isEmpty && nextAsStr.isEmpty ||
            previousAsStr == nextAsStr) return;

        final entries = state.value!.entries;
        final index = entries.indexWhere((e) => e.id == entryId);
        if (index == -1) return;
        var status = EntryEditStatus.none;
        if (previousAsStr.isNotEmpty && nextAsStr.isEmpty) {
          entries.removeAt(index);
          status = EntryEditStatus.deleted;
        } else //if (previousAsStr != nextAsStr)
        {
          entries[index] = next.value!;
          status = EntryEditStatus.updated;
        }
        state = AsyncData(state.value!.copyWith(entries: entries));
        showSnackbar(status);
      },
    );
  }

  /// Deletes an entry.
  Future<({bool success, void Function() onDismissedCallback})> tryDeleteEntry(
    String entryId,
  ) async {
    //state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(entryRepositoryProvider).deleteEntry(groupId, entryId),
    );

    if (result is AsyncError) {
      state = AsyncError(result.error, StackTrace.current);
    }
    return (
      success: !state.hasError,
      onDismissedCallback: state.hasError
          ? () {}
          : () {
              final entries = state.value!.entries
                ..removeWhere((e) => e.id == entryId);
              state = AsyncData(state.value!.copyWith(entries: entries));
            }
    );
  }
}
