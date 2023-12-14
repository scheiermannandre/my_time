import 'package:my_time/features/7_groups_overview/data/repositories/project_repository_impl.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_settings_page_controller.g.dart';

@riverpod

/// Controller for the project settings page.
class ProjectSettingsPageController extends _$ProjectSettingsPageController {
  @override
  FutureOr<void> build() {}

  /// Updates the project name.
  Future<void> updateProjectName(
    ProjectEntity project,
    Future<String?> Function() projectNameSetter,
  ) async {
    final projectName = await projectNameSetter.call();
    if (projectName == null) return;

    final newProject = project.copyWith(
      name: projectName,
    );
    await updateProject(newProject);
  }

  /// Updates the value that tells if sick days are paid.
  Future<void> updateSickDaysPayment(
    ProjectEntity project,
    Future<PaymentStatus?> Function() sickDaysPaymentSetter,
  ) async {
    final sickDaysPayment = await sickDaysPaymentSetter.call();
    if (sickDaysPayment == null) return;

    final newProject = project.copyWith(
      sickDaysPayment: sickDaysPayment,
    );
    await updateProject(newProject);
  }

  /// Updates the value that tells if public holidays are paid.
  Future<void> updatePublicHolidaysPayment(
    ProjectEntity project,
    Future<PaymentStatus?> Function() publicHolidaysPaymentSetter,
  ) async {
    final publicHolidaysPayment = await publicHolidaysPaymentSetter.call();
    if (publicHolidaysPayment == null) return;

    final newProject = project.copyWith(
      publicHolidaysPayment: publicHolidaysPayment,
    );
    await updateProject(newProject);
  }

  /// Updates the amount of vacation days.
  Future<void> updateVacationDays(
    ProjectEntity project,
    Future<int?> Function() vacationDaySetter,
    Future<PaymentStatus?> Function() vacationPaymentSetter,
  ) async {
    final vacationDays = await vacationDaySetter.call();

    if (vacationDays == null) return;

    var newProject = project;
    if (project.vacationInfo == null) {
      final payment = await vacationPaymentSetter.call();
      if (payment == null) return;

      newProject = project.copyWith(
        vacationInfo: VacationEntity(
          days: vacationDays,
          paymentStatus: payment,
        ),
      );
    } else {
      newProject = project.copyWith(
        vacationInfo: project.vacationInfo?.copyWith(
          days: vacationDays,
        ),
      );
    }

    await updateProject(newProject);
  }

