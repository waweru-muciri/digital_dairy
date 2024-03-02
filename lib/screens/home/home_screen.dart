import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/controllers/year_milk_production_controller.dart';
import 'package:DigitalDairy/controllers/year_milk_sales_controller.dart';
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

  Text summaryTitleText(String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.start,
    );
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

    Widget dataSummaryRowItem(String labelText, String labelData) {
      return Card(
        margin: const EdgeInsets.only(right: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(labelText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  labelData,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
    }

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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: summaryTitleText(
                                  "Today's Summary",
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 0),
                                children: [
                                  dataSummaryRowItem("Milk Production",
                                      '${todaysTotalMilkProductionInfo['total_quantity']?.toStringAsFixed(2) ?? ''} Kgs'),
                                  dataSummaryRowItem("Milk Sales",
                                      '${todaysMilkSalesKgsAmount.toStringAsFixed(2)} Kgs'),
                                  dataSummaryRowItem("Milk Sales",
                                      '${todaysMilkSalesMoneyAmount.toStringAsFixed(2)} Kshs'),
                                  dataSummaryRowItem("Milk Payments",
                                      '${todaysMilkSalesMoneyAmount.toStringAsFixed(2)} Kshs'),
                                  dataSummaryRowItem("Milk Consumption",
                                      '${todaysMilkConsumptionKgsAmount.toStringAsFixed(2)} Kgs'),
                                ]),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: summaryTitleText(
                                  "Herd Details",
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 0),
                                    children: [
                                      dataSummaryRowItem("Calves", '0'),
                                      dataSummaryRowItem("Weaners", '0'),
                                      dataSummaryRowItem("Heifers", '0'),
                                      dataSummaryRowItem("Bullings", '0'),
                                      dataSummaryRowItem("Yearlings", '0'),
                                      dataSummaryRowItem("In-Calfs", '0'),
                                      dataSummaryRowItem("Milkers", '0'),
                                      dataSummaryRowItem("Drys", '0'),
                                      dataSummaryRowItem("Bulls", '0'),
                                      dataSummaryRowItem("Total Active", '0'),
                                    ]),
                              ),
                            ]),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: summaryTitleText(
                                      "Year Milk Production",
                                    )),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 40),
                                        child: YearMilkProductionChart(
                                            yearMilkProductionList:
                                                yearMilkProductionChartList))),
                              ])),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: summaryTitleText(
                                    "Year Milk Sales",
                                  )),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 40),
                                      child: YearMilkSalesChart(
                                          yearMilkSalesList:
                                              yearChartMilkSaleList))),
                            ]),
                      ),
                    ]))));
  }
}
