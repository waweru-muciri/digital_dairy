import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/controllers/cow_death_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_death.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CowDeathsScreen extends StatefulWidget {
  const CowDeathsScreen({super.key});
  static const routePath = '/cow_deaths';

  @override
  State<StatefulWidget> createState() => CowDeathsScreenState();
}

class CowDeathsScreenState extends State<CowDeathsScreen> {
  late List<CowDeath> _cowDeathList;
  final TextEditingController _cowDeathDetailsSearchController =
      TextEditingController();
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStartOfMonthDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getEndOfMonthDateAsString());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<CowDeathController>()
        .filterCowDeathsByDate(getStartOfMonthDateAsString(),
            endDate: getEndOfMonthDateAsString()));
  }

  @override
  void dispose() {
    _cowDeathDetailsSearchController.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowDeathList = context.watch<CowDeathController>().cowDeathsList;

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
                            .read<CowDeathController>()
                            .filterCowDeathsByQueryString)),
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
                            .read<CowDeathController>()
                            .filterCowDeathsByDate(startDate, endDate: endDate);
                      }
                    });
                  }),
                ),
              ],
            )),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.cowDeathsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            actions: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () => context.pushNamed("addCowDeathDetails"),
                label: const Text("New"),
              )
            ],
            columns: const [
              DataColumn(label: Text("Date"), numeric: false),
              DataColumn(label: Text("Cow"), numeric: false),
              DataColumn(label: Text("Vet Name"), numeric: false),
              DataColumn(label: Text("Cost"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _cowDeathList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<CowDeath> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getDateOfDeath)),
      DataCell(Text(item.getCow.cowName)),
      DataCell(Text(item.getVetName)),
      DataCell(Text('${item.getCowDeathCost}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editCowDeathDetails",
              pathParameters: {"editCowDeathId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<CowDeathController>()
              .deleteCowDeath(item)
              .then((_) async {
            Cow cowToEdit = item.getCow;
            cowToEdit.setActiveStatus = true;
            await context.read<CowController>().editCow(cowToEdit);
          });
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
