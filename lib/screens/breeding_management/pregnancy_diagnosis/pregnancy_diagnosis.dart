import 'package:DigitalDairy/controllers/pregnancy_diagnosis_controller.dart';
import 'package:DigitalDairy/models/cow_pregnancy_diagnosis.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
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
  final TextEditingController _pregnancyDiagnosisSearchController =
      TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<PregnancyDiagnosisController>()
        .filterPregnancyDiagnosisByDate(getTodaysDateAsString()));
  }

  @override
  void dispose() {
    _pregnancyDiagnosisSearchController.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
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
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 4,
                    child: FilterInputField(
                        onQueryChanged: context
                            .read<PregnancyDiagnosisController>()
                            .filterPregnancyDiagnosisBySearchQuery)),
                Expanded(
                  flex: 1,
                  child: getFilterIconButton(onPressed: () async {
                    await showDatesFilterBottomSheet(context,
                            _fromDateFilterController, _toDateFilterController)
                        .then((Map<String, String>? selectedDatesMap) {
                      if (selectedDatesMap != null) {
                        String startDate = selectedDatesMap['start_date'] ?? '';
                        String endDate = selectedDatesMap['end_date'] ?? '';
                        context
                            .read<PregnancyDiagnosisController>()
                            .filterPregnancyDiagnosisByDate(startDate,
                                endDate: endDate);
                      }
                    });
                  }),
                ),
              ],
            )),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.pregnancyDiagnosissList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () =>
                    context.pushNamed("addPregnancyDiagnosisDetails"),
                label: const Text("New"),
              )
            ],
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
