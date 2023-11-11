// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:uuid/uuid.dart' as uuid;

class ProjectEntity {
  ProjectEntity({
    required this.name,
    required this.groupId,
    required this.isFavorite,
  }) : id = const uuid.Uuid().v1();
  final String id;
  final String name;
  final String groupId;
  final bool isFavorite;
}

class ProjectWithSettingsEntity extends ProjectEntity {
  ProjectWithSettingsEntity({
    required super.name,
    required super.groupId,
    required this.sickDaysPayment,
    required this.publicHolidaysPayment,
    required this.vacationInfo,
    required this.timeManagement,
    required this.moneyManagement,
    required this.workplace,
  }) : super(isFavorite: false);

  final PaymentStatus? sickDaysPayment;
  final PaymentStatus? publicHolidaysPayment;
  final VacationEntity? vacationInfo;
  final ProjectTimeManagementEntity? timeManagement;
  final ProjectMoneyManagementEntity? moneyManagement;
  final Workplace? workplace;

  @override
  String toString() {
    return '''ProjectWithSettingsEntity(sickDaysPayment: $sickDaysPayment, publicHolidaysPayment: $publicHolidaysPayment, vacationInfo: $vacationInfo, timeManagement: $timeManagement, moneyManagement: $moneyManagement, workplace: $workplace)''';
  }
}
