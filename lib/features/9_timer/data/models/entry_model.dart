import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.createdAt,
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
    if (entity is RegularEntryEntity) {
      return EntryModel(
        id: entity.id,
        projectId: entity.projectId,
        groupId: entity.groupId,
        date: entity.date,
        startTimeInMinutes: entity.startTime.inMinutes,
        endTimeInMinutes: entity.endTime.inMinutes,
        breakTimeInMinutes: entity.breakTime.inMinutes,
        totalTimeInMinutes: entity.totalTime.inMinutes,
        workplace: entity.workplace.index,
        description: entity.description,
        type: entity.type.index,
        createdAt: entity.createdAt != null
            ? Timestamp.fromDate(entity.createdAt!)
            : null,
      );
    } else //if (entity is DayOffEntryEntity)
    {
      entity = entity as DayOffEntryEntity;
      return EntryModel(
        id: entity.id,
        projectId: entity.projectId,
        groupId: entity.groupId,
        date: entity.date,
        paymentStatus: entity.paymentStatus.index,
        description: entity.description,
        type: entity.type.index,
        createdAt: entity.createdAt != null
            ? Timestamp.fromDate(entity.createdAt!)
            : null,
      );
    }
  }

  /// Converts a map to an [EntryModel].
  factory EntryModel.fromMap(Map<String, Object?> map) {
    if (map['type']! as int == EntryType.regular.index) {
      return EntryModel(
        id: map['id']! as String,
        projectId: map['projectId']! as String,
        groupId: map['groupId']! as String,
        date: DateTime.parse(map['date']! as String),
        startTimeInMinutes: map['startTimeInMinutes']! as int,
        endTimeInMinutes: map['endTimeInMinutes']! as int,
        breakTimeInMinutes: map['breakTimeInMinutes']! as int,
        totalTimeInMinutes: map['totalTimeInMinutes']! as int,
        workplace: map['workplace']! as int,
        description: map['description']! as String,
        type: map['type']! as int,
        createdAt:
            Timestamp.fromDate(DateTime.parse(map['createdAt']! as String)),
      );
    } else {
      return EntryModel(
        id: map['id']! as String,
        projectId: map['projectId']! as String,
        groupId: map['groupId']! as String,
        date: DateTime.parse(map['date']! as String),
        paymentStatus: map['paymentStatus']! as int,
        description: map['description']! as String,
        type: map['type']! as int,
        createdAt:
            Timestamp.fromDate(DateTime.parse(map['createdAt']! as String)),
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
  final DateTime date;

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

  /// The time the entry was created.
  final Timestamp? createdAt;

  /// Converts the [EntryModel] to a map.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'groupId': groupId,
      'date': date.toIso8601String(),
      'startTimeInMinutes': startTimeInMinutes,
      'endTimeInMinutes': endTimeInMinutes,
      'breakTimeInMinutes': breakTimeInMinutes,
      'totalTimeInMinutes': totalTimeInMinutes,
      'workplace': workplace,
      'description': description,
      'type': type,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
