import 'package:realm/realm.dart'; // import realm package

part 'timer_data.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class $TimerData {
  late String id;
  late String projectId;
  late DateTime startTime;
  late DateTime endTime;
  late List<DateTime> breakStartTimes;
  late List<DateTime> breakEndTimes;
  late String timerState;
}
