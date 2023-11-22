class DailyMilkProduction {
  late String? id;
  late final double amQuantity;
  late final double noonQuantity;
  late final double pmQuantity;
  late final DateTime milkProductionDate;

  DailyMilkProduction(
      {this.amQuantity = 0,
      this.noonQuantity = 0,
      this.pmQuantity = 0,
      this.id,
      required this.milkProductionDate});

  DailyMilkProduction.fromJson(Map<String, Object?> json)
      : this(
          milkProductionDate: json['milkProductionDate']! as DateTime,
          amQuantity: json["amQuantity"]! as double,
          noonQuantity: json["noonQuantity"]! as double,
          pmQuantity: json["pmQuantity"]! as double,
          id: json["id"]! as String,
        );
  Map<String, Object?> toJson() {
    return {
      'milkProductionDate': milkProductionDate,
      'amQuantity': amQuantity,
      'noonQuantity': noonQuantity,
      'pmQuantity': pmQuantity,
      "id": id,
    };
  }

  double get totalMilkQuantity => (amQuantity + noonQuantity + pmQuantity);
}
