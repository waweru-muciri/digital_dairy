import 'package:DigitalDairy/screens/milk_production/daily_milk_production.dart';
import 'package:DigitalDairy/screens/milk_production/monthly_milk_production.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class MilkProductionTabView extends StatelessWidget {
  const MilkProductionTabView({super.key});
  static const routePath = "/milk_production";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(
                text: "Daily Milk Production",
              ),
              Tab(
                text: "Monthly Milk Production",
              ),
            ],
          ),
          title: const Text('Milk Production'),
        ),
        body: const TabBarView(
          children: [
            DailyMilkProductionScreen(),
            MonthlyMilkProductionScreen(),
          ],
        ),
      ),
    );
  }
}
