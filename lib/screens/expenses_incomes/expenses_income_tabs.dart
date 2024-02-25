import 'package:DigitalDairy/screens/expenses_incomes/expenses/expenses.dart';
import 'package:DigitalDairy/screens/expenses_incomes/income/incomes.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/my_tab.dart';
import 'package:flutter/material.dart';

class ExpensesIncomesTabView extends StatelessWidget {
  const ExpensesIncomesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
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
                text: "Expenses",
              ),
              MyTab(
                text: "Incomes",
              ),
            ],
          ),
          title: const Text('Expenses & Incomes'),
        ),
        body: const TabBarView(
          children: [
            ExpensesScreen(),
            IncomesScreen(),
          ],
        ),
      ),
    );
  }
}
