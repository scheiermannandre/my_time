// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class TimeEntry extends $TimeEntry
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  TimeEntry(
    String id,
    String projectId,
    String groupId,
    DateTime startTime,
    DateTime endTime,
    String totalTimeStr,
    String breakTimeStr, {
    String description = "",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<TimeEntry>({
        'description': "",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'projectId', projectId);
    RealmObjectBase.set(this, 'groupId', groupId);
    RealmObjectBase.set(this, 'startTime', startTime);
    RealmObjectBase.set(this, 'endTime', endTime);
    RealmObjectBase.set(this, 'totalTimeStr', totalTimeStr);
    RealmObjectBase.set(this, 'breakTimeStr', breakTimeStr);
    RealmObjectBase.set(this, 'description', description);
  }

  TimeEntry._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get projectId =>
      RealmObjectBase.get<String>(this, 'projectId') as String;
  @override
  set projectId(String value) => RealmObjectBase.set(this, 'projectId', value);

  @override
  String get groupId => RealmObjectBase.get<String>(this, 'groupId') as String;
  @override
  set groupId(String value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  DateTime get startTime =>
      RealmObjectBase.get<DateTime>(this, 'startTime') as DateTime;
  @override
  set startTime(DateTime value) =>
      RealmObjectBase.set(this, 'startTime', value);

  @override
  DateTime get endTime =>
      RealmObjectBase.get<DateTime>(this, 'endTime') as DateTime;
  @override
  set endTime(DateTime value) => RealmObjectBase.set(this, 'endTime', value);

  @override
  String get totalTimeStr =>
      RealmObjectBase.get<String>(this, 'totalTimeStr') as String;
  @override
  set totalTimeStr(String value) =>
      RealmObjectBase.set(this, 'totalTimeStr', value);

  @override
  String get breakTimeStr =>
      RealmObjectBase.get<String>(this, 'breakTimeStr') as String;
  @override
  set breakTimeStr(String value) =>
      RealmObjectBase.set(this, 'breakTimeStr', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Stream<RealmObjectChanges<TimeEntry>> get changes =>
      RealmObjectBase.getChanges<TimeEntry>(this);

  @override
  TimeEntry freeze() => RealmObjectBase.freezeObject<TimeEntry>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(TimeEntry._);
    return const SchemaObject(ObjectType.realmObject, TimeEntry, 'TimeEntry', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('projectId', RealmPropertyType.string),
      SchemaProperty('groupId', RealmPropertyType.string),
      SchemaProperty('startTime', RealmPropertyType.timestamp),
      SchemaProperty('endTime', RealmPropertyType.timestamp),
      SchemaProperty('totalTimeStr', RealmPropertyType.string),
      SchemaProperty('breakTimeStr', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
    ]);
  }
}
