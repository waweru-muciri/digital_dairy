import 'package:DigitalDairy/screens/herd_management/cows.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumptions.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class HerdManagementTabView extends StatelessWidget {
  const HerdManagementTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Cows",
              ),
              Tab(
                text: "Yes",
              ),
            ],
          ),
          title: const Text('Herd Management'),
        ),
        body: const TabBarView(
          children: [
            CowsScreen(),
            MilkConsumptionsScreen(),
          ],
        ),
      ),
    );
  }
}
