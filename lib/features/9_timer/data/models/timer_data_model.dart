import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_data_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_state.dart';

@immutable

/// The model for the project timer.
class TimerDataModel {
  /// Creates a [TimerDataModel].
  const TimerDataModel({
    required this.start,
    required this.breakStarts,
    required this.breakEnds,
    required this.end,
    required this.state,
  });

  /// Creates a [TimerDataModel] from a [Map].
  factory TimerDataModel.fromMap(Map<String, dynamic> map) {
    return TimerDataModel(
      start: DateTime.parse(map['start'] as String),
      breakStarts: List<DateTime>.from(
        (map['breakStarts'] as List<dynamic>).map<DateTime>(
          (value) => DateTime.parse(value as String),
        ),
      ),
      breakEnds: List<DateTime>.from(
        (map['breakEnds'] as List<dynamic>).map<DateTime>(
          (value) => DateTime.parse(value as String),
        ),
      ),
      end: map['end'] != null ? DateTime.parse(map['end'] as String) : null,
      state: map['timerState'] as int,
    );
  }

  /// Creates a [TimerDataModel] from a [String].
  factory TimerDataModel.fromJson(String source) =>
      TimerDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Creates a [TimerDataModel] from a [TimerDataEntity].
  factory TimerDataModel.fromEntity(TimerDataEntity entity) {
    return TimerDataModel(
      start: entity.start,
      breakStarts: entity.breakStarts,
      breakEnds: entity.breakEnds,
      end: entity.end,
      state: entity.state.index,
    );
  }

  /// The start time of the project timer.
  final DateTime start;

  /// The start times of the breaks of the project timer.
  final List<DateTime> breakStarts;

  /// The end times of the breaks of the project timer.
  final List<DateTime> breakEnds;

  /// The start time of the project timer.
  final DateTime? end;

  /// The state of the project timer.
  final int state;

  /// Copy of the [TimerDataModel] with the given fields replaced with the new
  TimerDataModel copyWith({
    DateTime? start,
    List<DateTime>? breakStarts,
    List<DateTime>? breakEnds,
    DateTime? end,
    int? timerState,
  }) {
    return TimerDataModel(
      start: start ?? this.start,
      breakStarts: breakStarts ?? this.breakStarts,
      breakEnds: breakEnds ?? this.breakEnds,
      end: end ?? this.end,
      state: timerState ?? state,
    );
  }

  /// Converts the [TimerDataModel] to a [TimerDataEntity].
  TimerDataEntity toEntity() {
    return TimerDataEntity(
      start: start,
      breakStarts: breakStarts,
      breakEnds: breakEnds,
      state: TimerState.values[state],
    );
  }

  /// Converts the [TimerDataModel] to a [Map].
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.toIso8601String(),
      'breakStarts': breakStarts.map((x) => x.toIso8601String()).toList(),
      'breakEnds': breakEnds.map((x) => x.toIso8601String()).toList(),
      'end': end?.toIso8601String(),
      'timerState': state,
    };
  }

  /// Converts a [TimerDataModel] to a [String].
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''TimerDataModel(start: $start, breakStarts: $breakStarts, breakEnds: $breakEnds, end: $end, timerState: $state)''';
  }

  @override
  bool operator ==(covariant TimerDataModel other) {
    if (identical(this, other)) return true;

    return other.start == start &&
        listEquals(other.breakStarts, breakStarts) &&
        listEquals(other.breakEnds, breakEnds) &&
        other.end == end &&
        other.state == state;
  }

  @override
  int get hashCode {
    return start.hashCode ^
        breakStarts.hashCode ^
        breakEnds.hashCode ^
        end.hashCode ^
        state.hashCode;
  }
}
