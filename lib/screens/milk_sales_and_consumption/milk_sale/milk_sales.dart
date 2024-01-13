import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});
  static const routePath = '/milk_sales';

  @override
  State<StatefulWidget> createState() => MilkSalesScreenState();
}

class MilkSalesScreenState extends State<MilkSalesScreen> {
  late List<MilkSale> _milkSalesList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MilkSaleController>()
        .filterMilkSalesByDates(getStringFromDate(DateTime.now())));
  }

  @override
  void dispose() {
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;

    return SingleChildScrollView(
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
                                        .read<MilkSaleController>()
                                        .filterMilkSalesByClientName)),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  onPressed: () {
                                    showDatesFilterBottomSheet(
                                        context,
                                        _fromDateFilterController,
                                        _toDateFilterController,
                                        context
                                            .read<MilkSaleController>()
                                            .filterMilkSalesByDates);
                                  })),
                        ],
                      )))),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      summaryTextDisplayRow("Total Milk Sales Amount",
                          "Ksh: ${context.read<MilkSaleController>().getTotalMilkSalesMoneyAmount}"),
                      summaryTextDisplayRow("Total Milk Sales Quantity",
                          "Kgs: ${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount}")
                    ],
                  )),
            )),
        PaginatedDataTable(
            header: const Text("Milk Sales List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addMilkSaleDetails"),
                label: const Text("New"),
              ),
            ],
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Client Name")),
              DataColumn(label: Text("Quantity (Ltrs)"), numeric: true),
              DataColumn(label: Text("Amount (Ksh)"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _milkSalesList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<MilkSale> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkSaleDate)),
      DataCell(Text(item.getClient.clientName)),
      DataCell(Text('${item.getMilkSaleAmount}')),
      DataCell(Text('${item.getMilkSaleAmount * item.getClient.getUnitPrice}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkSaleDetails",
              pathParameters: {"editMilkSaleId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<MilkSaleController>().deleteMilkSale(item);
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
