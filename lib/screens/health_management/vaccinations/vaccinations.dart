import 'package:DigitalDairy/controllers/vaccination_controller.dart';
import 'package:DigitalDairy/models/vaccination.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
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
  final TextEditingController _milkConsumerNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<VaccinationController>().getVaccinations());
    //start listening to changes on the date input field
  }

  @override
  void dispose() {
    _milkConsumerNameController.dispose();
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
                                    onPressed: () => context
                                        .pushNamed("addVaccinationDetails"),
                                    label: const Text("Add Vaccination"),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<VaccinationController>()
                                      .filterVaccinations)),
                        ],
                      ),
                    )))),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.vaccinationsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
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
