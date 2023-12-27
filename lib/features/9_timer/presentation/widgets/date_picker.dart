import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// A widget representing the date selector.
class DatePicker extends StatefulWidget {
  /// Constructs a [DatePicker] with required parameters.
  const DatePicker({
    required this.data,
    required this.onSelect,
    this.onSave,
    this.isRange = false,
    super.key,
  });

  /// The date to be displayed.
  final List<DateTime?> data;

  /// The callback to be called when a date is selected.
  final void Function(List<DateTime?>) onSelect;

  /// The callback to be called when a date is saved.
  final void Function(List<DateTime?>)? onSave;

  /// Whether the date selector is a range selector.
  final bool isRange;

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<DateTime?> data = [];
  List<DateTime?> dateRange = [];
  bool excludeWeekends = false;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    dateRange = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data.isNotEmpty) {
        final date = DateTime.now();
        widget.onSave?.call([DateTime(date.year, date.month, date.day)]);
      }
    });
  }

  static List<DateTime?> getDatesBetween(
    List<DateTime?> dates,
    int startDateIndex,
    int endDateIndex,
    bool excludeWeekends,
  ) {
    final dateRange = <DateTime?>[];
    final startDate = dates.elementAtOrNull(startDateIndex);
    final endDate = dates.elementAtOrNull(endDateIndex);

    if (startDate == null || endDate == null) return dates;

    var date = startDate;
    while (date.isBefore(endDate)) {
      tryAddDate(date, excludeWeekends, dateRange);
      date = date.add(const Duration(days: 1));
    }
    tryAddDate(endDate, excludeWeekends, dateRange);
    return dateRange;
  }

  static void tryAddDate(
    DateTime date,
    bool excludeWeekends,
    List<DateTime?> dateRange,
  ) {
    if (!excludeWeekends ||
        (date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday)) {
      dateRange.add(date);
    }
  }

  List<DateTime?> exludeWeekendsFromList(List<DateTime?> dates) {
    final dateRange = <DateTime?>[];

    for (final date in dates) {
      if (date == null) continue;
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        continue;
      }
      dateRange.add(date);
    }
    return dateRange;
  }

  DateTime? getDate(int index) {
    return data.elementAtOrNull(index);
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      calendarType: widget.isRange
          ? CalendarDatePicker2Type.range
          : CalendarDatePicker2Type.single,
      weekdayLabelTextStyle: TextStyleTokens.body(null),
      controlsTextStyle: TextStyleTokens.body(null),
      dayTextStyle: TextStyleTokens.body(null),
      disabledDayTextStyle: TextStyleTokens.body(null),
      selectedDayTextStyle: TextStyleTokens.body(null).copyWith(
        color: ThemelessColorTokens.black,
      ),
      selectedRangeHighlightColor:
          Theme.of(context).colorScheme.primary.withOpacity(.5),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: dateRange.isNotEmpty,
          child: dateRange.length == 1
              ? Text(getDate(0)?.toFormattedDateString() ?? '')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${getDate(0)?.toFormattedDateString() ?? ''} - '),
                    Text(
                      getDate(1)?.toFormattedDateString() ?? '',
                    ),
                    Text(
                      context.loc.entryAmountDates(dateRange.length),
                    ),
                  ],
                ),
        ),
        CalendarDatePicker2(
          config: config,
          value: data,
          onValueChanged: (dates) {
            setState(() {
              data = dates;
              dateRange = getDatesBetween(dates, 0, 1, excludeWeekends);
            });
            if (dates.isEmpty) return;
            widget.onSelect(dateRange);
          },
        ),
        Visibility(
          visible: widget.isRange,
          child: ListTile(
            title: Text(context.loc.entryDateRangeExcludeWeekends),
            trailing: Switch(
              value: excludeWeekends,
              onChanged: (value) {
                setState(() {
                  excludeWeekends = value;
                  dateRange = getDatesBetween(data, 0, 1, excludeWeekends);
                  if (dateRange.isEmpty) return;
                  widget.onSave?.call(dateRange);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
