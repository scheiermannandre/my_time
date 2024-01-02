import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/data/repositories/entry_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entry_page_controller.g.dart';

/// State of the entry page.
class EntryPageState {
  /// Constructor for the EntryPageState.
  EntryPageState({this.entry});

  /// The entry to display.
  final NewEntryModel? entry;

  /// Returns true if the entry is invalid.
  bool get isInvalid {
    if (entry == null || entry is NewDayOffEntryModel) return false;
    final workEntry = entry! as NewWorkEntryModel;
    return workEntry.totalTime.isNegative;
  }

  /// Copies the current state and replaces the given values.
  EntryPageState copyWith({
    NewEntryModel? entry,
  }) {
    return EntryPageState(
      entry: entry ?? this.entry,
    );
  }
}

@riverpod

/// Controller for the project settings page.
class EntryPageController extends _$EntryPageController {
  @override
  FutureOr<EntryPageState> build() {
    return EntryPageState();
  }

  /// Updates the project entity.
  Future<bool> updateEntry() async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () => ref.read(entryRepositoryProvider).updateEntry(
            state.value!.entry!,
          ),
    );

    if (result is AsyncError) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(state.value!);
    }

    return !state.hasError;
  }

  /// Updates the project entity.
  Future<void> cacheEntry(NewEntryModel entry) async {
    state = AsyncData(state.value!.copyWith(entry: entry));
  }

  /// Deletes the entry entity.
  Future<bool> deleteEntry(String groupId, String entryId) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () => ref.read(entryRepositoryProvider).deleteEntry(
            groupId,
            entryId,
          ),
    );

    if (result is AsyncError) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(state.value!);
    }

    return !state.hasError;
  }
}
