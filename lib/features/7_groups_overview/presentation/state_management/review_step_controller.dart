import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_step_controller.g.dart';

@riverpod

/// Controller for managing the review step state and actions.
class ReviewStepController extends _$ReviewStepController {
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
    final data = ProjectWithSettingsEntity(
      groupId: (projectMap[0] as GroupEntity).id,
      name: projectMap[1] as String,
      sickDaysPayment: projectMap[2] as PaymentStatus?,
      publicHolidaysPayment: projectMap[3] as PaymentStatus?,
      vacationInfo: projectMap[4] as VacationEntity?,
      timeManagement: projectMap[5] as ProjectTimeManagementEntity?,
      moneyManagement: projectMap[6] as ProjectMoneyManagementEntity?,
      workplace: projectMap[7] as Workplace?,
    );

    // Use AsyncValue.guard to handle errors during the operation.
    state = await AsyncValue.guard(
      () => ref.read(projectServiceProvider).addProject(data),
    );

    // Return a boolean indicating the success of the project addition.
    return !state.hasError;
  }
}
