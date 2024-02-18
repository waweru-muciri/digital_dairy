import 'package:DigitalDairy/controllers/vaccination_controller.dart';
import 'package:DigitalDairy/models/vaccination.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VaccinationsScreen extends StatefulWidget {
  const VaccinationsScreen({super.key});
  static const routePath = '/vaccinations';

  @override
  State<StatefulWidget> createState() => VaccinationsScreenState();
}

class VaccinationsScreenState extends State<VaccinationsScreen> {
  late List<Vaccination> _vaccinationList;
  final TextEditingController _vaccinationDetailsSearchController =
      TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<VaccinationController>()
        .filterVaccinationsByDate(getStartOfMonthDateAsString(),
            endDate: getEndOfMonthDateAsString()));
  }

  @override
  void dispose() {
    _vaccinationDetailsSearchController.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vaccinationList = context.watch<VaccinationController>().vaccinationsList;

    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 6, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 4,
                    child: FilterInputField(
                        onQueryChanged: context
                            .read<VaccinationController>()
                            .filterVaccinationsByQueryString)),
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
                            .read<VaccinationController>()
                            .filterVaccinationsByDate(startDate,
                                endDate: endDate);
                      }
                    });
                  }),
                ),
              ],
            )),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.vaccinationsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addVaccinationDetails"),
                label: const Text("New"),
              )
            ],
            columns: const [
              DataColumn(label: Text("Date"), numeric: false),
              DataColumn(label: Text("Cow"), numeric: false),
              DataColumn(label: Text("Vaccination"), numeric: false),
              DataColumn(label: Text("Vet Name"), numeric: false),
              DataColumn(label: Text("Cost"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _vaccinationList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<Vaccination> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getVaccinationDate)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(Text(item.getVaccination)),
      DataCell(Text(item.getVetName)),
      DataCell(Text('${item.getVaccinationCost}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editVaccinationDetails",
              pathParameters: {"editVaccinationId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<VaccinationController>()
              .deleteVaccination(item);
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
