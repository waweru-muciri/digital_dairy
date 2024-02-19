import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkConsumersStatementsScreen extends StatefulWidget {
  const MilkConsumersStatementsScreen(
      {super.key, required this.milkConsumerId});
  static const routePath = '/milk_consumers_statements/:milkConsumerId';
  final String milkConsumerId;

  @override
  State<StatefulWidget> createState() => MilkConsumersStatementsScreenState();
}

class MilkConsumersStatementsScreenState
    extends State<MilkConsumersStatementsScreen> {
  late List<MilkConsumption> _milkSalesList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  MilkConsumer? selectedMilkConsumer;

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
    selectedMilkConsumer = context
        .read<MilkConsumerController>()
        .milkConsumersList
        .firstWhereOrNull(
            (milkconsumer) => milkconsumer.getId == widget.milkConsumerId);

    _milkSalesList =
        context.watch<MilkConsumptionController>().milkConsumptionsList;

    _dataTableSource.setData(
        _milkSalesList, _sortColumnIndex, _sortColumnAscending);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Milk Consumer Statement',
          ),
        ),
        drawer: const MyDrawer(),
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
                                      .read<MilkConsumptionController>()
                                      .filterMilkConsumptionsByDatesAndMilkConsumerId(
                                          startDate,
                                          endDate,
                                          widget.milkConsumerId);
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
                                  "Consumer Name:",
                                  selectedMilkConsumer?.getMilkConsumerName ??
                                      "No Consumer found!"),
                              summaryTextDisplayRow("Total Quantity Sold:",
                                  "${context.read<MilkConsumptionController>().getTotalMilkConsumptionKgsAmount} Kgs"),
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
                    ],
                    source: _dataTableSource)
              ]),
        )));
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  _DataSource({required this.context});

  late List<MilkConsumption> sortedData = [];

  void setData(
      List<MilkConsumption> rawData, int sortColumn, bool sortAscending) {
    sortedData = rawData
      ..sort((MilkConsumption a, MilkConsumption b) {
        late final Comparable<Object> cellA;
        late final Comparable<Object> cellB;
        switch (sortColumn) {
          case 0:
            cellA = a.getMilkConsumptionDate;
            cellB = b.getMilkConsumptionDate;
            break;
          case 1:
            cellA = a.getMilkConsumptionAmount;
            cellB = b.getMilkConsumptionAmount;
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
      DataCell(Text(item.getMilkConsumptionDate)),
      DataCell(Text('${item.getMilkConsumptionAmount}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sortedData.length;

  @override
  int get selectedRowCount => 0;
}
