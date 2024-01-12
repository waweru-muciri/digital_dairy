import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MilkConsumersScreen extends StatefulWidget {
  const MilkConsumersScreen({super.key});
  static const routePath = '/milk_consumers';

  @override
  State<StatefulWidget> createState() => MilkConsumersScreenState();
}

class MilkConsumersScreenState extends State<MilkConsumersScreen> {
  late List<MilkConsumer> _clientsList;
  final TextEditingController _cowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<MilkConsumerController>().getMilkConsumers());
  }

  @override
  void dispose() {
    _cowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clientsList = context.watch<MilkConsumerController>().milkConsumersList;

    return Scaffold(
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
                                      onPressed: () => context
                                          .pushNamed("addMilkConsumerDetails"),
                                      label: const Text("Add Consumer"),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: FilterInputField(
                                    onQueryChanged: context
                                        .read<MilkConsumerController>()
                                        .filterMilkConsumers)),
                          ],
                        )))),
          ),
          PaginatedDataTable(
              header: const Text("Milk Consumers List"),
              rowsPerPage: 20,
              availableRowsPerPage: const [20, 30, 50],
              sortAscending: false,
              sortColumnIndex: 0,
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Contacts")),
                DataColumn(label: Text("Location")),
                DataColumn(label: Text("Edit")),
                DataColumn(label: Text("Delete")),
              ],
              source: _DataSource(data: _clientsList, context: context))
        ]),
      ),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<MilkConsumer> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.milkConsumerName)),
      DataCell(Text(item.getContacts)),
      DataCell(Text(item.getLocation)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkConsumerDetails",
              pathParameters: {"editMilkConsumerId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<MilkConsumerController>()
              .deleteMilkConsumer(item);
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
