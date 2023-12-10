import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';

class MilkConsumersScreen extends StatefulWidget {
  const MilkConsumersScreen({super.key});

  static const routeName = '/milkConsumers';

  @override
  State<StatefulWidget> createState() => MilkConsumersScreenState();
}

class MilkConsumersScreenState extends State<MilkConsumersScreen> {
  late TextEditingController _cowNameController;
  late List<MilkConsumer> _milkConsumersList;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
    Provider.of<MilkConsumerController>(context, listen: false)
        .getMilkConsumers();
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkConsumersList =
        context.watch<MilkConsumerController>().milkConsumersList;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Milk Consumers',
            style: TextStyle(),
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
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
                              context.pushNamed("addMilkConsumerDetails"),
                          label: const Text("Add Consumer"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    FilterInputField(
                        onQueryChanged: context
                            .read<MilkConsumerController>()
                            .filterMilkConsumers),
                  ],
                ),
              ),
              PaginatedDataTable(
                  header: const Text("Milk Consumers List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Contacts")),
                    DataColumn(label: Text("Location")),
                    DataColumn(label: Text("Edit")),
                    DataColumn(label: Text("Delete")),
                  ],
                  source:
                      _DataSource(data: _milkConsumersList, context: context))
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
      DataCell(Text(item.contacts)),
      DataCell(Text(item.location)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkConsumerDetails",
              pathParameters: {"editMilkConsumerId": '${item.id}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        await context.read<MilkConsumerController>().deleteMilkConsumer(item);
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
