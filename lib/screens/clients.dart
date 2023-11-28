import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  static const routeName = '/clients';

  @override
  State<StatefulWidget> createState() => ClientsScreenState();
}

class ClientsScreenState extends State<ClientsScreen> {
  late TextEditingController _cowNameController;
  late List<Client> _clientsList;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
    Provider.of<ClientController>(context, listen: false).getClients();
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clientsList = context.watch<ClientController>().clientsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Clients',
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          PaginatedDataTable(
              header: const Text("Clients List"),
              rowsPerPage: 20,
              availableRowsPerPage: const [20, 30, 50],
              columns: const [
                DataColumn(label: Text("First Name")),
                DataColumn(label: Text("Last Name")),
                DataColumn(label: Text("Contacts")),
              ],
              source: _DataSource(data: _clientsList))
        ]),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Client> data;

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
