import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:DigitalDairy/models/expense.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  static const routeName = '/expenses';

  @override
  State<StatefulWidget> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  late List<Expense> _expensesList;
  final TextEditingController _cowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ExpenseController>().getExpenses());
  }

  @override
  void dispose() {
    _cowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _expensesList = context.watch<ExpenseController>().expensesList;

    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              context.pushNamed("addExpenseDetails"),
                          label: const Text("Add Expense"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    FilterInputField(
                        onQueryChanged:
                            context.read<ExpenseController>().filterExpenses),
                  ],
                ),
              ),
              PaginatedDataTable(
                  header: const Text("Expenses List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  sortAscending: false,
                  sortColumnIndex: 0,
                  columns: const [
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Amount (Ksh)"), numeric: true),
                    DataColumn(label: Text("Details")),
                    DataColumn(label: Text("Edit")),
                    DataColumn(label: Text("Delete")),
                  ],
                  source: _DataSource(data: _expensesList, context: context))
            ]),
          ),
        ));
  }
}

class _DataSource extends DataTableSource {
  final List<Expense> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(DateFormat("dd/MM/yyyy").format(item.getExpenseDate))),
      DataCell(Text('${item.getExpenseAmount}')),
      DataCell(Text(item.getDetails)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editExpenseDetails",
              pathParameters: {"editExpenseId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<ExpenseController>().deleteExpense(item);
        }

        await showDeleteItemDialog(context, deleteFunc);
      }),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
