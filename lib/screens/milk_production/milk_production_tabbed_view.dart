import 'package:DigitalDairy/screens/milk_production/daily_milk_production.dart';
import 'package:DigitalDairy/screens/milk_production/monthly_milk_production.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/my_tab.dart';
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
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color.fromRGBO(0, 121, 107, 0.8))),
            labelStyle: const TextStyle(
              fontSize: 16,
            ),
            tabs: const [
              MyTab(
                text: "Daily Milk Production",
              ),
              MyTab(
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
