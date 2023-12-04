import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
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
            child: Column(children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: OutlinedButton(
                  onPressed: () {
                    context.goNamed("addClientDetails");
                  },
                  child: const Text("Add Client"),
                ),
              ),
              PaginatedDataTable(
                  header: const Text("Clients List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Contacts")),
                    DataColumn(label: Text("Unit Price (Ksh)")),
                  ],
                  source: _DataSource(data: _clientsList))
            ]),
          ),
        ));
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
      DataCell(Text(item.clientName)),
      DataCell(Text(item.contacts)),
      DataCell(Text('${item.unitPrice}')),
    ], onLongPress: () => {});
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
