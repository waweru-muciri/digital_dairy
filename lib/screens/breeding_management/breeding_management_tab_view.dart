import 'package:DigitalDairy/screens/breeding_management/abortions_miscarriages/abortion_miscarriages.dart';
import 'package:DigitalDairy/screens/breeding_management/pregnancy_diagnosis/pregnancy_diagnosis.dart';
import 'package:DigitalDairy/screens/breeding_management/semen/semen_catalogs.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/my_tab.dart';
import 'package:flutter/material.dart';

class BreedingManagementTabView extends StatelessWidget {
  const BreedingManagementTabView({super.key});

  static const routePath = '/breeding_management';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                text: "Semen Catalog",
              ),
              MyTab(
                text: "AI Records",
              ),
              MyTab(
                text: "Pregnancies",
              ),
              MyTab(
                text: "Calvings",
              ),
              MyTab(
                text: "Abortions/Miscarriages",
              ),
            ],
          ),
          title: const Text('Breeding Management'),
        ),
        body: const TabBarView(
          children: [
            SemenCatalogsScreen(),
            Text("AI Records"),
            PregnancyDiagnosisScreen(),
            AbortionMiscarriagesScreen(),
            Text("AI Records"),
          ],
        ),
      ),
    );
  }
}
