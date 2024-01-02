import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/data/repositories/entry_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_entry_wizard_controller.g.dart';

@riverpod

/// Controller for managing the review step state and actions.
class AddEntryWizardController extends _$AddEntryWizardController {
  /// Override the build method to handle the widget's build lifecycle.
  @override
  FutureOr<void> build() {}

  /// Adds a new entry to the database.
  Future<bool> addEntry(
    String groupId,
    String projectId,
    Map<int, dynamic> entryMap,
  ) async {
    // Set the state to indicate loading.
    state = const AsyncLoading();

    final data = NewEntryModelFactory.createWork(
      groupId,
      projectId,
      EntryType.work,
      entryMap,
    );
    // Use AsyncValue.guard to handle errors during the operation.
    state = await AsyncValue.guard(
      () => ref.read(entryRepositoryProvider).createEntry(data),
    );

    // Return a boolean indicating the success of the project addition.
    return !state.hasError;
  }
}
