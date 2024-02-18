import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class ClientsMilkSalesStatementsScreen extends StatefulWidget {
  const ClientsMilkSalesStatementsScreen({super.key, required this.clientId});
  static const routePath = '/client_statements/:clientId';
  final String clientId;

  @override
  State<StatefulWidget> createState() =>
      ClientsMilkSalesStatementsScreenState();
}

class ClientsMilkSalesStatementsScreenState
    extends State<ClientsMilkSalesStatementsScreen> {
  late List<MilkSale> _milkSalesList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  Client? selectedClient;

  int _sortColumnIndex = 0;
  bool _sortColumnAscending = true;

  late _DataSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = _DataSource(context: context);
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
    selectedClient = context
        .read<ClientController>()
        .clientsList
        .firstWhereOrNull((client) => client.getId == widget.clientId);

    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;

    _dataTableSource.setData(
        _milkSalesList, _sortColumnIndex, _sortColumnAscending);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Client Statement',
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                            onTap: () async {
                              await showDatesFilterBottomSheet(
                                context,
                                _fromDateFilterController,
                                _toDateFilterController,
                              ).then((Map<String, String>?
                                  selectedDatesMap) async {
                                if (selectedDatesMap != null) {
                                  String startDate =
                                      selectedDatesMap['start_date'] ?? '';
                                  String endDate =
                                      selectedDatesMap['end_date'] ?? '';
                                  await context
                                      .read<MilkSaleController>()
                                      .filterMilkSalesByDatesAndClientId(
                                          startDate, endDate, widget.clientId);
                                }
                              });
                            },
                            child: Text(
                              '${_fromDateFilterController.text} - ${_toDateFilterController.text}',
                              textAlign: TextAlign.right,
                            ))
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              summaryTextDisplayRow(
                                  "Client Name:",
                                  selectedClient?.clientName ??
                                      "No client found!"),
                              summaryTextDisplayRow("Total Quantity Sold:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Kgs"),
                              summaryTextDisplayRow("Total Sales:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesMoneyAmount} Ksh"),
                              summaryTextDisplayRow("Total Payments:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Ksh"),
                              summaryTextDisplayRow("Outstanding Balances:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Ksh"),
                            ],
                          )),
                    )),
                PaginatedDataTable(
                    rowsPerPage: 20,
                    availableRowsPerPage: const [20, 30, 50],
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortColumnAscending,
                    columns: [
                      DataColumn(label: const Text("Date"), onSort: _sort),
                      DataColumn(
                          label: const Text("Milk Quantity (Kgs)"),
                          numeric: true,
                          onSort: _sort),
                      DataColumn(
                          label: const Text("Unit Price (Ksh)"),
                          numeric: true,
                          onSort: _sort),
                      DataColumn(
                          label: const Text("Sales Amount (Ksh)"),
                          numeric: true,
                          onSort: _sort),
                    ],
                    source: _dataTableSource)
              ]),
        )));
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
          case 1:
            cellA = a.getMilkSaleQuantity;
            cellB = b.getMilkSaleQuantity;
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
      DataCell(Text('${item.getMilkSaleQuantity}')),
      DataCell(Text('${item.getUnitPrice}')),
      DataCell(Text('${item.getMilkSaleMoneyAmount}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sortedData.length;

  @override
  int get selectedRowCount => 0;
}
