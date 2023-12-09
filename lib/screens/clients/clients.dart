import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});
  static const routeName = '/clients';

  @override
  State<StatefulWidget> createState() => ClientsScreenState();
}

class ClientsScreenState extends State<ClientsScreen> {
  late List<Client> _clientsList;
  final TextEditingController _cowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ClientController>().getClients());
  }

  @override
  void dispose() {
    _cowNameController.dispose();
    super.dispose();
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
                              context.pushNamed("addClientDetails"),
                          label: const Text("Add Client"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    FilterInputField(
                        onQueryChanged:
                            context.read<ClientController>().filterClients),
                  ],
                ),
              ),
              PaginatedDataTable(
                  header: const Text("Clients List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Contacts")),
                    DataColumn(label: Text("Unit Price (Ksh)"), numeric: true),
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
  final List<Client> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.clientName)),
      DataCell(Text(item.contacts)),
      DataCell(Text('${item.unitPrice}')),
      DataCell(const Icon(Icons.edit), onTap: () {}),
      DataCell(const Icon(Icons.delete), onTap: () => {}),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
