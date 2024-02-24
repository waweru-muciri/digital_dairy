import 'package:DigitalDairy/controllers/year_milk_production_controller.dart';
import 'package:DigitalDairy/screens/home/year_milk_production_chart.dart';
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

  late Map<int, double> yearMilkProductionList;
  late int filterYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
    Future.microtask(() => context
        .read<YearMilkProductionController>()
        .getYearMonthlyMilkProductions(year: filterYear));
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
    _milkProductionDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    yearMilkProductionList = context
        .watch<YearMilkProductionController>()
        .yearYearMilkProductionsList;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(),
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Year Milk Production Graph",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: YearMilkProductionChart(
                              yearMilkProductionList: yearMilkProductionList))),
                ]),
              )
            ],
          ),
        )));
  }
}
