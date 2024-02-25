import 'package:DigitalDairy/controllers/monthly_milk_production_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/screens/milk_production/month_milk_production_chart.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/month_filter_dialog.dart';
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
  late Map<int, double> yearMilkProductionList;
  late List<Map<String, dynamic>> totalMonthMilkProductionGroupedByCow;
  late int filterMonth = DateTime.now().month;
  late int filterYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MonthlyMilkProductionController>()
        .getMonthDailyMilkProductions(year: filterYear, month: filterMonth));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalMonthMilkProductionGroupedByCow = context
        .watch<MonthlyMilkProductionController>()
        .allCowsTotalMonthMilkProductionList;

    double monthTotalAmMilkProduction = context
        .read<MonthlyMilkProductionController>()
        .getTotalAmMilkProductionQuantity;
    double monthTotalNoonMilkProduction = context
        .read<MonthlyMilkProductionController>()
        .getTotalNoonMilkProductionQuantity;
    double monthTotalPmMilkProduction = context
        .read<MonthlyMilkProductionController>()
        .getTotalPmMilkProductionQuantity;
    double monthTotalMilkProduction = monthTotalAmMilkProduction +
        monthTotalNoonMilkProduction +
        monthTotalPmMilkProduction;

    double cowsAverageMonthMilkProduction = monthTotalMilkProduction /
        context
            .read<MonthlyMilkProductionController>()
            .allCowsTotalMonthMilkProductionList
            .length;

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            await showDialog<Map<String, int>>(
                                context: context,
                                builder: (BuildContext context) {
                                  return FilterByDatesOrMonthDialog(
                                    initialYear: filterYear,
                                    initialMonth: filterMonth,
                                  );
                                }).then((value) {
                              if (value != null) {
                                int selectedFilterYear = value['year'] ?? 0;
                                int selectedFilterMonth = value['month'] ?? 0;
                                setState(() {
                                  filterYear = selectedFilterYear;
                                  filterMonth = selectedFilterMonth;
                                });
                                context
                                    .read<MonthlyMilkProductionController>()
                                    .getMonthDailyMilkProductions(
                                        year: selectedFilterYear,
                                        month: selectedFilterMonth);
                              }
                            });
                          },
                          child: Text(
                            "${namesOfMonthsInYearList.elementAt(filterMonth - 1)} - $filterYear",
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Month Summary",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        summaryTextDisplayRow("Total Am Quantity:",
                            "${monthTotalAmMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Noon Quantity:",
                            "${monthTotalNoonMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Pm Quantity:",
                            "${monthTotalPmMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Quantity:",
                            "${monthTotalMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Cow Average:",
                            "${cowsAverageMonthMilkProduction.toStringAsFixed(2)} Kgs"),
                      ],
                    ),
                  )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: PaginatedDataTable(
                          header: Text(
                            "Month Milk Production",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          rowsPerPage: 10,
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
                      child: Column(
                        children: [
                          Text(
                            "Month Milk Production Graph",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: DailyMilkProductionChart())),
                        ],
                      )),
                ]))));
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
