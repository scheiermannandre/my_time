// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:my_time/features/0_common/common_time_entry_model.dart';

class TimeEntryModel extends CommonTimeEntryModel {
  TimeEntryModel(
      {required super.projectId,
      required super.startTime,
      required super.endTime,
      required super.totalTime,
      required super.breakTime,
      required super.description});

  TimeEntryModel.factory(
      {required super.id,
      required super.projectId,
      required super.startTime,
      required super.endTime,
      required super.totalTime,
      required super.breakTime,
      required super.description})
      : super.factory();
}
