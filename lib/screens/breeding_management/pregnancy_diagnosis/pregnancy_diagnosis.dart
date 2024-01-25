import 'package:DigitalDairy/controllers/pregnancy_diagnosis_controller.dart';
import 'package:DigitalDairy/models/cow_pregnancy_diagnosis.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PregnancyDiagnosisScreen extends StatefulWidget {
  const PregnancyDiagnosisScreen({super.key});
  static const routePath = '/pregnancy_diagnosis';

  @override
  State<StatefulWidget> createState() => PregnancyDiagnosissScreenState();
}

class PregnancyDiagnosissScreenState extends State<PregnancyDiagnosisScreen> {
  late List<PregnancyDiagnosis> _pregnancyDiagnosisList;
  final TextEditingController _getMilkConsumerNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PregnancyDiagnosisController>().getPregnancyDiagnosiss());
  }

  @override
  void dispose() {
    _getMilkConsumerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pregnancyDiagnosisList =
        context.watch<PregnancyDiagnosisController>().pregnancyDiagnosissList;

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
                                    onPressed: () => context.pushNamed(
                                        "addPregnancyDiagnosisDetails"),
                                    label: const Text("New"),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<PregnancyDiagnosisController>()
                                      .filterPregnancyDiagnosiss)),
                        ],
                      )))),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.pregnancyDiagnosissList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(
                label: Text("Date"),
              ),
              DataColumn(
                label: Text("Cow"),
              ),
              DataColumn(
                label: Text("Diagnosis"),
              ),
              DataColumn(
                label: Text("Vet Name"),
              ),
              DataColumn(label: Text("Cost"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source:
                _DataSource(data: _pregnancyDiagnosisList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<PregnancyDiagnosis> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getPregnancyDiagnosisDate)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(
          Text(item.getPregnancyDiagnosisResult ? "Positive" : "Negative")),
      DataCell(Text(item.getVetName ?? '')),
      DataCell(Text('${item.getPregnancyDiagnosisCost}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editPregnancyDiagnosisDetails",
              pathParameters: {"editPregnancyDiagnosisId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<PregnancyDiagnosisController>()
              .deletePregnancyDiagnosis(item);
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
