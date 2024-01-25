import 'package:DigitalDairy/screens/consumers/milk_consumers.dart';
import 'package:DigitalDairy/screens/consumers/milk_consumers_statements.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class MilkConsumersTabView extends StatelessWidget {
  const MilkConsumersTabView({super.key});

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
                text: "Milk Consumers",
              ),
              Tab(
                text: "Milk Consumer Statements",
              ),
            ],
          ),
          title: const Text('Milk Consumers'),
        ),
        body: const TabBarView(
          children: [
            MilkConsumersScreen(),
            MilkConsumersStatementsScreen(),
          ],
        ),
      ),
    );
  }
}
