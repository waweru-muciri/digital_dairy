import 'package:DigitalDairy/controllers/income_controller.dart';
import 'package:DigitalDairy/models/income.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({super.key});
  static const routePath = '/incomes';

  @override
  State<StatefulWidget> createState() => IncomeScreenState();
}

class IncomeScreenState extends State<IncomesScreen> {
  late List<Income> _expensesList;
  final TextEditingController _cowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<IncomeController>().getIncomes());
  }

  @override
  void dispose() {
    _cowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _expensesList = context.watch<IncomeController>().incomesList;

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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          context.pushNamed("addIncomeDetails"),
                                      label: const Text("Add Income"),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: FilterInputField(
                                    onQueryChanged: context
                                        .read<IncomeController>()
                                        .filterIncomes)),
                          ],
                        )))),
          ),
          PaginatedDataTable(
              header: const Text("Incomes List"),
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
  final List<Income> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(DateFormat("dd/MM/yyyy").format(item.getIncomeDate))),
      DataCell(Text('${item.getIncomeAmount}')),
      DataCell(Text(item.getDetails)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editIncomeDetails",
              pathParameters: {"editIncomeId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<IncomeController>().deleteIncome(item);
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
