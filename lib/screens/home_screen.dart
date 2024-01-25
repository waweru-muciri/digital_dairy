import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
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
  late List<DailyMilkProduction> _milkProductionList;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
    _milkProductionDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkProductionList =
        context.watch<DailyMilkProductionController>().dailyMilkProductionsList;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(),
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
