import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkConsumptionsScreen extends StatefulWidget {
  const MilkConsumptionsScreen({super.key});
  static const routePath = '/consumer_milk_consumption_statements';

  @override
  State<StatefulWidget> createState() => MilkConsumptionsScreenState();
}

class MilkConsumptionsScreenState extends State<MilkConsumptionsScreen> {
  late List<MilkConsumption> _milkConsumptionsList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _milkConsumerController = TextEditingController();
  late List<MilkConsumer> _milkConsumersList;
  MilkConsumer? selectedMilkConsumer;

  int _sortColumnIndex = 0;
  bool _sortColumnAscending = true;

  late _DataSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = _DataSource(context: context);
    //get the list of milkConsumers
    Future.microtask(
        () => context.read<MilkConsumerController>().getMilkConsumers());
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
          _milkConsumptionsList, _sortColumnIndex, _sortColumnAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    _milkConsumptionsList =
        context.watch<MilkConsumptionController>().milkConsumptionsList;
    _milkConsumersList =
        context.watch<MilkConsumerController>().milkConsumersList;

    _dataTableSource.setData(
        _milkConsumptionsList, _sortColumnIndex, _sortColumnAscending);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Milk Consumers Statements',
            style: TextStyle(),
          ),
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
                                  child: DropdownMenu<MilkConsumer>(
                                    controller: _milkConsumerController,
                                    requestFocusOnTap: true,
                                    initialSelection: selectedMilkConsumer,
                                    expandedInsets: EdgeInsets.zero,
                                    onSelected: (MilkConsumer? milkConsumer) {
                                      setState(() {
                                        selectedMilkConsumer = milkConsumer;
                                      });
                                      if (selectedMilkConsumer != null) {
                                        String? milkConsumerId =
                                            selectedMilkConsumer!.getId;
                                        context
                                            .read<MilkConsumptionController>()
                                            .filterMilkConsumptionsByMilkConsumerId(
                                                milkConsumerId!);
                                      }
                                    },
                                    errorText: selectedMilkConsumer == null
                                        ? 'Consumer cannot be empty!'
                                        : null,
                                    enableFilter: true,
                                    enableSearch: true,
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                            isDense: true,
                                            border: OutlineInputBorder()),
                                    dropdownMenuEntries: _milkConsumersList
                                        .map<DropdownMenuEntry<MilkConsumer>>(
                                            (MilkConsumer milkConsumer) {
                                      return DropdownMenuEntry<MilkConsumer>(
                                        value: milkConsumer,
                                        label: milkConsumer.getMilkConsumerName,
                                        enabled: true,
                                      );
                                    }).toList(),
                                  ),
                                ),
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
                                                .read<
                                                    MilkConsumptionController>()
                                                .filterMilkConsumptionByDate);
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
                          summaryTextDisplayRow("Total Quantity:",
                              "${context.read<MilkConsumptionController>().getTotalMilkConsumptionKgsAmount} Kgs"),
                        ],
                      )),
                )),
            PaginatedDataTable(
                header: const Text("Milk Consumption List"),
                rowsPerPage: 20,
                availableRowsPerPage: const [20, 30, 50],
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortColumnAscending,
                columns: [
                  DataColumn(label: const Text("Date"), onSort: _sort),
                  DataColumn(
                      label: const Text("Total Consumption (Kgs)"),
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
      DataCell(Text(item.getMilkConsumer.getMilkConsumerName)),
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
