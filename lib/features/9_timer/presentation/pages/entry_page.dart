import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/payment_status_selector.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/settings_block.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/show_value.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/workplace_selector.dart';
import 'package:my_time/features/9_timer/data/repositories/entry_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/presentation/state_management/entry_page_controller.dart';
import 'package:my_time/features/9_timer/presentation/widgets/date_selector.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_selector.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/modals/modal_bottom_sheet_ui.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';
import 'package:my_time/foundation/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/spaced_row.dart';
import 'package:my_time/foundation/core/widgets/text_input_field.dart';
import 'package:my_time/foundation/core/widgets/wizard/labeled_widgets.dart';

/// Page to display and modify the settings of a project.
class EntryPage extends ConsumerWidget {
  /// Creates a [EntryPage].
  const EntryPage({
    required String groupId,
    required String entryId,
    super.key,
  })  : _entryId = entryId,
        _groupId = groupId;

  final String _groupId;
  final String _entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryPage = ref.watchAndListenStateProviderError(
      context,
      entryPageControllerProvider,
      entryPageControllerProvider.notifier,
    );
    final entryAsynValue = ref.watch(fetchEntryProvider(_groupId, _entryId));
    ref.listen(fetchEntryProvider(_groupId, _entryId), (_, next) {
      if (next is AsyncError) {
        next.showAlertDialogOnError(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final entry = entryPage.state.value?.entry;
            if (entry == null) {
              return const SizedBox.shrink();
            }
            var iconData = Icons.work;
            switch (entry.type) {
              case EntryType.vacation:
                iconData = Icons.beach_access_outlined;
              case EntryType.publicHoliday:
                iconData = Icons.work_off_outlined;
              case EntryType.sick:
                iconData = Icons.sick_outlined;
              case EntryType.work:
                iconData = Icons.work;
            }
            return SpacedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: SpaceTokens.small,
              children: [
                Icon(iconData),
                Text(
                  entry.date.toShortDateString(),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await ModalBottomSheetUI.showConfirmationSheet(
                context: context,
                title: context.loc.deleteEntryTitle,
                message: context.loc.deleteEntryMessage,
              );
              if (result == false) return;
              final success =
                  await entryPage.controller.deleteEntry(_groupId, _entryId);
              if (!context.mounted) return;
              if (!success) return;

              context.pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.medium,
        ),
        child: entryAsynValue.when(
          data: (data) {
            if (entryPage.state.value?.entry == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                entryPage.controller.cacheEntry(data);
              });
            }
            final entry = entryPage.state.value?.entry ?? data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: entryPage.state.value?.isInvalid ?? false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: SpaceTokens.medium),
                    child: SpacedRow(
                      spacing: SpaceTokens.small,
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          color: ThemelessColorTokens.red,
                        ),
                        Text(
                          context.loc.entryTotalTimeErrorMessage,
                          style: TextStyleTokens.body(null).copyWith(
                            color: ThemelessColorTokens.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _EntryEditWidget.withEntry(
                    context,
                    entry,
                    onChange: entryPage.controller.cacheEntry,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: SpaceTokens.medium),
                    child: ActionButton.primary(
                      onPressed: entryPage.state.value?.isInvalid ?? false
                          ? null
                          : () async {
                              final success =
                                  await entryPage.controller.updateEntry();
                              if (!context.mounted) return;
                              if (success) context.pop();
                            },
                      child: Text(context.loc.saveBtnLabel),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error')),
        ),
      ),
    );
  }
}

class _EntryEditWidget extends StatelessWidget {
  const _EntryEditWidget({
    required this.entry,
    required this.children,
    required this.onChange,
  });

  factory _EntryEditWidget.withEntry(
    BuildContext context,
    EntryEntity entry, {
    required void Function(EntryEntity) onChange,
  }) {
    if (entry.type == EntryType.work) {
      return _EntryEditWidget._fromWorkEntry(
        context,
        entry as WorkEntryEntity,
        onChange,
      );
    } else {
      return _EntryEditWidget._fromDayOffEntry(
        context,
        entry as DayOffEntryEntity,
        onChange,
      );
    }
  }

  factory _EntryEditWidget._fromDayOffEntry(
    BuildContext context,
    DayOffEntryEntity entry,
    void Function(EntryEntity) onChange,
  ) {
    return _EntryEditWidget(
      entry: entry,
      onChange: onChange,
      children: [
        SettingsBlock(
          label: context.loc.vacationPaymentLabel,
          children: [
            ShowValue(
              label: entry.paymentStatus.label(context),
              onTap: () async {
                final paymentStatus = await ModalDialogUI.show<PaymentStatus?>(
                  context: context,
                  title: context.loc.vacationPaymentLabel,
                  content: SingleChildScrollView(
                    child: PaymentStatusSelector(
                      paymentStatus: entry.paymentStatus,
                      onChoose: (workplace) {
                        Navigator.of(context).pop(workplace);
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  actions: [],
                );

                if (paymentStatus != null) {
                  onChange(
                    entry.copyWith(
                      paymentStatus: paymentStatus,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  factory _EntryEditWidget._fromWorkEntry(
    BuildContext context,
    WorkEntryEntity entry,
    void Function(EntryEntity) onChange,
  ) {
    return _EntryEditWidget(
      entry: entry,
      onChange: onChange,
      children: [
        SpacedRow(
          spacing: SpaceTokens.medium,
          children: [
            Expanded(
              flex: 4,
              child: SettingsBlock(
                label: context.loc.entryStartTimeLabel,
                children: [
                  ShowValue(
                    label: entry.startTime.toFormattedString(),
                    onTap: () async {
                      final startTime = await _showTimeSelector(
                        context,
                        entry.startTime,
                        context.loc.entryStartTimeLabel,
                      );
                      if (startTime != null) {
                        onChange(
                          entry.copyWith(
                            startTime: startTime,
                            totalTime:
                                entry.endTime - startTime - entry.breakTime,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SettingsBlock(
                label: context.loc.entryBreakTimeLabel,
                children: [
                  ShowValue(
                    label: entry.breakTime.toFormattedString(),
                    onTap: () async {
                      final breakTime = await _showTimeSelector(
                        context,
                        entry.breakTime,
                        context.loc.entryBreakTimeLabel,
                      );
                      if (breakTime != null) {
                        onChange(
                          entry.copyWith(
                            breakTime: breakTime,
                            totalTime:
                                entry.endTime - entry.startTime - breakTime,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SpacedRow(
          spacing: SpaceTokens.medium,
          children: [
            Expanded(
              flex: 4,
              child: SettingsBlock(
                label: context.loc.entryEndTimeLabel,
                children: [
                  ShowValue(
                    label: entry.endTime.toFormattedString(),
                    onTap: () async {
                      final endTime = await _showTimeSelector(
                        context,
                        entry.endTime,
                        context.loc.entryEndTimeLabel,
                      );

                      if (endTime != null) {
                        onChange(
                          entry.copyWith(
                            endTime: endTime,
                            totalTime:
                                endTime - entry.startTime - entry.breakTime,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SettingsBlock(
                label: context.loc.entryTotalTimeLabel,
                children: [
                  ShowValue(
                    label: entry.totalTime.toFormattedString(),
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsBlock(
          label: context.loc.entryStartTimeLabel,
          children: [
            ShowValue(
              label: entry.workplace.label(context),
              onTap: () async {
                final workplace = await ModalDialogUI.show<Workplace?>(
                  context: context,
                  title: context.loc.workplaceLabel,
                  content: SingleChildScrollView(
                    child: WorkplaceSelector(
                      workplace: entry.workplace,
                      onChoose: (workplace) {
                        Navigator.of(context).pop(workplace);
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  actions: [],
                );

                if (workplace != null) {
                  onChange(
                    entry.copyWith(
                      workplace: workplace,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
  final EntryEntity entry;
  final List<Widget> children;

  final void Function(EntryEntity) onChange;

  static Future<Duration?> _showTimeSelector(
    BuildContext context,
    Duration initialTime,
    String label,
  ) async {
    return ModalDialogUI.show<Duration?>(
      context: context,
      title: label,
      content: SingleChildScrollView(
        child: TimeSelector(
          initialValue: initialTime,
          onSave: (date) {
            Navigator.of(context).pop(date);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsBlock(
            label: context.loc.entryDateLabel,
            children: [
              ShowValue(
                label: entry.date.toFormattedDateString(),
                onTap: () async {
                  final date = await ModalDialogUI.show<DateTime?>(
                    context: context,
                    title: context.loc.entryDateLabel,
                    content: SingleChildScrollView(
                      child: DateSelector(
                        initialValue: entry.date,
                        onSave: (date) {
                          Navigator.of(context).pop(date);
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    actions: [],
                  );

                  if (date != null) {
                    onChange(entry.copyWith(date: date));
                  }
                },
              ),
            ],
          ),
          ...children,
          LabeledWidgets(
            label: context.loc.entryDescriptionLabel,
            children: [
              TextInputField(
                maxLines: 10,
                initialValue: entry.description,
                onChanged: (value, isValid) {
                  onChange(entry.copyWith(description: value));
                },
              ),
            ],
          ),
          const SizedBox(height: SpaceTokens.large),
        ],
      ),
    );
  }
}
