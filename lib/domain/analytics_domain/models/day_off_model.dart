class DayOffModel {
  DayOffModel({
    required this.isSick,
    required this.isVacation,
    required this.isPublicHoliday,
  });

  final bool isSick;
  final bool isVacation;
  final bool isPublicHoliday;
  bool get isMultiple {
    final trueCount =
        [isSick, isVacation, isPublicHoliday].where((b) => b).length;
    return trueCount > 1;
  }
}
