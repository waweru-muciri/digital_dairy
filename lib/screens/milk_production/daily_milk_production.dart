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
      TextEditingController(text: getStringFromDate(DateTime.now()));
  late List<DailyMilkProduction> _milkProductionList;
  final TextEditingController _fromDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _toDateFilterController =
      TextEditingController(text: getStringFromDate(DateTime.now()));

  @override
  void initState() {
    super.initState();
    context
        .read<DailyMilkProductionController>()
        .filterDailyMilkProductionsByDates(getStringFromDate(DateTime.now()));
  }

  @override
  void dispose() {
    super.dispose();
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    _cowNameSearchFilterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkProductionList =
        context.watch<DailyMilkProductionController>().dailyMilkProductionsList;

    return Scaffold(
        body: SingleChildScrollView(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: FilterInputField(
                                      onQueryChanged: context
                                          .read<DailyMilkProductionController>()
                                          .filterDailyMilkProductionsByCowName)),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  onPressed: () {
                                    showDatesFilterBottomSheet(
                                        context,
                                        _fromDateFilterController,
                                        _toDateFilterController,
                                        context
                                            .read<
                                                DailyMilkProductionController>()
                                            .filterDailyMilkProductionsByDates);
                                  }),
                            )
                          ],
                        )))),
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
                            "${context.read<DailyMilkProductionController>().getTotalAmMilkProductionQuantity} Kgs"),
                        summaryTextDisplayRow("Total Noon Quantity:",
                            "${context.read<DailyMilkProductionController>().getTotalNoonMilkProductionQuantity} Kgs"),
                        summaryTextDisplayRow("Total Pm Quantity:",
                            "${context.read<DailyMilkProductionController>().getTotalPmMilkProductionQuantity} Kgs"),
                        summaryTextDisplayRow("Total Quantity:",
                            "${context.read<DailyMilkProductionController>().getTotalMilkProductionQuantity} Kgs"),
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
              columns: const [
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Cow Name")),
                DataColumn(label: Text("Am")),
                DataColumn(label: Text("Noon")),
                DataColumn(label: Text("Pm")),
                DataColumn(label: Text("Total (Kgs)")),
                DataColumn(label: Text("Edit")),
                DataColumn(label: Text("Delete")),
              ],
              source: _DataSource(data: _milkProductionList, context: context))
        ]),
      ),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<DailyMilkProduction> data;
  final BuildContext context;

  _DataSource({required this.data, required this.context});
  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkProductionDate)),
      DataCell(Text(item.getCow.getName)),
      DataCell(Text('${item.getAmQuantity}')),
      DataCell(Text('${item.getNoonQuantity}')),
      DataCell(Text('${item.getPmQuantity}')),
      DataCell(Text('${item.totalMilkQuantity}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkSaleDetails",
              pathParameters: {"editMilkSaleId": '${item.getId}'})),
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
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
