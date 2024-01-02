import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    required this.date,
    required this.trailingChild,
    super.key,
    this.projectNameChild,
    this.timeRangeChild,
  });

  factory EntryCard.fromEntry({
    required BuildContext context,
    required NewEntryModel entry,
  }) {
    if (entry is NewWorkEntryModel) {
      return EntryCard.fromWorkEntry(entry: entry);
    } else {
      return EntryCard.fromDayOffEntry(
        context: context,
        entry: entry as NewDayOffEntryModel,
      );
    }
  }
  factory EntryCard.fromWorkEntry({required NewWorkEntryModel entry}) {
    return EntryCard(
      projectNameChild: Text(entry.projectName),
      date: entry.date,
      trailingChild: Text(
        entry.totalTime.toFormattedString(),
        style: TextStyleTokens.bodyTickMoreMedium(null),
      ),
      timeRangeChild: Text(
        '${entry.startTime.toFormattedString()} - ${entry.endTime.toFormattedString()}',
      ),
    );
  }

  factory EntryCard.fromDayOffEntry({
    required BuildContext context,
    required NewDayOffEntryModel entry,
  }) {
    final iconColor = ThemeColorBuilder(context).getGuidingIconColor();
    var iconData = Icons.beach_access_outlined;

    switch (entry.type) {
      case EntryType.vacation:
        iconData = Icons.beach_access_outlined;
      case EntryType.sick:
        iconData = Icons.local_hospital_outlined;
      case EntryType.publicHoliday:
        iconData = Icons.card_giftcard_outlined;
      // ignore: no_default_cases
      default:
        iconData = Icons.beach_access_outlined;
    }

    return EntryCard(
      date: entry.date,
      trailingChild: Icon(iconData, color: iconColor),
    );
  }

  final Widget? projectNameChild;
  final DateTime date;
  final Widget? timeRangeChild;
  final Widget trailingChild;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SpaceTokens.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (projectNameChild != null) projectNameChild!,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date.toFormattedDateString(),
                      style: TextStyleTokens.bodyTickMoreMedium(null),
                    ),
                    trailingChild,
                  ],
                ),
                if (timeRangeChild != null) timeRangeChild!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
