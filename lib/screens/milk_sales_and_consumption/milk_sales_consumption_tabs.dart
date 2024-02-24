import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumptions.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/milk_sales.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class MilkSalesConsumptionTabView extends StatelessWidget {
  const MilkSalesConsumptionTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            // dividerColor: Colors.transparent,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color.fromRGBO(0, 121, 107, 0.8),
                    style: BorderStyle.solid)),
            labelStyle: const TextStyle(
              fontSize: 16,
            ),
            tabs: [
              Tab(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    color: Color.fromRGBO(0, 121, 107, 0.1),
                  ),
                  child: const Text("Sales"),
                ),
              ),
              Tab(
                  child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  color: Color.fromRGBO(0, 121, 107, 0.1),
                ),
                child: const Text("Consumption"),
              )),
            ],
          ),
          title: const Text("Milk Sales & Consumption"),
        ),
        body: const TabBarView(
          children: [
            MilkSalesScreen(),
            MilkConsumptionsScreen(),
          ],
        ),
      ),
    );
  }
}
