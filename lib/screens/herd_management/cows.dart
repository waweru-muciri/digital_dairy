import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CowsScreen extends StatefulWidget {
  const CowsScreen({super.key, this.activeStatus, this.cowType});

  final String? activeStatus;
  final String? cowType;

  static const routeName = '/herd_management';

  @override
  State<StatefulWidget> createState() => CowsScreenState();
}

class CowsScreenState extends State<CowsScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daily Milk Production',
            style: TextStyle(),
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              Text('Milk data for today'),
            ]),
          ),
        ));
  }
}
