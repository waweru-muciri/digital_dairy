import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});
  static const routePath = '/clients';

  @override
  State<StatefulWidget> createState() => ClientsScreenState();
}

class ClientsScreenState extends State<ClientsScreen> {
  late List<Client> _clientsList;
  final TextEditingController _clientNameSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ClientController>().getClients());
  }

  @override
  void dispose() {
    _clientNameSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clientsList = context.watch<ClientController>().clientsList;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Clients',
          ),
        ),
        drawer: const MyDrawer(),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: FilterInputField(
                      onQueryChanged:
                          context.read<ClientController>().filterClients)),
              PaginatedDataTable(
                  header: const Text("Clients List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  sortAscending: false,
                  sortColumnIndex: 0,
                  actions: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.pushNamed("addClientDetails"),
                      label: const Text("New"),
                    )
                  ],
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
        )));
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

    final client = data[index];

    return DataRow(cells: [
      DataCell(
          Text(
            client.clientName,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          onTap: () => context.pushNamed("clients_statements",
              pathParameters: {"clientId": '${client.getId}'})),
      DataCell(Text(client.getContacts)),
      DataCell(Text('${client.getUnitPrice}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editClientDetails",
              pathParameters: {"editClientId": '${client.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<ClientController>().deleteClient(client);
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
