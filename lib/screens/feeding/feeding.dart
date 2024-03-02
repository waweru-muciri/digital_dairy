import 'package:DigitalDairy/models/feeding_item.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FeedingsScreen extends StatefulWidget {
  const FeedingsScreen({super.key});
  static const routePath = '/feeding';

  @override
  State<StatefulWidget> createState() => FeedingsScreenState();
}

class FeedingsScreenState extends State<FeedingsScreen> {
  late List<FeedingItem> _feedingItemsList;
  final TextEditingController _feedingItemNameSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FeedingController>().getFeedings());
  }

  @override
  void dispose() {
    _feedingItemNameSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _feedingItemsList = context.watch<FeedingController>().feedingItemsList;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Feedings',
          ),
        ),
        drawer: const MyDrawer(),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: FilterInputField(
                      onQueryChanged:
                          context.read<FeedingController>().filterFeedings)),
              PaginatedDataTable(
                  header: const Text("Feedings"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  sortAscending: false,
                  sortColumnIndex: 0,
                  actions: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.pushNamed("addFeedingDetails"),
                      label: const Text("New"),
                    )
                  ],
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Current quantity")),
                    DataColumn(label: Text("Unit Price (Ksh)"), numeric: true),
                    DataColumn(label: Text("Edit")),
                    DataColumn(label: Text("Delete")),
                  ],
                  source:
                      _DataSource(data: _feedingItemsList, context: context))
            ]),
          ),
        )));
  }
}

class _DataSource extends DataTableSource {
  final List<FeedingItem> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final feedingItem = data[index];

    return DataRow(cells: [
      DataCell(
          Text(
            feedingItem.feedingItemName,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          onTap: () => context.pushNamed("feedingItems_statements",
              pathParameters: {"feedingItemId": '${feedingItem.getId}'})),
      DataCell(Text(feedingItem.getContacts)),
      DataCell(Text('${feedingItem.getUnitPrice}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editFeedingDetails",
              pathParameters: {"editFeedingId": '${feedingItem.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<FeedingController>()
              .deleteFeeding(feedingItem);
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
