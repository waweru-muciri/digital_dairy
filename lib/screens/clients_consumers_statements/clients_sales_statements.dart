import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});
  static const routePath = '/client_milk_sales_statements';

  @override
  State<StatefulWidget> createState() => MilkSalesScreenState();
}

class MilkSalesScreenState extends State<MilkSalesScreen> {
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

  @override
  Widget build(BuildContext context) {
    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;
    _clientsList = context.watch<ClientController>().clientsList;

    _dataTableSource.setData(
        _milkSalesList, _sortColumnIndex, _sortColumnAscending);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Client Milk Sales Statements',
            style: TextStyle(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_list,
              ),
              onPressed: () {
                showDatesFilterBottomSheet(
                    context,
                    _fromDateFilterController,
                    _toDateFilterController,
                    context.read<MilkSaleController>().filterMilkSalesByDates);
              },
            )
          ],
        ),
        drawer: const MyDrawer(),
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
                                  child: DropdownMenu<Client>(
                                    controller: _clientController,
                                    requestFocusOnTap: true,
                                    initialSelection: selectedClient,
                                    expandedInsets: EdgeInsets.zero,
                                    onSelected: (Client? client) {
                                      setState(() {
                                        selectedClient = client;
                                      });
                                    },
                                    errorText: selectedClient == null
                                        ? 'Client cannot be empty!'
                                        : null,
                                    enableFilter: true,
                                    enableSearch: true,
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                            isDense: true,
                                            border: OutlineInputBorder()),
                                    dropdownMenuEntries: _clientsList
                                        .map<DropdownMenuEntry<Client>>(
                                            (Client client) {
                                      return DropdownMenuEntry<Client>(
                                        value: client,
                                        label: client.clientName,
                                        enabled: true,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: FilledButton(
                                      child: const Text("Search"),
                                      onPressed: () {
                                        if (selectedClient != null) {
                                          String clientId =
                                              '${selectedClient!.getId}';
                                          context
                                              .read<MilkSaleController>()
                                              .filterMilkSalesByClientId(
                                                  clientId);
                                        }
                                      })),
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
                          summaryTextDisplayRow("Total Quantity Sold:",
                              "${context.read<MilkSaleController>().getTotalMilkSalesKgsAmount} Kgs"),
                          summaryTextDisplayRow("Total Milk Sales:",
                              "${context.read<MilkSaleController>().getTotalMilkSalesMoneyAmount} Ksh"),
                        ],
                      )),
                )),
            PaginatedDataTable(
                header: const Text("Milk Sales List"),
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
      DataCell(Text('${item.getMilkSaleQuantity}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sortedData.length;

  @override
  int get selectedRowCount => 0;
}
