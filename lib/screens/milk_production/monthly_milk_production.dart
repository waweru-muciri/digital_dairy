import 'package:DigitalDairy/controllers/monthly_milk_production_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/screens/milk_production/month_milk_production_chart.dart';
import 'package:DigitalDairy/screens/milk_production/year_milk_production_chart.dart';
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
  late List<Map<String, dynamic>> totalMonthMilkProductionGroupedByCow;
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
        .watch<MonthlyMilkProductionController>()
        .monthDailyMilkProductionsList;

    totalMonthMilkProductionGroupedByCow = context
        .watch<MonthlyMilkProductionController>()
        .allCowsTotalMonthMilkProductionList;

    yearMilkProductionList = context
        .watch<MonthlyMilkProductionController>()
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
                        style: Theme.of(context).textTheme.headlineLarge,
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
        Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: PaginatedDataTable(
                header: const Text("Month Milk Production List"),
                rowsPerPage: 20,
                availableRowsPerPage: const [10],
                columns: const [
                  DataColumn(label: Text("Cow Name")),
                  DataColumn(label: Text("Am (Kgs)")),
                  DataColumn(label: Text("Noon (Kgs)")),
                  DataColumn(label: Text("Pm (Kgs)")),
                  DataColumn(label: Text("Total (Kgs)")),
                ],
                source: _DataSource(
                    data: totalMonthMilkProductionGroupedByCow,
                    context: context))),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                  width: 800,
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

class _DataSource extends DataTableSource {
  List<Map<String, dynamic>> data;
  final BuildContext context;

  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    final cow = item['cow'] as Cow;

    return DataRow(cells: [
      DataCell(Text(cow.getName)),
      DataCell(Text('${item['am_quantity']}')),
      DataCell(Text('${item['noon_quantity']}')),
      DataCell(Text('${item['pm_quantity']}')),
      DataCell(Text('${item['total_quantity']}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
