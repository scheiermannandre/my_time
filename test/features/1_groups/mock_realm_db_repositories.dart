import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

class MockRealmDbGroupsRepository extends Mock
    implements RealmDbGroupsRepository {}

class MockRealmDbProjectsRepository extends Mock
    implements RealmDbProjectsRepository {}
