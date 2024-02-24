import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumptions.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/milk_sales.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/monthly_milk_sales.dart';
import 'package:DigitalDairy/screens/milk_sales_payments/milk_sales_payments.dart';
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
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
                color: const Color.fromRGBO(0, 121, 107, 1),
                borderRadius: BorderRadius.circular(20)),
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            // unselectedLabelColor: Colors.orange,
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text("Sales"),
                ),
              ),
              Tab(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Consumption"),
              )),
            ],
          ),
          title: const Text('Milk Sales & Consumption'),
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
