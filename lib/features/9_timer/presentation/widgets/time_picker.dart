import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/number_picker.dart';

/// A time picker widget that allows the user to select a time.
class TimePicker extends StatefulWidget {
  /// Creates a time picker widget.
  const TimePicker({
    required this.onTimeChanged,
    required this.initialTime,
    super.key,
  });

  /// callback function that is called when the time is changed.
  final void Function(Duration) onTimeChanged;

  /// The initial time to display in the picker.
  final Duration initialTime;

  @override
  TimePickerState createState() => TimePickerState();
}

/// The state of the time picker widget.
class TimePickerState extends State<TimePicker> {
  Duration _time = Duration.zero;

  @override
  void initState() {
    _time = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker.styled(
          context: context,
          value: _time.inHours,
          minValue: 0,
          maxValue: 23,
          zeroPad: true,
          itemCount: 5,
          onChanged: (value) => _timeChanged(value, _time.inMinutes % 60),
        ),
        Text(
          ':',
          style: TextStyleTokens.getHeadline3(null),
        ),
        NumberPicker.styled(
          context: context,
          value: _time.inMinutes % 60,
          minValue: 0,
          maxValue: 59,
          itemCount: 5,
          zeroPad: true,
          infiniteLoop: true,
          onChanged: (value) => _timeChanged(_time.inHours, value),
        ),
      ],
    );
  }

  void _timeChanged(int hours, int minutes) {
    setState(() {
      _time = Duration(hours: hours, minutes: minutes);
    });
    widget.onTimeChanged.call(_time);
  }
}
