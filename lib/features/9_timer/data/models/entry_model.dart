import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';
import 'package:my_time/domain/group_domain/models/enums/wokrplace.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_entity.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';

/// Model for the Entry.
class EntryModel {
  /// Constructor for the EntryModel.
  EntryModel({
    required this.id,
    required this.projectId,
    required this.groupId,
    required this.date,
    required this.description,
    required this.type,
    this.startTimeInMinutes,
    this.endTimeInMinutes,
    this.breakTimeInMinutes,
    this.totalTimeInMinutes,
    this.workplace,
    this.paymentStatus,
  });

  /// Creates an [EntryModel] from an [EntryEntity].
  factory EntryModel.fromEntity(
    EntryEntity entity,
  ) {
    if (entity is WorkEntryEntity) {
      return EntryModel(
        id: entity.id,
        projectId: entity.projectId,
        groupId: entity.groupId,
        date: entity.date.millisecondsSinceEpoch,
        startTimeInMinutes: entity.startTime.inMinutes,
        endTimeInMinutes: entity.endTime.inMinutes,
        breakTimeInMinutes: entity.breakTime.inMinutes,
        totalTimeInMinutes: entity.totalTime.inMinutes,
        workplace: entity.workplace.index,
        description: entity.description,
        type: entity.type.index,
      );
    } else //if (entity is DayOffEntryEntity)
    {
      entity = entity as DayOffEntryEntity;
      return EntryModel(
        id: entity.id,
        projectId: entity.projectId,
        groupId: entity.groupId,
        date: entity.date.millisecondsSinceEpoch,
        paymentStatus: entity.paymentStatus.index,
        description: entity.description,
        type: entity.type.index,
      );
    }
  }

  /// Converts a map to an [EntryModel].
  factory EntryModel.fromMap(Map<String, Object?> map) {
    print(map);
    if (map['type']! as int == EntryType.work.index) {
      return EntryModel(
        id: map['id']! as String,
        projectId: map['projectId']! as String,
        groupId: map['groupId']! as String,
        date: map['date']! as int,
        startTimeInMinutes: map['startTimeInMinutes']! as int,
        endTimeInMinutes: map['endTimeInMinutes']! as int,
        breakTimeInMinutes: map['breakTimeInMinutes']! as int,
        totalTimeInMinutes: map['totalTimeInMinutes']! as int,
        workplace: map['workplace']! as int,
        description: map['description']! as String,
        type: map['type']! as int,
      );
    } else {
      return EntryModel(
        id: map['id']! as String,
        projectId: map['projectId']! as String,
        groupId: map['groupId']! as String,
        date: map['date']! as int,
        paymentStatus: map['paymentStatus']! as int,
        description: map['description']! as String,
        type: map['type']! as int,
      );
    }
  }

  /// Unique ID of the Entry.
  final String id;

  /// ProjectId towards which this entry is related.
  final String projectId;

  /// GroupId towards which this entry is related.
  final String groupId;

  /// Date of the entry.
  final int date;

  /// Description of the entry.
  final String description;

  /// Type of the entry.
  final int type;

  /// Start Time of the entry.
  final int? startTimeInMinutes;

  /// End Time of the entry.
  final int? endTimeInMinutes;

  /// Break Time of the entry.
  final int? breakTimeInMinutes;

  /// Total Time of the entry.
  final int? totalTimeInMinutes;

  /// Workplace of the entry.
  final int? workplace;

  /// Workplace of the entry.
  final int? paymentStatus;

  /// Converts the [EntryModel] to a map.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'groupId': groupId,
      'date': date,
      'startTimeInMinutes': startTimeInMinutes,
      'endTimeInMinutes': endTimeInMinutes,
      'breakTimeInMinutes': breakTimeInMinutes,
      'totalTimeInMinutes': totalTimeInMinutes,
      'workplace': workplace,
      'description': description,
      'type': type,
      'paymentStatus': paymentStatus,
    };
  }

  /// Converts the [EntryModel] to an [EntryEntity].
  EntryEntity toEntity() {
    if (type == EntryType.work.index) {
      return WorkEntryEntity(
        entryId: id,
        projectId: projectId,
        groupId: groupId,
        date: DateTime.fromMillisecondsSinceEpoch(date),
        startTime: Duration(minutes: startTimeInMinutes!),
        endTime: Duration(minutes: endTimeInMinutes!),
        breakTime: Duration(minutes: breakTimeInMinutes!),
        totalTime: Duration(minutes: totalTimeInMinutes!),
        workplace: Workplace.values[workplace!],
        description: description,
        type: EntryType.values[type],
      );
    } else {
      return DayOffEntryEntity(
        entryId: id,
        projectId: projectId,
        groupId: groupId,
        date: DateTime.fromMillisecondsSinceEpoch(date),
        paymentStatus: PaymentStatus.values[paymentStatus!],
        description: description,
        type: EntryType.values[type],
      );
    }
  }
}
