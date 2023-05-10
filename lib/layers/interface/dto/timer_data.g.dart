// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_data.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class TimerData extends $TimerData
    with RealmEntity, RealmObjectBase, RealmObject {
  TimerData(
    String id,
    String projectId,
    DateTime startTime,
    DateTime endTime,
    String timerState, {
    Iterable<DateTime> breakStartTimes = const [],
    Iterable<DateTime> breakEndTimes = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'projectId', projectId);
    RealmObjectBase.set(this, 'startTime', startTime);
    RealmObjectBase.set(this, 'endTime', endTime);
    RealmObjectBase.set(this, 'timerState', timerState);
    RealmObjectBase.set<RealmList<DateTime>>(
        this, 'breakStartTimes', RealmList<DateTime>(breakStartTimes));
    RealmObjectBase.set<RealmList<DateTime>>(
        this, 'breakEndTimes', RealmList<DateTime>(breakEndTimes));
  }

  TimerData._();

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
  RealmList<DateTime> get breakStartTimes =>
      RealmObjectBase.get<DateTime>(this, 'breakStartTimes')
          as RealmList<DateTime>;
  @override
  set breakStartTimes(covariant RealmList<DateTime> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<DateTime> get breakEndTimes =>
      RealmObjectBase.get<DateTime>(this, 'breakEndTimes')
          as RealmList<DateTime>;
  @override
  set breakEndTimes(covariant RealmList<DateTime> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get timerState =>
      RealmObjectBase.get<String>(this, 'timerState') as String;
  @override
  set timerState(String value) =>
      RealmObjectBase.set(this, 'timerState', value);

  @override
  Stream<RealmObjectChanges<TimerData>> get changes =>
      RealmObjectBase.getChanges<TimerData>(this);

  @override
  TimerData freeze() => RealmObjectBase.freezeObject<TimerData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(TimerData._);
    return const SchemaObject(ObjectType.realmObject, TimerData, 'TimerData', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('projectId', RealmPropertyType.string),
      SchemaProperty('startTime', RealmPropertyType.timestamp),
      SchemaProperty('endTime', RealmPropertyType.timestamp),
      SchemaProperty('breakStartTimes', RealmPropertyType.timestamp,
          collectionType: RealmCollectionType.list),
      SchemaProperty('breakEndTimes', RealmPropertyType.timestamp,
          collectionType: RealmCollectionType.list),
      SchemaProperty('timerState', RealmPropertyType.string),
    ]);
  }
}
