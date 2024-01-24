import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/';

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _milkProductionDateController =
      TextEditingController(text: getTodaysDateAsString());
  late TextEditingController _cowNameController;
  late List<DailyMilkProduction> _milkProductionList;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
    _milkProductionDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkProductionList =
        context.watch<DailyMilkProductionController>().dailyMilkProductionsList;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daily Milk Production',
            style: TextStyle(),
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    controller: _milkProductionDateController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Date',
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? pickedDateTime =
                                await showCustomDatePicker(
                                    context,
                                    DateFormat("dd/MM/yyyy").parse(
                                        _milkProductionDateController.text));
                            final filterDateString = DateFormat("dd/MM/yyyy")
                                .format(pickedDateTime!);
                            _milkProductionDateController.text =
                                filterDateString;
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
                  header: const Text("Milk Production List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [20, 30, 50],
                  columns: const [
                    DataColumn(label: Text("Cow Name")),
                    DataColumn(label: Text("Am")),
                    DataColumn(label: Text("Noon")),
                    DataColumn(label: Text("Pm")),
                    DataColumn(label: Text("Total (Kgs)"))
                  ],
                  source: _DataSource(data: _milkProductionList))
            ]),
          ),
        ));
  }
}

class _DataSource extends DataTableSource {
  final List<DailyMilkProduction> data;

  _DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getCow.getName)),
      DataCell(Text('${item.getAmQuantity}')),
      DataCell(Text('${item.getNoonQuantity}')),
      DataCell(Text('${item.getPmQuantity}')),
      DataCell(Text('${item.totalMilkQuantity}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
