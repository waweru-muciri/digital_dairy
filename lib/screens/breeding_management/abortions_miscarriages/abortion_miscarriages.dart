import 'package:DigitalDairy/controllers/cow_abortion_miscarriage_controller.dart';
import 'package:DigitalDairy/models/cow_abortion_miscarriage.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AbortionMiscarriagesScreen extends StatefulWidget {
  const AbortionMiscarriagesScreen({super.key});
  static const routePath = '/abortion_miscarriages';

  @override
  State<StatefulWidget> createState() => AbortionMiscarriagesScreenState();
}

class AbortionMiscarriagesScreenState
    extends State<AbortionMiscarriagesScreen> {
  late List<AbortionMiscarriage> _abortionMiscarriageList;
  final TextEditingController _abortionAndMiscarriagesSearchController =
      TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<AbortionMiscarriageController>()
        .filterAbortionMiscarriagesByDate(getTodaysDateAsString()));
  }

  @override
  void dispose() {
    _abortionAndMiscarriagesSearchController.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _abortionMiscarriageList =
        context.watch<AbortionMiscarriageController>().abortionMiscarriagesList;

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
                            .read<AbortionMiscarriageController>()
                            .filterAbortionMiscarriagesBySearchQuery)),
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
                            .read<AbortionMiscarriageController>()
                            .filterAbortionMiscarriagesByDate(startDate,
                                endDate: endDate);
                      }
                    });
                  }),
                ),
              ],
            )),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.abortionsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () =>
                    context.pushNamed("addAbortionMiscarriageDetails"),
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
                _DataSource(data: _abortionMiscarriageList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<AbortionMiscarriage> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getAbortionMiscarriageDate)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(Text(item.getAbortionOrMiscarriage)),
      DataCell(Text(item.getVetName ?? '')),
      DataCell(Text('${item.getAbortionMiscarriageCost}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editAbortionMiscarriageDetails",
              pathParameters: {"editAbortionMiscarriageId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<AbortionMiscarriageController>()
              .deleteAbortionMiscarriage(item);
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
