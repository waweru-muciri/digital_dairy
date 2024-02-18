import 'package:DigitalDairy/screens/breeding_management/abortions_miscarriages/abortion_miscarriages.dart';
import 'package:DigitalDairy/screens/breeding_management/pregnancy_diagnosis/pregnancy_diagnosis.dart';
import 'package:DigitalDairy/screens/breeding_management/semen/semen_catalogs.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class BreedingManagementTabView extends StatelessWidget {
  const BreedingManagementTabView({super.key});

  static const routePath = '/breeding_management';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "Semen Catalog",
              ),
              Tab(
                text: "AI Records",
              ),
              Tab(
                text: "Pregnancies",
              ),
              Tab(
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
          ],
        ),
      ),
    );
  }
}
