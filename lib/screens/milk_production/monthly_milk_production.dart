import 'package:DigitalDairy/controllers/monthly_milk_production_controller.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MonthlyMilkProductionScreen extends StatefulWidget {
  const MonthlyMilkProductionScreen({super.key});

  static const routePath = '/monthly_milk_production';

  @override
  State<StatefulWidget> createState() => MonthlyMilkProductionScreenState();
}

class MonthlyMilkProductionScreenState
    extends State<MonthlyMilkProductionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      )))),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      summaryTextDisplayRow("Total Am Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalAmMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Noon Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalNoonMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Pm Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalPmMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalMilkProductionQuantity} Kgs"),
                    ],
                  )),
            )),
      ]),
    )));
  }
}
