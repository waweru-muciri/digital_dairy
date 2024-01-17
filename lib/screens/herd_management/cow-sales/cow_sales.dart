import 'package:DigitalDairy/controllers/cow_sale_controller.dart';
import 'package:DigitalDairy/models/cow_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CowSalesScreen extends StatefulWidget {
  const CowSalesScreen({super.key});
  static const routePath = '/cow_sales';

  @override
  State<StatefulWidget> createState() => CowSalesScreenState();
}

class CowSalesScreenState extends State<CowSalesScreen> {
  late List<CowSale> _cowSaleList;
  final TextEditingController _cowSalesFilterController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CowSaleController>().getCowSales());
  }

  @override
  void dispose() {
    _cowSalesFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowSaleList = context.watch<CowSaleController>().cowSalesList;

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
                                        context.pushNamed("addCowSaleDetails"),
                                    label: const Text("New"),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<CowSaleController>()
                                      .filterCowSales)),
                        ],
                      )))),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.cowSalesList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Cow")),
              DataColumn(label: Text("Client Name")),
              DataColumn(label: Text("Cost"), numeric: true),
              DataColumn(label: Text("Remarks"), numeric: false),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _cowSaleList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<CowSale> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getCowSaleDate)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(Text(item.getClientName)),
      DataCell(Text('${item.getCowSaleCost}')),
      DataCell(Text(item.getRemarks)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editCowSaleDetails",
              pathParameters: {"editCowSaleId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<CowSaleController>().deleteCowSale(item);
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
