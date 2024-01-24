import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CowsScreen extends StatefulWidget {
  const CowsScreen({super.key});
  static const routePath = '/cows';

  @override
  State<StatefulWidget> createState() => CowsScreenState();
}

class CowsScreenState extends State<CowsScreen> {
  late List<Cow> _cowList;
  final TextEditingController _getCowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _getCowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowList = context.watch<CowController>().cowsList;

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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<CowController>()
                                      .filterCows)),
                        ],
                      )))),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.cowsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addCowDetails"),
                label: const Text("New"),
              )
            ],
            columns: const [
              DataColumn(
                label: Text("Cow Code"),
              ),
              DataColumn(
                label: Text("Cow Name"),
              ),
              DataColumn(label: Text("Sire")),
              DataColumn(label: Text("Dam")),
              DataColumn(
                label: Text("Grade"),
              ),
              DataColumn(label: Text("Breed")),
              DataColumn(label: Text("Color")),
              DataColumn(label: Text("D.O.B")),
              // DataColumn(label: Text("Category")),
              // DataColumn(label: Text("Status")),
              // DataColumn(label: Text("Birth Weight (Kgs)")),
              // DataColumn(label: Text("Group")),
              // DataColumn(label: Text("Source")),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _cowList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<Cow> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final cow = data[index];
    final cowSire = cow.getSire;
    final cowDam = cow.getDam;
    return DataRow(cells: [
      DataCell(Text(cow.getCowCode)),
      DataCell(Text(cow.getName)),
      DataCell(Text(cowSire != null ? cowSire.getName : "")),
      DataCell(Text(cowDam != null ? cowDam.getName : "")),
      DataCell(Text('${cow.getGrade}')),
      DataCell(Text('${cow.getBreed}')),
      DataCell(Text('${cow.getColor}')),
      DataCell(Text('${cow.getDateOfBirth}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editCowDetails",
              pathParameters: {"editCowId": '${cow.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<CowController>().deleteCow(cow);
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
