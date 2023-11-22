class DailyMilkProduction {
  late final String id;
  late final double amQuantity;
  late final double noonQuantity;
  late final double pmQuantity;
  late final DateTime milkProductionDate;

  DailyMilkProduction(
      {this.amQuantity = 0,
      this.noonQuantity = 0,
      this.pmQuantity = 0,
      required this.id,
      required this.milkProductionDate});

  double get totalMilkQuantity => (amQuantity + noonQuantity + pmQuantity);
}
