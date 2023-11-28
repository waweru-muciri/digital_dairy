import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          'Farm MilkConsumers',
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          PaginatedDataTable(
              header: const Text("Milk Consumers List"),
              rowsPerPage: 20,
              availableRowsPerPage: const [20, 30, 50],
              columns: const [
                DataColumn(label: Text("First Name")),
                DataColumn(label: Text("Last Name")),
                DataColumn(label: Text("Contacts")),
              ],
              source: _DataSource(data: _milkConsumersList))
        ]),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<MilkConsumer> data;

  _DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.firstName)),
      DataCell(Text(item.lastName)),
      DataCell(Text(item.contacts)),
    ], onLongPress: () => {});
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
