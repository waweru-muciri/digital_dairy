import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MilkConsumptionsScreen extends StatefulWidget {
  const MilkConsumptionsScreen({super.key});
  static const routePath = '/milk_consumptions';

  @override
  State<StatefulWidget> createState() => MilkConsumptionsScreenState();
}

class MilkConsumptionsScreenState extends State<MilkConsumptionsScreen> {
  late List<MilkConsumption> _milkConsumptionList;
  final TextEditingController _milkConsumptionDateController =
      TextEditingController(
          text: DateFormat("dd/MM/yyyy").format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MilkConsumptionController>().getTodayMilkConsumptions());
    //start listening to changes on the date input field
    _milkConsumptionDateController.addListener(() {
      context
          .read<MilkConsumptionController>()
          .filterMilkConsumptionByDate(_milkConsumptionDateController.text);
    });
  }

  @override
  void dispose() {
    _milkConsumptionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkConsumptionList =
        context.watch<MilkConsumptionController>().milkConsumptionsList;

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () =>
                        context.pushNamed("addMilkConsumptionDetails"),
                    label: const Text("Add Milk Consumption"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: TextFormField(
              controller: _milkConsumptionDateController,
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Date',
                suffixIcon: IconButton(
                    onPressed: () async {
                      final DateTime pickedDateTime = await selectDate(
                          context,
                          DateFormat("dd/MM/yyyy")
                              .parse(_milkConsumptionDateController.text));
                      final filterDateString =
                          DateFormat("dd/MM/yyyy").format(pickedDateTime);
                      _milkConsumptionDateController.text = filterDateString;
                    },
                    icon: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.calendar_month,
                        ))),
              ),
            )),
        PaginatedDataTable(
            header: const Text("Milk Consumptions List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Consumer Name")),
              DataColumn(label: Text("Quantity (Ltrs)"), numeric: true),
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
      DataCell(Text(item.getMilkConsumer.milkConsumerName)),
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
