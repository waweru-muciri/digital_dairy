import 'package:DigitalDairy/controllers/monthly_milk_sales_controller.dart';
import 'package:DigitalDairy/controllers/year_milk_sales_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/month_milk_sales_chart.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/year_milk_sales_chart.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/month_filter_dialog.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyMilkSalesScreen extends StatefulWidget {
  const MonthlyMilkSalesScreen({super.key});

  static const routePath = '/monthly_milk_sales';

  @override
  State<StatefulWidget> createState() => MonthlyMilkSaleScreenState();
}

class MonthlyMilkSaleScreenState extends State<MonthlyMilkSalesScreen> {
  late List<Map<String, dynamic>> eachMonthMilkSalesGroupedByClient;
  late int filterMonth = DateTime.now().month;
  late int filterYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MonthlyMilkSaleController>()
        .getMonthMilkSales(year: filterYear, month: filterMonth));
    Future.microtask(() => context
        .read<YearMilkSalesController>()
        .getYearMonthlyMilkSales(year: filterYear));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    eachMonthMilkSalesGroupedByClient = context
        .watch<MonthlyMilkSaleController>()
        .allClientsTotalMonthMilkSaleList;

    double monthTotalMilkSalesMoneyAmount = context
        .read<MonthlyMilkSaleController>()
        .getTotalMonthMilkSalesMoneyAmount;
    double monthTotalMilkSaleQuantity = context
        .read<MonthlyMilkSaleController>()
        .getTotalMonthMilkSalesQuantity;
    double totalYearMilkSalesMoneyAmount = context
        .read<YearMilkSalesController>()
        .getTotalYearMilkSalesMoneyAmount;

    double averageMonthlyMilkSalesMoneyAmount = totalYearMilkSalesMoneyAmount /
        context.read<YearMilkSalesController>().yearYearMilkSalesList.length;

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
                                    .read<MonthlyMilkSaleController>()
                                    .getMonthMilkSales(
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
                        summaryTextDisplayRow("Total Quantity:",
                            "${monthTotalMilkSaleQuantity.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Sales:",
                            "${monthTotalMilkSalesMoneyAmount.toStringAsFixed(2)} Ksh"),
                        summaryTextDisplayRow("Year Sales:",
                            "${totalYearMilkSalesMoneyAmount.toStringAsFixed(2)} Ksh"),
                        summaryTextDisplayRow("Month Average:",
                            "${averageMonthlyMilkSalesMoneyAmount.toStringAsFixed(2)} Ksh"),
                      ],
                    ),
                  )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: PaginatedDataTable(
                          header: Text(
                            "Month Milk Sales",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          rowsPerPage: 10,
                          availableRowsPerPage: const [10],
                          columns: const [
                            DataColumn(label: Text("Client Name")),
                            DataColumn(label: Text("Milk Quantity (Kgs)")),
                            DataColumn(label: Text("Sales (Ksh)")),
                          ],
                          source: _DataSource(
                              data: eachMonthMilkSalesGroupedByClient,
                              context: context))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          Text(
                            "Month Milk Sales",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: MonthMilkSaleChart())),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Year Milk Sales",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: YearMilkSaleChart())),
                    ]),
                  )
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
    final client = item['client'] as Client;

    return DataRow(cells: [
      DataCell(Text(client.clientName)),
      DataCell(Text('${item['milk_quantity']}')),
      DataCell(Text('${item['money_amount']}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
