import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';
import 'package:my_time/domain/group_domain/models/enums/wokrplace.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Factory for the EntryEntity.
class NewEntryModelFactory {
  /// Creates a RegularEntryEntity.
  static NewWorkEntryModel createWork(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return NewWorkEntryModel.fromMap(groupId, projectId, type, map);
  }

  /// Creates a DayOffEntryEntity.
  static NewDayOffEntryModel createDayOff(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return NewDayOffEntryModel.fromMap(groupId, projectId, type, map);
  }

  static NewEntryModel fromMap(Map<String, Object?> map) {
    if (map['type']! as int == EntryType.work.index) {
      return NewWorkEntryModel(
        entryId: map['id']! as String,
        projectId: map['projectId']! as String,
        projectName: map['projectName']! as String,
        groupId: map['groupId']! as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date']! as int),
        startTime: Duration(minutes: map['startTimeInMinutes']! as int),
        endTime: Duration(minutes: map['endTimeInMinutes']! as int),
        breakTime: Duration(minutes: map['breakTimeInMinutes']! as int),
        totalTime: Duration(minutes: map['totalTimeInMinutes']! as int),
        workplace: Workplace.values[map['workplace']! as int],
        description: map['description']! as String,
        type: EntryType.values[map['type']! as int],
      );
    } else {
      return NewDayOffEntryModel(
        entryId: map['id']! as String,
        projectId: map['projectId']! as String,
        groupId: map['groupId']! as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date']! as int),
        paymentStatus: PaymentStatus.values[map['paymentStatus']! as int],
        description: map['description']! as String,
        type: EntryType.values[map['type']! as int],
        projectName: map['projectName']! as String,
      );
    }
  }
}

/// Base for all EntryEntities.
abstract class NewEntryModel {
  /// Constructor for the EntryEntity.
  NewEntryModel({
    required this.projectId,
    required this.groupId,
    required this.date,
    required this.description,
    required this.type,
    required this.projectName,
    String? entryId,
  }) : id = entryId ?? const uuid.Uuid().v1();

  /// Unique ID of the Entry.
  final String id;

  final String projectName;

  /// ProjectId towards which this entry is related.
  final String projectId;

  /// GroupId towards which this entry is related.
  final String groupId;

  /// Date of the entry.
  final DateTime date;

  /// Description of the entry.
  final String description;

  /// Type of the entry.
  final EntryType type;

  /// Copies the current entry and replaces the given values.
  NewEntryModel copyWith({
    String? entryId,
    String? projectId,
    String? groupId,
    DateTime? date,
    String? description,
    EntryType? type,
    String? projectName,
  });

  /// Returns the entry as a string.
  String asString();

  /// Returns the entry as a map.
  Map<String, dynamic> toMap();
}

/// Entry Enitity provides data about a single entry.
class NewWorkEntryModel extends NewEntryModel {
  /// Constructor for the EntryEntity.
  NewWorkEntryModel({
    required super.projectId,
    required super.groupId,
    required super.date,
    required this.startTime,
    required this.endTime,
    required this.breakTime,
    required this.totalTime,
    required this.workplace,
    required super.description,
    required super.type,
    required super.projectName,
    super.entryId,
  });

  /// Creates an [NewWorkEntryModel] from a map.
  factory NewWorkEntryModel.fromMap(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    final startTime = map[1] as Duration;
    final endTime = map[2] as Duration;
    final breakTime = map[3] as Duration;
    final totalTime = endTime - startTime - breakTime;
    return NewWorkEntryModel(
      groupId: groupId,
      projectId: projectId,
      date: map[0] as DateTime,
      startTime: startTime,
      endTime: endTime,
      breakTime: breakTime,
      totalTime: totalTime,
      workplace: map[4] as Workplace,
      description: map[5] as String,
      projectName: map[6] as String,
      type: type,
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'groupId': groupId,
      'date': date.millisecondsSinceEpoch,
      'startTimeInMinutes': startTime.inMinutes,
      'endTimeInMinutes': endTime.inMinutes,
      'breakTimeInMinutes': breakTime.inMinutes,
      'totalTimeInMinutes': totalTime.inMinutes,
      'workplace': workplace.index,
      'description': description,
      'type': type.index,
      'projectName': projectName,
    };
  }

  /// Start Time of the entry.
  final Duration startTime;

  /// End Time of the entry.
  final Duration endTime;

  /// Break Time of the entry.
  final Duration breakTime;

  /// Total Time of the entry.
  final Duration totalTime;

  /// Workplace of the entry.
  final Workplace workplace;

  @override
  NewWorkEntryModel copyWith({
    String? entryId,
    String? projectId,
    String? projectName,
    String? groupId,
    DateTime? date,
    String? description,
    EntryType? type,
    Duration? startTime,
    Duration? endTime,
    Duration? breakTime,
    Duration? totalTime,
    Workplace? workplace,
  }) {
    return NewWorkEntryModel(
      entryId: entryId ?? id,
      projectId: projectId ?? this.projectId,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      description: description ?? this.description,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakTime: breakTime ?? this.breakTime,
      totalTime: totalTime ?? this.totalTime,
      workplace: workplace ?? this.workplace,
      projectName: projectName ?? this.projectName,
    );
  }

  @override
  String asString() => toString();

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'WorkEntryEntity(id: $id, projectId: $projectId, groupId: $groupId, date: $date, description: $description, type: $type, startTime: $startTime, endTime: $endTime, breakTime: $breakTime, totalTime: $totalTime, workplace: $workplace)';
  }
}

/// Entity that provides data about a day off entry.
class NewDayOffEntryModel extends NewEntryModel {
  /// Constructor for the EntryEntity.
  NewDayOffEntryModel({
    required super.projectId,
    required super.projectName,
    required super.groupId,
    required super.date,
    required this.paymentStatus,
    required super.description,
    required super.type,
    super.entryId,
  });

  /// Creates an [NewDayOffEntryModel] from a map.
  factory NewDayOffEntryModel.fromMap(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return NewDayOffEntryModel(
      groupId: groupId,
      projectId: projectId,
      date: map[0] as DateTime,
      paymentStatus: map[1] as PaymentStatus,
      description: map[2] as String,
      type: type,
      projectName: map[3] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'groupId': groupId,
      'date': date.millisecondsSinceEpoch,
      'paymentStatus': paymentStatus.index,
      'description': description,
      'type': type.index,
      'projectName': projectName,
    };
  }

  /// Compensation of the entry.
  final PaymentStatus paymentStatus;

  @override
  NewDayOffEntryModel copyWith({
    String? entryId,
    String? projectId,
    String? groupId,
    DateTime? date,
    String? description,
    EntryType? type,
    PaymentStatus? paymentStatus,
    String? projectName,
  }) {
    return NewDayOffEntryModel(
      entryId: entryId ?? id,
      projectId: projectId ?? this.projectId,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      description: description ?? this.description,
      type: type ?? this.type,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      projectName: projectName ?? this.projectName,
    );
  }

  @override
  String asString() => toString();

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'DayOffEntryEntity(id: $id, projectId: $projectId, groupId: $groupId, date: $date, description: $description, type: $type, paymentStatus: $paymentStatus)';
  }
}
