import 'package:DigitalDairy/controllers/disease_controller.dart';
import 'package:DigitalDairy/models/disease.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({super.key});
  static const routePath = '/diseases';

  @override
  State<StatefulWidget> createState() => DiseasesScreenState();
}

class DiseasesScreenState extends State<DiseasesScreen> {
  late List<Disease> _diseaseList;
  final TextEditingController _getMilkConsumerNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DiseaseController>().getDiseases());
  }

  @override
  void dispose() {
    _getMilkConsumerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _diseaseList = context.watch<DiseaseController>().diseasesList;

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        context.pushNamed("addDiseaseDetails"),
                                    label: const Text("New"),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<DiseaseController>()
                                      .filterDiseases)),
                        ],
                      )))),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.diseasesList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Disease Name")),
              DataColumn(label: Text("Date Discovered"), numeric: false),
              DataColumn(label: Text("Details"), numeric: false),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _diseaseList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<Disease> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getName)),
      DataCell(Text(item.getDateDiscovered)),
      DataCell(Text(item.getDetails)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editDiseaseDetails",
              pathParameters: {"editDiseaseId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<DiseaseController>().deleteDisease(item);
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
