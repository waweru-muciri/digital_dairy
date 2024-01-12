import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:DigitalDairy/models/expense.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  static const routePath = '/expenses';

  @override
  State<StatefulWidget> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  late List<Expense> _expensesList;
  final TextEditingController _cowNameController = TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<ExpenseController>()
        .filterExpenseByDates(getStringFromDate(DateTime.now())));
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Card(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: FilterInputField(
                                      onQueryChanged: context
                                          .read<ExpenseController>()
                                          .filterExpenses)),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Filter',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 10, 0, 10),
                                                          child: TextFormField(
                                                            controller:
                                                                _fromDateFilterController,
                                                            readOnly: true,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'From Date',
                                                              suffixIcon: IconButton(
                                                                  onPressed: () async {
                                                                    final DateTime?
                                                                        pickedDateTime =
                                                                        await selectDate(
                                                                            context,
                                                                            getDateFromString(_fromDateFilterController.text));
                                                                    _fromDateFilterController
                                                                            .text =
                                                                        getStringFromDate(
                                                                            pickedDateTime);
                                                                  },
                                                                  icon: const Align(
                                                                      widthFactor: 1.0,
                                                                      heightFactor: 1.0,
                                                                      child: Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                      ))),
                                                            ),
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 10, 0, 10),
                                                          child: TextFormField(
                                                            controller:
                                                                _toDateFilterController,
                                                            readOnly: true,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'To Date',
                                                              suffixIcon: IconButton(
                                                                  onPressed: () async {
                                                                    final DateTime?
                                                                        pickedDateTime =
                                                                        await selectDate(
                                                                            context,
                                                                            getDateFromString(_toDateFilterController.text));

                                                                    _toDateFilterController
                                                                            .text =
                                                                        getStringFromDate(
                                                                            pickedDateTime);
                                                                  },
                                                                  icon: const Align(
                                                                      widthFactor: 1.0,
                                                                      heightFactor: 1.0,
                                                                      child: Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                      ))),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                ButtonBar(
                                                  alignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    FilledButton(
                                                        child:
                                                            const Text('Reset'),
                                                        onPressed: () {
                                                          _fromDateFilterController
                                                              .clear();
                                                          _toDateFilterController
                                                              .clear();
                                                        }),
                                                    FilledButton(
                                                        child: const Text(
                                                            'Apply Filters'),
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  ExpenseController>()
                                                              .filterExpenseByDates(
                                                                  _fromDateFilterController
                                                                      .text,
                                                                  endDate:
                                                                      _toDateFilterController
                                                                          .text);
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            )
                          ],
                        )))),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Total Income Amount",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                "Ksh: ${context.watch<ExpenseController>().getTotalExpenses}"),
                          )
                        ]),
                      ],
                    )),
              )),
          PaginatedDataTable(
              header: const Text("Expenses List"),
              rowsPerPage: 20,
              availableRowsPerPage: const [20, 30, 50],
              sortAscending: false,
              sortColumnIndex: 0,
              actions: <Widget>[
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.pushNamed("addExpenseDetails"),
                  label: const Text("Add Expense"),
                )
              ],
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
