import 'package:DigitalDairy/screens/health_management/diseases/diseases.dart';
import 'package:DigitalDairy/screens/health_management/treatments/treatments.dart';
import 'package:DigitalDairy/screens/health_management/vaccinations/vaccinations.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/my_tab.dart';
import 'package:flutter/material.dart';

class HealthManagementTabView extends StatelessWidget {
  const HealthManagementTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
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
                text: "Diseases",
              ),
              MyTab(
                text: "Vaccinations",
              ),
              MyTab(
                text: "Treatments",
              ),
              MyTab(
                text: "Cow Deaths",
              ),
            ],
          ),
          title: const Text('Health Management'),
        ),
        body: const TabBarView(
          children: [
            DiseasesScreen(),
            VaccinationsScreen(),
            TreatmentsScreen(),
            Text("Cow Deaths")
          ],
        ),
      ),
    );
  }
}
