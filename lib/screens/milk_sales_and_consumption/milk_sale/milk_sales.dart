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
  int _sortColumnIndex = 0;
  bool _sortColumnAscending = true;

  late _DataSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = _DataSource(context: context);
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

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortColumnAscending = ascending;
      _dataTableSource.setData(
          _milkSalesList, _sortColumnIndex, _sortColumnAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;
    _dataTableSource.setData(
        _milkSalesList, _sortColumnIndex, _sortColumnAscending);

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
                      summaryTextDisplayRow("Total Milk Sales Amount:",
                          "${context.read<MilkSaleController>().getTotalMilkSalesMoneyAmount} Ksh"),
                      summaryTextDisplayRow("Total Milk Sales Quantity:",
                          "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Kgs")
                    ],
                  )),
            )),
        PaginatedDataTable(
            header: const Text("Milk Sales List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortColumnAscending,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addMilkSaleDetails"),
                label: const Text("New"),
              ),
            ],
            columns: [
              DataColumn(label: const Text("Date"), onSort: _sort),
              const DataColumn(label: Text("Client Name")),
              DataColumn(
                  label: const Text("Quantity (Ltrs)"),
                  numeric: true,
                  onSort: _sort),
              DataColumn(
                  label: const Text("Amount (Ksh)"),
                  numeric: true,
                  onSort: _sort),
              const DataColumn(label: Text("Edit")),
              const DataColumn(label: Text("Delete")),
            ],
            source: _dataTableSource)
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  _DataSource({required this.context});

  late List<MilkSale> sortedData = [];

  void setData(List<MilkSale> rawData, int sortColumn, bool sortAscending) {
    sortedData = rawData
      ..sort((MilkSale a, MilkSale b) {
        late final Comparable<Object> cellA;
        late final Comparable<Object> cellB;
        switch (sortColumn) {
          case 0:
            cellA = a.getMilkSaleDate;
            cellB = b.getMilkSaleDate;
            break;
          case 2:
            cellA = a.getClient.getUnitPrice;
            cellB = b.getClient.getUnitPrice;
          case 3:
            cellA = a.getMilkSaleMoneyAmount;
            cellB = b.getMilkSaleMoneyAmount;
            break;
          default:
        }
        return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
      });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final item = sortedData[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkSaleDate)),
      DataCell(Text(item.getClient.clientName)),
      DataCell(Text('${item.getMilkSaleQuantity}')),
      DataCell(Text('${item.getMilkSaleMoneyAmount}')),
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
  int get rowCount => sortedData.length;

  @override
  int get selectedRowCount => 0;
}
