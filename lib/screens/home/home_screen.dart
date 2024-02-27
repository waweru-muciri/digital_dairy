import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/controllers/year_milk_production_controller.dart';
import 'package:DigitalDairy/controllers/year_milk_sales_controller.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/screens/home/year_milk_production_chart.dart';
import 'package:DigitalDairy/screens/home/year_milk_sales_chart.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/';

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _milkProductionDateController =
      TextEditingController(text: getTodaysDateAsString());
  late TextEditingController _cowNameController;

  late Map<int, double> yearMilkProductionChartList;
  late Map<int, double> yearChartMilkSaleList;
  late int filterYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
    Future.microtask(() => context
        .read<YearMilkProductionController>()
        .getYearMonthlyMilkProductions(year: filterYear));
    Future.microtask(() => context
        .read<YearMilkSalesController>()
        .getYearMonthlyMilkSales(year: filterYear));
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
    _milkProductionDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> todaysTotalMilkProductionInfo = context
        .watch<DailyMilkProductionController>()
        .getTotalDayMilkProductionInfo();

    double todaysMilkSalesKgsAmount =
        context.watch<MilkSaleController>().getTotalMilkSalesKgsAmount;

    double todaysMilkConsumptionKgsAmount = context
        .watch<MilkConsumptionController>()
        .getTotalMilkConsumptionKgsAmount;

    double todaysMilkSalesMoneyAmount =
        context.watch<MilkSaleController>().getTotalMilkSalesMoneyAmount;

    yearMilkProductionChartList =
        context.watch<YearMilkProductionController>().yearMilkProductionsList;

    yearChartMilkSaleList =
        context.watch<YearMilkSalesController>().yearYearMilkSalesList;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Overview',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Summary")),
                                Expanded(
                                  child: Text(getTodaysDateAsString()),
                                )
                              ],
                            ),
                          ),
                          Row(children: [
                            Expanded(
                                child: Column(
                              children: [
                                const Text("Milk Production"),
                                Text(
                                    '${todaysTotalMilkProductionInfo['total_quantity']?.toStringAsFixed(2) ?? ''} Kgs'),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                const Text("Milk Sales"),
                                Text(
                                    '${todaysMilkSalesKgsAmount.toStringAsFixed(2)} Kgs'),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                const Text("Milk Sales"),
                                Text(
                                    '${todaysMilkSalesMoneyAmount.toStringAsFixed(2)} Kshs'),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                const Text("Milk Consumption"),
                                Text(
                                    '${todaysMilkConsumptionKgsAmount.toStringAsFixed(2)} Kgs'),
                              ],
                            ))
                          ])
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(children: [
                      Text(
                        "Income",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.start,
                      ),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(children: [
                      Text(
                        "Expenses",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.start,
                      ),
                    ]),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Column(children: [
                        Text(
                          "Year Milk Production Graph",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.start,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                                margin: const EdgeInsets.only(top: 40),
                                child: YearMilkProductionChart(
                                    yearMilkProductionList:
                                        yearMilkProductionChartList))),
                      ])),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(children: [
                      Text(
                        "Year Milk Sales Graph",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.start,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: YearMilkSalesChart(
                                  yearMilkSalesList: yearChartMilkSaleList))),
                    ]),
                  ),
                ]))));
  }
}
