import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';
import 'package:my_time/features/9_timer/data/repositories/entry_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_days_off_wizard_controller.g.dart';

@riverpod

/// Controller for managing the review step state and actions.
class AddDaysOffWizardController extends _$AddDaysOffWizardController {
  /// Override the build method to handle the widget's build lifecycle.
  @override
  FutureOr<void> build() {}

  /// Adds a new entry to the database.
  Future<bool> addEntries(
    String groupId,
    String projectId,
    EntryType entryType,
    Map<int, dynamic> daysOffMap,
  ) async {
    // Set the state to indicate loading.
    state = const AsyncLoading();

    final entries = <NewDayOffEntryModel>[];

    final daysOff = daysOffMap[0] as List<DateTime?>;
    final compensation = daysOffMap[1] as PaymentStatus;
    final description = daysOffMap[2] as String;
    final projectName = daysOffMap[3] as String;
    for (final element in daysOff) {
      final entryMap = <int, dynamic>{}..addAll({
          0: element,
          1: compensation,
          2: description,
          3: projectName,
        });

      final data = NewEntryModelFactory.createDayOff(
        groupId,
        projectId,
        entryType,
        entryMap,
      );
      entries.add(data);
    }

    // Use AsyncValue.guard to handle errors during the operation.
    final result = await AsyncValue.guard(
      () => ref
          .read(entryRepositoryProvider)
          .createDayOffEntries(groupId, projectId, entries),
    );

    if (result is AsyncError) {
      state = result;
    }

    // Return a boolean indicating the success of the project addition.
    return !state.hasError;
  }
}
