import 'package:DigitalDairy/controllers/treatment_controller.dart';
import 'package:DigitalDairy/models/treatment.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({super.key});
  static const routeName = '/treatments';

  @override
  State<StatefulWidget> createState() => TreatmentsScreenState();
}

class TreatmentsScreenState extends State<TreatmentsScreen> {
  late List<Treatment> _treatmentList;
  final TextEditingController _milkConsumerNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TreatmentController>().getTreatments());
    //start listening to changes on the date input field
  }

  @override
  void dispose() {
    _milkConsumerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _treatmentList = context.watch<TreatmentController>().treatmentsList;

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
                    onPressed: () => context.pushNamed("addTreatmentDetails"),
                    label: const Text("Add Treatment"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              FilterInputField(
                  onQueryChanged:
                      context.read<TreatmentController>().filterTreatments),
            ],
          ),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.treatmentsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Date"), numeric: false),
              DataColumn(label: Text("Cow"), numeric: false),
              DataColumn(label: Text("Treatment"), numeric: false),
              DataColumn(label: Text("Vet Name"), numeric: false),
              DataColumn(label: Text("Cost"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _treatmentList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<Treatment> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getTreatmentDate)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(Text(item.getTreatment)),
      DataCell(Text(item.getVetName)),
      DataCell(Text('${item.getTreatmentCost}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editTreatmentDetails",
              pathParameters: {"editTreatmentId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<TreatmentController>()
              .deleteTreatment(item);
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