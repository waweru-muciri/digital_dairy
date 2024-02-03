import 'package:DigitalDairy/controllers/monthly_milk_production_controller.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/screens/milk_production/month_milk_production_chart.dart';
import 'package:DigitalDairy/screens/milk_production/year_milk_production_chart.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyMilkProductionScreen extends StatefulWidget {
  const MonthlyMilkProductionScreen({super.key});

  static const routePath = '/monthly_milk_production';

  @override
  State<StatefulWidget> createState() => MonthlyMilkProductionScreenState();
}

class MonthlyMilkProductionScreenState
    extends State<MonthlyMilkProductionScreen> {
  late Map<String, double> monthDailyMilkProductionList;
  late Map<int, double> yearMilkProductionList;
  final DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MonthlyMilkProductionController>()
        .getMonthDailyMilkProductions(
            year: currentDate.year, month: currentDate.month));
    Future.microtask(() => context
        .read<MonthlyMilkProductionController>()
        .getYearMonthlyMilkProductions(year: currentDate.year));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cowsAverageMonthMilkProduction = context
            .read<MonthlyMilkProductionController>()
            .getTotalMilkProductionQuantity /
        context
            .read<MonthlyMilkProductionController>()
            .allCowsTotalMonthMilkProductionList
            .length;

    monthDailyMilkProductionList = context
        .read<MonthlyMilkProductionController>()
        .monthDailyMilkProductionsList;

    yearMilkProductionList = context
        .read<MonthlyMilkProductionController>()
        .yearMonthlyMilkProductionsList;

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Month Summary",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      summaryTextDisplayRow("Total Am Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalAmMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Noon Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalNoonMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Pm Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalPmMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Total Quantity:",
                          "${context.read<MonthlyMilkProductionController>().getTotalMilkProductionQuantity} Kgs"),
                      summaryTextDisplayRow("Cow Average:",
                          "$cowsAverageMonthMilkProduction Kgs"),
                    ],
                  )),
            )),
        // PaginatedDataTable(
        //   header: const Text("Month Milk Production List"),
        //   rowsPerPage: 20,
        //   availableRowsPerPage: const [10],
        //   columns: const [
        //     DataColumn(label: Text("Cow Name")),
        //     DataColumn(label: Text("Am")),
        //     DataColumn(label: Text("Noon")),
        //     DataColumn(label: Text("Pm")),
        //     DataColumn(label: Text("Total (Kgs)")),
        //   ],
        //   source: _DataSource(data: _milkProductionList, context: context)),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                  width: 700,
                  height: 400,
                  child: DailyMilkProductionChart(
                      monthDailyMilkProductionList:
                          monthDailyMilkProductionList))),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                  width: 700,
                  height: 400,
                  child: YearMilkProductionChart(
                      yearMilkProductionList: yearMilkProductionList))),
        ),
      ]),
    )));
  }
}
