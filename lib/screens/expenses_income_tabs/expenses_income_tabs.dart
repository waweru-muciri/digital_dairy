import 'package:DigitalDairy/screens/expenses_income_tabs/expenses/expenses.dart';
import 'package:DigitalDairy/screens/expenses_income_tabs/income/incomes.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
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
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Expenses",
              ),
              Tab(
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
