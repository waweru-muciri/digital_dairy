import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class DailyMilkProductionScreen extends StatefulWidget {
  const DailyMilkProductionScreen({super.key});

  static const routePath = '/daily_milk_production';

  @override
  State<StatefulWidget> createState() => DailyMilkProductionScreenState();
}

class DailyMilkProductionScreenState extends State<DailyMilkProductionScreen> {
  final TextEditingController _cowNameSearchFilterController =
      TextEditingController(text: getTodaysDateAsString());
  late List<DailyMilkProduction> _milkProductionList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getTodaysDateAsString());
  int _sortColumnIndex = 0;
  bool _sortColumnAscending = true;
  late _DataSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = _DataSource(context: context);
    Future.microtask(() => context
        .read<DailyMilkProductionController>()
        .filterDailyMilkProductionsByDates(getTodaysDateAsString()));
  }

  @override
  void dispose() {
    super.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    _cowNameSearchFilterController.dispose();
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortColumnAscending = ascending;
      _dataTableSource.setData(
          _milkProductionList, _sortColumnIndex, _sortColumnAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    _milkProductionList =
        context.watch<DailyMilkProductionController>().dailyMilkProductionsList;

    _dataTableSource.setData(
        _milkProductionList, _sortColumnIndex, _sortColumnAscending);
    double dailyTotalAmMilkProduction = context
        .read<DailyMilkProductionController>()
        .getTotalAmMilkProductionQuantity;
    double dailyTotalNoonMilkProduction = context
        .read<DailyMilkProductionController>()
        .getTotalNoonMilkProductionQuantity;
    double dailyTotalPmMilkProduction = context
        .read<DailyMilkProductionController>()
        .getTotalPmMilkProductionQuantity;
    double dailyTotalMilkProduction = dailyTotalAmMilkProduction +
        dailyTotalNoonMilkProduction +
        dailyTotalPmMilkProduction;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: FilterInputField(
                          onQueryChanged: context
                              .read<DailyMilkProductionController>()
                              .filterDailyMilkProductionsByCowName)),
                ),
                Expanded(
                  flex: 1,
                  child: getFilterIconButton(onPressed: () async {
                    await showDatesFilterBottomSheet(context,
                            _fromDateFilterController, _toDateFilterController)
                        .then((Map<String, String>? selectedDatesMap) {
                      if (selectedDatesMap != null) {
                        String startDate = selectedDatesMap['start_date'] ?? '';
                        String endDate = selectedDatesMap['start_date'] ?? '';
                        context
                            .read<DailyMilkProductionController>()
                            .filterDailyMilkProductionsByDates(startDate,
                                endDate: endDate);
                      }
                    });
                  }),
                )
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        summaryTextDisplayRow("Total Am Quantity:",
                            "${dailyTotalAmMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Noon Quantity:",
                            "${dailyTotalNoonMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Pm Quantity:",
                            "${dailyTotalPmMilkProduction.toStringAsFixed(2)} Kgs"),
                        summaryTextDisplayRow("Total Quantity:",
                            "${dailyTotalMilkProduction.toStringAsFixed(2)} Kgs"),
                      ],
                    )),
              )),
          PaginatedDataTable(
              header: const Text("Milk Production List"),
              rowsPerPage: 20,
              availableRowsPerPage: const [20, 30, 50],
              actions: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      context.pushNamed("addDailyMilkProductionDetails"),
                  label: const Text("Add"),
                ),
              ],
              columns: [
                const DataColumn(label: Text("Date")),
                const DataColumn(label: Text("Cow Name")),
                DataColumn(
                    label: const Text("Am"), numeric: true, onSort: _sort),
                DataColumn(
                    label: const Text("Noon"), numeric: true, onSort: _sort),
                DataColumn(
                    label: const Text("Pm"), numeric: true, onSort: _sort),
                DataColumn(
                    label: const Text("Total (Kgs)"),
                    numeric: true,
                    onSort: _sort),
                const DataColumn(label: Text("Edit")),
                const DataColumn(label: Text("Delete")),
              ],
              source: _dataTableSource)
        ]),
      ),
    ));
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  _DataSource({required this.context});

  late List<DailyMilkProduction> sortedData = [];

  void setData(
      List<DailyMilkProduction> rawData, int sortColumn, bool sortAscending) {
    sortedData = rawData
      ..sort((DailyMilkProduction a, DailyMilkProduction b) {
        late final Comparable<Object> cellA;
        late final Comparable<Object> cellB;
        switch (sortColumn) {
          case 0:
            cellA = a.getMilkProductionDate;
            cellB = b.getMilkProductionDate;
            break;
          case 2:
            cellA = a.getAmQuantity;
            cellB = b.getAmQuantity;
          case 3:
            cellA = a.getNoonQuantity;
            cellB = b.getNoonQuantity;
          case 4:
            cellA = a.getPmQuantity;
            cellB = b.getPmQuantity;
          case 5:
            cellA = a.totalMilkQuantity;
            cellB = b.totalMilkQuantity;
            break;
          default:
        }
        return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
      });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= sortedData.length) {
      return null;
    }

    final item = sortedData[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkProductionDate)),
      DataCell(Text(item.getCow.getName)),
      DataCell(Text('${item.getAmQuantity}')),
      DataCell(Text('${item.getNoonQuantity}')),
      DataCell(Text('${item.getPmQuantity}')),
      DataCell(Text('${item.totalMilkQuantity}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editDailyMilkProductionDetails",
              pathParameters: {"editDailyMilkProductionId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<DailyMilkProductionController>()
              .deleteDailyMilkProduction(item);
        }

        await showDeleteItemDialog(context, deleteFunc);
      }),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sortedData.length;

  @override
  int get selectedRowCount => 0;
}
