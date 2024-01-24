import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkConsumptionsScreen extends StatefulWidget {
  const MilkConsumptionsScreen({super.key});
  static const routePath = '/milk_consumptions';

  @override
  State<StatefulWidget> createState() => MilkConsumptionsScreenState();
}

class MilkConsumptionsScreenState extends State<MilkConsumptionsScreen> {
  late List<MilkConsumption> _milkConsumptionList;
  final TextEditingController _cowNameController = TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<MilkConsumptionController>()
        .filterMilkConsumptionByDate(getTodaysDateAsString()));
  }

  @override
  void dispose() {
    _cowNameController.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkConsumptionList =
        context.watch<MilkConsumptionController>().milkConsumptionsList;

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
                                        .read<MilkConsumptionController>()
                                        .filterMilkConsumptionBySearchTerm)),
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
                                            .read<MilkConsumptionController>()
                                            .filterMilkConsumptionByDate);
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
                      summaryTextDisplayRow("Total Milk Consumption Amount: ",
                          "${context.read<MilkConsumptionController>().getTotalMilkConsumptionKgsAmount} Kgs"),
                    ],
                  )),
            )),
        PaginatedDataTable(
            header: const Text("Milk Consumption List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addMilkConsumptionDetails"),
                label: const Text("New"),
              ),
            ],
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Consumer Name")),
              DataColumn(label: Text("Quantity (Kgs)"), numeric: true),
              DataColumn(label: Text("Amount (Ksh)"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _milkConsumptionList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<MilkConsumption> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkConsumptionDate)),
      DataCell(Text(item.getMilkConsumer.getMilkConsumerName)),
      DataCell(Text('${item.getMilkConsumptionAmount}')),
      const DataCell(Text('0')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkConsumptionDetails",
              pathParameters: {"editMilkConsumptionId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<MilkConsumptionController>()
              .deleteMilkConsumption(item);
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
