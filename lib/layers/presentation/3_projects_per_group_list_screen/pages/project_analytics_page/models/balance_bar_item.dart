class BalanceBarItem {
  final String label;
  final double desiredValue;

  final double value;
  final String valueLabel;

  BalanceBarItem({
    required this.desiredValue,
    required this.value,
    required this.label,
    required this.valueLabel,
  });
}
