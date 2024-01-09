import 'package:DigitalDairy/controllers/disease_controller.dart';
import 'package:DigitalDairy/models/disease.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({super.key});
  static const routeName = '/diseases';

  @override
  State<StatefulWidget> createState() => DiseasesScreenState();
}

class DiseasesScreenState extends State<DiseasesScreen> {
  late List<Disease> _diseaseList;
  final TextEditingController _milkConsumerNameController =
      TextEditingController();
  final TextEditingController _diseaseDateController = TextEditingController(
      text: DateFormat("dd/MM/yyyy").format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DiseaseController>().getDiseases());
    //start listening to changes on the date input field
    _diseaseDateController.addListener(() {
      context
          .read<DiseaseController>()
          .filterDiseases(_diseaseDateController.text);
    });
  }

  @override
  void dispose() {
    _milkConsumerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _diseaseList = context.watch<DiseaseController>().diseasesList;

    return SingleChildScrollView(
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
                    onPressed: () => context.pushNamed("addDiseaseDetails"),
                    label: const Text("Add Disease"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: TextFormField(
              controller: _diseaseDateController,
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Date',
                suffixIcon: IconButton(
                    onPressed: () async {
                      final DateTime pickedDateTime =
                          await selectDate(context, DateTime.now());
                      final filterDate =
                          DateFormat("dd/MM/yyyy").format(pickedDateTime);
                      _diseaseDateController.text = filterDate;
                    },
                    icon: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.calendar_month,
                        ))),
              ),
            )),
        PaginatedDataTable(
            header: const Text("Diseases List"),
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
