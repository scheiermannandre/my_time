import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Factory for the EntryEntity.
class EntryEntityFactory {
  /// Creates a RegularEntryEntity.
  static WorkEntryEntity createWork(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return WorkEntryEntity.fromMap(groupId, projectId, type, map);
  }

  /// Creates a DayOffEntryEntity.
  static DayOffEntryEntity createDayOff(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return DayOffEntryEntity.fromMap(groupId, projectId, type, map);
  }
}

/// Base for all EntryEntities.
abstract class EntryEntity {
  /// Constructor for the EntryEntity.
  EntryEntity({
    required this.projectId,
    required this.groupId,
    required this.date,
    required this.description,
    required this.type,
    String? entryId,
  }) : id = entryId ?? const uuid.Uuid().v1();

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
  final EntryType type;

  /// Copies the current entry and replaces the given values.
  EntryEntity copyWith({
    String? entryId,
    String? projectId,
    String? groupId,
    DateTime? date,
    String? description,
    EntryType? type,
  });

  /// Returns the entry as a string.
  String asString();
}

/// Entry Enitity provides data about a single entry.
class WorkEntryEntity extends EntryEntity {
  /// Constructor for the EntryEntity.
  WorkEntryEntity({
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
    super.entryId,
  });

  /// Creates an [WorkEntryEntity] from a map.
  factory WorkEntryEntity.fromMap(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    final startTime = map[1] as Duration;
    final endTime = map[2] as Duration;
    final breakTime = map[3] as Duration;
    final totalTime = endTime - startTime - breakTime;
    return WorkEntryEntity(
      groupId: groupId,
      projectId: projectId,
      date: map[0] as DateTime,
      startTime: startTime,
      endTime: endTime,
      breakTime: breakTime,
      totalTime: totalTime,
      workplace: map[4] as Workplace,
      description: map[5] as String,
      type: type,
    );
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
  WorkEntryEntity copyWith({
    String? entryId,
    String? projectId,
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
    return WorkEntryEntity(
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
class DayOffEntryEntity extends EntryEntity {
  /// Constructor for the EntryEntity.
  DayOffEntryEntity({
    required super.projectId,
    required super.groupId,
    required super.date,
    required this.paymentStatus,
    required super.description,
    required super.type,
    super.entryId,
  });

  /// Creates an [DayOffEntryEntity] from a map.
  factory DayOffEntryEntity.fromMap(
    String groupId,
    String projectId,
    EntryType type,
    Map<int, dynamic> map,
  ) {
    return DayOffEntryEntity(
      groupId: groupId,
      projectId: projectId,
      date: map[0] as DateTime,
      paymentStatus: map[1] as PaymentStatus,
      description: map[2] as String,
      type: type,
    );
  }

  /// Compensation of the entry.
  final PaymentStatus paymentStatus;

  @override
  DayOffEntryEntity copyWith({
    String? entryId,
    String? projectId,
    String? groupId,
    DateTime? date,
    String? description,
    EntryType? type,
    PaymentStatus? paymentStatus,
  }) {
    return DayOffEntryEntity(
      entryId: entryId ?? id,
      projectId: projectId ?? this.projectId,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      description: description ?? this.description,
      type: type ?? this.type,
      paymentStatus: paymentStatus ?? this.paymentStatus,
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
