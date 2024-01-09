import 'package:DigitalDairy/screens/health_management/diseases/diseases.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumptions.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class HealthManagementTabView extends StatelessWidget {
  const HealthManagementTabView({super.key});

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
                text: "Diseases",
              ),
              Tab(
                text: "Consumption",
              ),
            ],
          ),
          title: const Text('Health Management'),
        ),
        body: const TabBarView(
          children: [
            DiseasesScreen(),
            MilkConsumptionsScreen(),
          ],
        ),
      ),
    );
  }
}
