import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_project_wizard_controller.g.dart';

@riverpod

/// Controller for managing the review step state and actions.
class AddProjectWizardController extends _$AddProjectWizardController {
  /// Override the build method to handle the widget's build lifecycle.
  @override
  FutureOr<void> build() {}

  /// Asynchronous method to add a project based on the provided project map.
  ///
  /// - Parameters:
  ///   - `projectMap`: A map containing project-related data.
  ///     - Key 0: `GroupEntity` (Group of the project)
  ///     - Key 1: `String` (Name of the project)
  ///     - Key 2: `PaymentStatus?` (Sick days payment status)
  ///     - Key 3: `PaymentStatus?` (Public holidays payment status)
  ///     - Key 4: `VacationEntity?` (Vacation information)
  ///     - Key 5: `ProjectTimeManagementEntity?` (Time management information)
  ///     - Key 6: `ProjectMoneyManagementEntity?`
  ///               (Money management information)
  ///     - Key 7: `Workplace?` (Workplace information)
  ///
  /// - Returns:
  ///   - A `Future<bool>` indicating the success of the project addition.
  ///
  /// This method triggers the addition process, updating the state accordingly.
  Future<bool> addProject(Map<int, dynamic> projectMap) async {
    // Set the state to indicate loading.
    state = const AsyncLoading();

    // Create a ProjectWithSettingsEntity using the provided projectMap.
    final data = ProjectEntity.fromMap(projectMap);
    final projectService = ref.read(projectServiceProvider);
    // Use AsyncValue.guard to handle errors during the operation.
    state = await AsyncValue.guard(
      () => projectService.addProject(data),
    );

    // Return a boolean indicating the success of the project addition.
    return !state.hasError;
  }
}
