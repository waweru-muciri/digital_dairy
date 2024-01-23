import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/screens/clients_consumers_statements/clients_sales_charts.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:fl_chart/fl_chart.dart';

class ClientsMilkSalesStatementsScreen extends StatefulWidget {
  const ClientsMilkSalesStatementsScreen({super.key});
  static const routePath = '/client_milk_sales_statements';

  @override
  State<StatefulWidget> createState() =>
      ClientsMilkSalesStatementsScreenState();
}

class ClientsMilkSalesStatementsScreenState
    extends State<ClientsMilkSalesStatementsScreen> {
  late List<MilkSale> _milkSalesList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _clientController = TextEditingController();
  late List<Client> _clientsList;
  Client? selectedClient;

  int _sortColumnIndex = 0;
  bool _sortColumnAscending = true;

  late _DataSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = _DataSource(context: context);
    //get the list of clients
    Future.microtask(() => context.read<ClientController>().getClients());
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

  Future<void> showDatesAndClientFilterBottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Filter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: DropdownMenu<Client>(
                  label: const Text("Select Client"),
                  controller: _clientController,
                  requestFocusOnTap: true,
                  initialSelection: selectedClient,
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (Client? client) {
                    setState(() {
                      selectedClient = client;
                    });
                  },
                  enableFilter: true,
                  enableSearch: true,
                  inputDecorationTheme: const InputDecorationTheme(
                      isDense: true, border: OutlineInputBorder()),
                  dropdownMenuEntries: _clientsList
                      .map<DropdownMenuEntry<Client>>((Client client) {
                    return DropdownMenuEntry<Client>(
                      value: client,
                      label: client.clientName,
                      enabled: true,
                    );
                  }).toList(),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextFormField(
                              controller: _fromDateFilterController,
                              readOnly: true,
                              decoration: InputDecoration(
                                isDense: true,
                                border: const OutlineInputBorder(),
                                labelText: 'From Date',
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      final DateTime? pickedDateTime =
                                          await showCustomDatePicker(
                                              context,
                                              getDateFromString(
                                                  _fromDateFilterController
                                                      .text));
                                      _fromDateFilterController.text =
                                          getStringFromDate(pickedDateTime);
                                    },
                                    icon: const Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(
                                          Icons.calendar_month,
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
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextFormField(
                              controller: _toDateFilterController,
                              readOnly: true,
                              decoration: InputDecoration(
                                isDense: true,
                                border: const OutlineInputBorder(),
                                labelText: 'To Date',
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      final DateTime? pickedDateTime =
                                          await showCustomDatePicker(
                                              context,
                                              getDateFromString(
                                                  _toDateFilterController
                                                      .text));

                                      _toDateFilterController.text =
                                          getStringFromDate(pickedDateTime);
                                    },
                                    icon: const Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(
                                          Icons.calendar_month,
                                        ))),
                              ),
                            )),
                      ),
                    ],
                  )),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      child: const Text('Reset'),
                      onPressed: () {
                        _fromDateFilterController.clear();
                        _toDateFilterController.clear();
                        setState(() {
                          selectedClient = null;
                        });
                      }),
                  FilledButton(
                      child: const Text('Apply Filters'),
                      onPressed: () {
                        if (selectedClient != null) {
                          context
                              .read<MilkSaleController>()
                              .filterMilkSalesByDatesAndClientId(
                                  _fromDateFilterController.text,
                                  _fromDateFilterController.text,
                                  '${selectedClient!.getId}');
                        } else {
                          context
                              .read<MilkSaleController>()
                              .filterMilkSalesByDates(
                                  _fromDateFilterController.text,
                                  endDate: _fromDateFilterController.text);
                        }
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;
    _clientsList = context.watch<ClientController>().clientsList;

    _dataTableSource.setData(
        _milkSalesList, _sortColumnIndex, _sortColumnAscending);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Client Statements',
            style: TextStyle(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_list,
              ),
              onPressed: () {
                showDatesAndClientFilterBottomSheet();
              },
            )
          ],
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(
                    '${_fromDateFilterController.text} - ${_toDateFilterController.text}',
                    textAlign: TextAlign.right,
                  ),
                ),
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
                                  selectedClient != null
                                      ? selectedClient!.clientName
                                      : "All Clients"),
                              summaryTextDisplayRow("Total Quantity Sold:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Kgs"),
                              summaryTextDisplayRow("Total Quantity Sold:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesMoneyAmount} Ksh"),
                              summaryTextDisplayRow("Total Payments:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Ksh"),
                              summaryTextDisplayRow("Outstanding Balances:",
                                  "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Ksh"),
                            ],
                          )),
                    )),
                const LineChartSample2(),
                PaginatedDataTable(
                    rowsPerPage: 20,
                    availableRowsPerPage: const [20, 30, 50],
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortColumnAscending,
                    columns: [
                      DataColumn(
                          label: const Text("Client Name"), onSort: _sort),
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
      DataCell(Text(item.getClient.clientName)),
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