  /// Updates the payment status for vacation days.
  Future<void> updateVacationDaysPayment(
    ProjectEntity project,
    Future<PaymentStatus?> Function() vacationPaymentSetter,
    Future<int?> Function() vacationDaySetter,
  ) async {
    final payment = await vacationPaymentSetter.call();
    if (payment == null) return;

    var newProject = project;
    if (project.vacationInfo == null) {
      final vacationDays = await vacationDaySetter.call();

      if (vacationDays == null) return;
      newProject = project.copyWith(
        vacationInfo: VacationEntity(
          days: vacationDays,
          paymentStatus: payment,
        ),
      );
    } else {
      newProject = project.copyWith(
        vacationInfo: project.vacationInfo?.copyWith(
          paymentStatus: payment,
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the reference period for time management.
  Future<void> updateTimeManagementReferencePeriod(
    ProjectEntity project,
    Future<ReferencePeriod?> Function() referencePeriodSetter,
    Future<int?> Function() workingHoursSetter,
  ) async {
    final referencePeriod = await referencePeriodSetter.call();
    if (referencePeriod == null) return;

    var newProject = project;
    if (project.timeManagement == null) {
      final workingHours = await workingHoursSetter.call();

      if (workingHours == null) return;
      newProject = project.copyWith(
        timeManagement: ProjectTimeManagementEntity(
          workingHours: workingHours,
          referencePeriod: referencePeriod,
        ),
      );
    } else {
      newProject = project.copyWith(
        timeManagement: project.timeManagement?.copyWith(
          referencePeriod: referencePeriod,
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the working hours for time management.
  Future<void> updateTimeManagementWorkingHours(
    ProjectEntity project,
    Future<int?> Function() workingHoursSetter,
    Future<ReferencePeriod?> Function() referencePeriodSetter,
  ) async {
    final workingHours = await workingHoursSetter.call();
    if (workingHours == null) return;

    var newProject = project;
    if (project.timeManagement == null) {
      final referencePeriod = await referencePeriodSetter.call();
      if (referencePeriod == null) return;
      newProject = project.copyWith(
        timeManagement: ProjectTimeManagementEntity(
          workingHours: workingHours,
          referencePeriod: referencePeriod,
        ),
      );
    } else {
      newProject = project.copyWith(
        timeManagement: project.timeManagement?.copyWith(
          workingHours: workingHours,
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the payment interval for money management.
  Future<void> updateMoneyManagementInterval(
    ProjectEntity project,
    Future<PaymentInterval?> Function() intervalSetter,
    Future<Currency?> Function() currencySetter,
    Future<int?> Function() amountSetter,
  ) async {
    final interval = await intervalSetter.call();
    if (interval == null) return;

    var newProject = project;
    if (project.moneyManagement == null) {
      final currency = await currencySetter.call();
      if (currency == null) return;

      final amount = await amountSetter.call();
      if (amount == null) return;

      newProject = project.copyWith(
        moneyManagement: ProjectMoneyManagementEntity(
          paymentInterval: interval,
          currency: currency,
          payment: amount.toDouble(),
        ),
      );
    } else {
      newProject = project.copyWith(
        moneyManagement: project.moneyManagement?.copyWith(
          paymentInterval: interval,
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the currency for money management.
  Future<void> updateMoneyManagementCurrency(
    ProjectEntity project,
    Future<Currency?> Function() currencySetter,
    Future<PaymentInterval?> Function() intervalSetter,
    Future<int?> Function() amountSetter,
  ) async {
    final currency = await currencySetter.call();
    if (currency == null) return;

    var newProject = project;
    if (project.moneyManagement == null) {
      final interval = await intervalSetter.call();
      if (interval == null) return;

      final amount = await amountSetter.call();
      if (amount == null) return;

      newProject = project.copyWith(
        moneyManagement: ProjectMoneyManagementEntity(
          paymentInterval: interval,
          currency: currency,
          payment: amount.toDouble(),
        ),
      );
    } else {
      newProject = project.copyWith(
        moneyManagement: project.moneyManagement?.copyWith(
          currency: currency,
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the payment amount for money management.
  Future<void> updateMoneyManagementPayment(
    ProjectEntity project,
    Future<int?> Function() amountSetter,
    Future<PaymentInterval?> Function() intervalSetter,
    Future<Currency?> Function() currencySetter,
  ) async {
    final amount = await amountSetter.call();
    if (amount == null) return;

    var newProject = project;
    if (project.moneyManagement == null) {
      final interval = await intervalSetter.call();
      if (interval == null) return;

      final currency = await currencySetter.call();
      if (currency == null) return;

      newProject = project.copyWith(
        moneyManagement: ProjectMoneyManagementEntity(
          paymentInterval: interval,
          currency: currency,
          payment: amount.toDouble(),
        ),
      );
    } else {
      newProject = project.copyWith(
        moneyManagement: project.moneyManagement?.copyWith(
          payment: amount.toDouble(),
        ),
      );
    }
    await updateProject(newProject);
  }

  /// Updates the workplace for the project.
  Future<void> updateWorkplace(
    ProjectEntity project,
    Future<Workplace?> Function() workplaceSetter,
  ) async {
    final workplace = await workplaceSetter.call();
    if (workplace == null) return;

    final newProject = project.copyWith(
      workplace: workplace,
    );
    await updateProject(newProject);
  }

  /// Updates the project entity.
  Future<void> updateProject(ProjectEntity project) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(projectRepositoryImplProvider).updateProject(
            project,
          ),
    );
  }
}
