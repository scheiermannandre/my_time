// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Group extends _Group with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Group(
    String id, {
    String name = "",
    Iterable<Project> projects = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Group>({
        'name': "",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<Project>>(
        this, 'projects', RealmList<Project>(projects));
  }

  Group._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<Project> get projects =>
      RealmObjectBase.get<Project>(this, 'projects') as RealmList<Project>;
  @override
  set projects(covariant RealmList<Project> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Group>> get changes =>
      RealmObjectBase.getChanges<Group>(this);

  @override
  Group freeze() => RealmObjectBase.freezeObject<Group>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Group._);
    return const SchemaObject(ObjectType.realmObject, Group, 'Group', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('projects', RealmPropertyType.object,
          linkTarget: 'Project', collectionType: RealmCollectionType.list),
    ]);
  }
}
