import 'package:DigitalDairy/screens/herd_management/cow-sales/cow_sales.dart';
import 'package:DigitalDairy/screens/herd_management/cows/cows.dart';
import 'package:DigitalDairy/screens/breeding_management/semen/semen_catalogs.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/my_tab.dart';
import 'package:flutter/material.dart';

class HerdManagementTabView extends StatelessWidget {
  const HerdManagementTabView({super.key});

  static const routePath = '/herd_management';

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
                text: "Cows",
              ),
              MyTab(
                text: "Cow Sales",
              ),
            ],
          ),
          title: const Text('Herd Management'),
        ),
        body: const TabBarView(
          children: [
            CowsScreen(),
            CowSalesScreen(),
          ],
        ),
      ),
    );
  }
}
