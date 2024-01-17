import 'package:DigitalDairy/screens/herd_management/cows.dart';
import 'package:DigitalDairy/screens/herd_management/semen/semen_catalogs.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
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
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Cows",
              ),
              Tab(
                text: "Semen Catalog",
              ),
            ],
          ),
          title: const Text('Herd Management'),
        ),
        body: const TabBarView(
          children: [
            CowsScreen(),
            SemenCatalogsScreen(),
          ],
        ),
      ),
    );
  }
}
