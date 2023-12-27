import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/modals/modal_dialog_ui.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:my_time/features/7_groups_overview/presentation/state_management/project_settings_page_controller.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/currency_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/number_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/payment_interval_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/payment_status_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/reference_period_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/settings_block.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/show_value.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/text_value_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/workplace_selector.dart';

/// Page to display and modify the settings of a project.
class ProjectSettingsPage extends ConsumerWidget {
  /// Creates a [ProjectSettingsPage].
  const ProjectSettingsPage({
    required String groupId,
    required String projectId,
    required String projectName,
    super.key,
  })  : _projectId = projectId,
        _groupId = groupId,
        _projectName = projectName;

  final String _groupId;
  final String _projectId;
  final String _projectName;

  Future<PaymentStatus?> _changePaymentStatus(
    BuildContext context,
    String title,
    PaymentStatus? paymentStatus,
  ) async {
    return ModalDialogUI.show<PaymentStatus>(
      context: context,
      title: title,
      content: SingleChildScrollView(
        child: PaymentStatusSelector(
          paymentStatus: paymentStatus,
          onChoose: (value) {
            Navigator.of(context).pop(value);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<int?> _changeNumber({
    required BuildContext context,
    required String title,
    required int value,
    required int minValue,
    required int maxValue,
    required int step,
    required bool bigValues,
  }) async {
    return ModalDialogUI.show<int>(
      context: context,
      title: title,
      content: SingleChildScrollView(
        child: NumberSelector(
          bigValues: bigValues,
          initialValue: value,
          minValue: minValue,
          maxValue: maxValue,
          step: step,
          onSave: (selectedValue) {
            Navigator.of(context).pop(selectedValue);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  String? _getWorkingHourHint(
    ProjectTimeManagementEntity? timeManagement,
    BuildContext context,
  ) {
    if (timeManagement == null ||
        timeManagement.referencePeriod == null ||
        timeManagement.workingHours == null) {
      return null;
    }

    if (timeManagement.referencePeriod == ReferencePeriod.daily &&
        timeManagement.workingHours! > 24) {
      return context.loc
          .step6workingHourValidation(24, ReferencePeriod.daily.label(context));
    } else if (timeManagement.referencePeriod == ReferencePeriod.weekly &&
        timeManagement.workingHours! > 168) {
      return context.loc.step6workingHourValidation(
        168,
        ReferencePeriod.weekly.label(context),
      );
    } else if (timeManagement.referencePeriod == ReferencePeriod.monthly &&
        timeManagement.workingHours! > 744) {
      return context.loc.step6workingHourValidation(
        744,
        ReferencePeriod.monthly.label(context),
      );
    } else if (timeManagement.referencePeriod == ReferencePeriod.annually &&
        timeManagement.workingHours! > 8760) {
      return context.loc.step6workingHourValidation(
        8760,
        ReferencePeriod.annually.label(context),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsPage = ref.watchAndListenStateProviderError(
      context,
      projectSettingsPageControllerProvider,
      projectSettingsPageControllerProvider.notifier,
    );
    final project = ref
        .watch(streamProjectProvider(groupId: _groupId, projectId: _projectId));
    ref.listen(streamProjectProvider(groupId: _groupId, projectId: _projectId),
        (_, next) {
      if (next is AsyncError) {
        next.showAlertDialogOnError(context);
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text(project.valueOrNull?.name ?? _projectName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.medium,
        ),
        child: project.when(
          data: (project) => Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SettingsBlock(
                    label: context.loc.reviewStepProjectNameLabel,
                    children: [
                      ShowValue(
                        label: project.name,
                        onTap: () async {
                          await settingsPage.controller.updateProjectName(
                            project,
                            () => _setProjectName(context, project),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsBlock(
                    label: context.loc.notWorkingDaysPaymentLabel,
                    children: [
                      ShowValue(
                        label: context.loc.notWorkingDaysPaymentSickLabel,
                        data: project.sickDaysPayment?.label(context) ?? '',
                        onTap: () async {
                          await settingsPage.controller.updateSickDaysPayment(
                            project,
                            () => _setSickDaysPayment(context, project),
                          );
                        },
                      ),
                      ShowValue(
                        label: context
                            .loc.notWorkingDaysPaymentPublicHolidaysLabel,
                        data:
                            project.publicHolidaysPayment?.label(context) ?? '',
                        onTap: () async {
                          await settingsPage.controller
                              .updatePublicHolidaysPayment(
                            project,
                            () => _setPublicHolidayPayment(
                              context,
                              project,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsBlock(
                    label: context.loc.vacationLabel,
                    children: [
                      ShowValue(
                        label: context.loc.vacationDaysLabel,
                        data: project.vacationInfo?.days.toString() ?? '0',
                        onTap: () async {
                          await settingsPage.controller.updateVacationDays(
                            project,
                            () => _setVacationDays(context, project),
                            () => _setVacationDayPayment(context, project),
                          );
                        },
                      ),
                      ShowValue(
                        label: context.loc.vacationPaymentLabel,
                        data: project.vacationInfo?.paymentStatus
                                ?.label(context) ??
                            '0',
                        onTap: () async {
                          await settingsPage.controller
                              .updateVacationDaysPayment(
                            project,
                            () => _setVacationDayPayment(context, project),
                            () => _setVacationDays(context, project),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsBlock(
                    label: context.loc.timeManagementLabel,
                    children: [
                      ShowValue(
                        label: context.loc.timeManagementReferencePeriodLabel,
                        data: project.timeManagement?.referencePeriod
                            ?.label(context),
                        onTap: () async {
                          await settingsPage.controller
                              .updateTimeManagementReferencePeriod(
                            project,
                            () => _setReferencePeriod(context, project),
                            () => _setWorkingHours(project, context),
                          );
                        },
                      ),
                      ShowValue(
                        label: context.loc.timeManagementWorkingHoursLabel,
                        data: project.timeManagement?.workingHours.toString() ??
                            '0',
                        hint: _getWorkingHourHint(
                          project.timeManagement,
                          context,
                        ),
                        onTap: () async {
                          await settingsPage.controller
                              .updateTimeManagementWorkingHours(
                            project,
                            () => _setWorkingHours(project, context),
                            () => _setReferencePeriod(context, project),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsBlock(
                    label: context.loc.moneyManagementLabel,
                    children: [
                      ShowValue(
                        label: context.loc.moneyManagementPaymentIntervalLabel,
                        data: project.moneyManagement?.paymentInterval
                            ?.label(context),
                        onTap: () async {
                          await settingsPage.controller
                              .updateMoneyManagementInterval(
                            project,
                            () => _setPaymentInterval(context, project),
                            () => _setCurrency(context, project),
                            () => _setPayment(context, project),
                          );
                        },
                      ),
                      ShowValue(
                        label: context.loc.moneyManagementCurrencyLabel,
                        data: project.moneyManagement?.currency?.label,
                        onTap: () async {
                          await settingsPage.controller
                              .updateMoneyManagementCurrency(
                            project,
                            () => _setCurrency(context, project),
                            () => _setPaymentInterval(context, project),
                            () => _setPayment(context, project),
                          );
                        },
                      ),
                      ShowValue(
                        label: context.loc.moneyManagementPaymentLabel,
                        data: project.moneyManagement?.payment?.toString(),
                        onTap: () async {
                          await settingsPage.controller
                              .updateMoneyManagementPayment(
                            project,
                            () => _setPayment(context, project),
                            () => _setPaymentInterval(context, project),
                            () => _setCurrency(context, project),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsBlock(
                    label: context.loc.workplaceLabel,
                    children: [
                      ShowValue(
                        label: project.workplace?.label(context) ?? '',
                        onTap: () async {
                          await settingsPage.controller.updateWorkplace(
                            project,
                            () => _setWorkplace(context, project),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: SpaceTokens.large),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error')),
        ),
      ),
    );
  }

  Future<Workplace?> _setWorkplace(
    BuildContext context,
    ProjectEntity project,
  ) async {
    return ModalDialogUI.show<Workplace>(
      context: context,
      title: context.loc.workplaceLabel,
      content: SingleChildScrollView(
        child: WorkplaceSelector(
          workplace: project.workplace,
          onChoose: (value) {
            Navigator.of(context).pop(value);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<PaymentStatus?> _setPublicHolidayPayment(
    BuildContext context,
    ProjectEntity project,
  ) async {
    final status = await _changePaymentStatus(
      context,
      context.loc.setPublicHolidaysPaymentDialogHeader,
      project.publicHolidaysPayment,
    );
    return status;
  }

  Future<PaymentStatus?> _setSickDaysPayment(
    BuildContext context,
    ProjectEntity project,
  ) async {
    final status = await _changePaymentStatus(
      context,
      context.loc.setSickDaysPaymentDialogHeader,
      project.sickDaysPayment,
    );
    return status;
  }

  Future<String?> _setProjectName(
    BuildContext context,
    ProjectEntity project,
  ) async {
    return ModalDialogUI.show<String>(
      context: context,
      title: context.loc.reviewStepProjectNameLabel,
      content: SingleChildScrollView(
        child: TextValueSelector(
          initialValue: project.name,
          validationEmptyMessage: context.loc.step2ValidationEmpty,
          onSave: (selectedValue) {
            Navigator.of(context).pop(selectedValue);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<int?> _setPayment(BuildContext context, ProjectEntity project) async {
    final payment = await _changeNumber(
      context: context,
      title: context.loc.moneyManagementPaymentLabel,
      value: project.moneyManagement?.payment?.toInt() ?? 0,
      minValue: 1,
      maxValue: 2000000000,
      step: 1,
      bigValues: true,
    );
    return payment;
  }

  Future<Currency?> _setCurrency(
    BuildContext context,
    ProjectEntity project,
  ) async {
    return ModalDialogUI.show<Currency>(
      context: context,
      title: context.loc.moneyManagementCurrencyLabel,
      content: SingleChildScrollView(
        child: CurrencySelector(
          currency: project.moneyManagement?.currency,
          onChoose: (value) {
            Navigator.of(context).pop(value);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<PaymentInterval?> _setPaymentInterval(
    BuildContext context,
    ProjectEntity project,
  ) async {
    return ModalDialogUI.show<PaymentInterval>(
      context: context,
      title: context.loc.moneyManagementPaymentIntervalLabel,
      content: SingleChildScrollView(
        child: PaymentIntervalSelector(
          paymentInterval: project.moneyManagement?.paymentInterval,
          onChoose: (value) {
            Navigator.of(context).pop(value);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<ReferencePeriod?> _setReferencePeriod(
    BuildContext context,
    ProjectEntity project,
  ) async {
    return ModalDialogUI.show<ReferencePeriod>(
      context: context,
      title: context.loc.timeManagementReferencePeriodLabel,
      content: SingleChildScrollView(
        child: ReferencePeriodSelector(
          referencePeriod: project.timeManagement?.referencePeriod,
          onChoose: (value) {
            Navigator.of(context).pop(value);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  Future<int?> _setWorkingHours(
    ProjectEntity project,
    BuildContext context,
  ) async {
    var maxValue = 8760;
    var bigValues = true;
    if (project.timeManagement?.referencePeriod == ReferencePeriod.daily) {
      maxValue = 24;
      bigValues = false;
    } else if (project.timeManagement?.referencePeriod ==
        ReferencePeriod.weekly) {
      maxValue = 168;
      bigValues = false;
    } else if (project.timeManagement?.referencePeriod ==
        ReferencePeriod.monthly) {
      maxValue = 744;
    } else if (project.timeManagement?.referencePeriod ==
        ReferencePeriod.annually) {
      maxValue = 8760;
    }
    return _changeNumber(
      context: context,
      title: context.loc.timeManagementWorkingHoursLabel,
      value: project.timeManagement?.workingHours ?? 0,
      minValue: 1,
      maxValue: maxValue,
      step: 1,
      bigValues: bigValues,
    );
  }

  Future<PaymentStatus?> _setVacationDayPayment(
    BuildContext context,
    ProjectEntity project,
  ) =>
      _changePaymentStatus(
        context,
        context.loc.moneyManagementPaymentLabel,
        project.publicHolidaysPayment,
      );

  Future<int?> _setVacationDays(
    BuildContext context,
    ProjectEntity project,
  ) =>
      _changeNumber(
        context: context,
        title: context.loc.vacationDaysLabel,
        value: project.vacationInfo?.days ?? 0,
        minValue: 1,
        maxValue: 100,
        step: 1,
        bigValues: false,
      );
}
