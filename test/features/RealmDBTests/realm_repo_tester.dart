import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:realm/realm.dart';

typedef RealmGroupsRepoInstance = ({RealmDbGroupsRepository repo, Realm realm});

typedef RealmProjectsRepoInstance = ({
  RealmDbProjectsRepository repo,
  Realm realm
});

class RealmRepoTester {
  static Future<void> tearDownAll(List<Realm> realms) async {
    for (final realm in realms) {
      final path = realm.config.path;
      realm.close();
      Realm.deleteRealm(path);
      await File('$path.lock').delete();

      expect(realm.isClosed, true);
    }
  }

  static String generateRandomRealmName(int len) {
    final r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final nameBase =
        List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
    return '$nameBase.realm';
  }

  static RealmGroupsRepoInstance makeRealmGroupsRepoInstance(
    List<Realm> realms,
  ) {
    Configuration.defaultRealmName = generateRandomRealmName(30);

    final realm = Realm(
      Configuration.inMemory(
        [
          GroupRealmModel.schema,
          ProjectRealmModel.schema,
          TimeEntryRealmModel.schema,
        ],
      ),
    );
    // realms need to get closed, this is why all realms get their own name
    // and thus their own path.
    // After all test are run, the tearDownAll() function will
    // close all realms.
    realms.add(realm);
    return (realm: realm, repo: RealmDbGroupsRepository(realm));
  }

  static Realm makeRealm(
    List<Realm> realms,
  ) {
    Configuration.defaultRealmName = generateRandomRealmName(30);

    final realm = Realm(
      Configuration.inMemory(
        [
          GroupRealmModel.schema,
          ProjectRealmModel.schema,
          TimeEntryRealmModel.schema,
        ],
      ),
    );
    // realms need to get closed, this is why all realms get their own name
    // and thus their own path.
    // After all test are run, the tearDownAll() function will
    // close all realms.
    realms.add(realm);
    return realm;
  }

  static RealmDbProjectsRepository makeRealmProjectsRepoInstance(
    Realm realm,
  ) =>
      RealmDbProjectsRepository(realm);
}
