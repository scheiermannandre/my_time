class BalanceModel {
  BalanceModel({required this.actualTime, required this.expectedWorkTime});

  final Duration actualTime;
  final Duration expectedWorkTime;
  Duration get balance => actualTime - expectedWorkTime;
}
