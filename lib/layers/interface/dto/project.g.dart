// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends $Project with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Project(
    String id,
    String groupId,
    String name, {
    bool isMarkedAsFavourite = false,
    Iterable<TimeEntry> timeEntries = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Project>({
        'isMarkedAsFavourite': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'groupId', groupId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isMarkedAsFavourite', isMarkedAsFavourite);
    RealmObjectBase.set<RealmList<TimeEntry>>(
        this, 'timeEntries', RealmList<TimeEntry>(timeEntries));
  }

  Project._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get groupId => RealmObjectBase.get<String>(this, 'groupId') as String;
  @override
  set groupId(String value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  bool get isMarkedAsFavourite =>
      RealmObjectBase.get<bool>(this, 'isMarkedAsFavourite') as bool;
  @override
  set isMarkedAsFavourite(bool value) =>
      RealmObjectBase.set(this, 'isMarkedAsFavourite', value);

  @override
  RealmList<TimeEntry> get timeEntries =>
      RealmObjectBase.get<TimeEntry>(this, 'timeEntries')
          as RealmList<TimeEntry>;
  @override
  set timeEntries(covariant RealmList<TimeEntry> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Project>> get changes =>
      RealmObjectBase.getChanges<Project>(this);

  @override
  Project freeze() => RealmObjectBase.freezeObject<Project>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Project._);
    return const SchemaObject(ObjectType.realmObject, Project, 'Project', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('groupId', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('isMarkedAsFavourite', RealmPropertyType.bool),
      SchemaProperty('timeEntries', RealmPropertyType.object,
          linkTarget: 'TimeEntry', collectionType: RealmCollectionType.list),
    ]);
  }
}
