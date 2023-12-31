import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import "package:DigitalDairy/controllers/milk_production_controller.dart";
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late TextEditingController _cowNameController;
  late List<DailyMilkProduction> _milkProductionList;

  @override
  void initState() {
    super.initState();
    _cowNameController = TextEditingController();
    Provider.of<MilkProductionController>(context, listen: false)
        .loadTodaysMilkProduction();
  }

  @override
  void dispose() {
    super.dispose();
    _cowNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkProductionList =
        context.watch<MilkProductionController>().todaysMilkProductionList;

    return Scaffold(
        appBar: AppBar(
            title: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Daily Milk Production',
            style: TextStyle(color: Colors.blueGrey),
          ),
        )),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(
                  'Milk data for today ${context.read<MilkProductionController>().todaysMilkProductionList.length}'),
              PaginatedDataTable(
                  header: const Text("Milk Production List"),
                  rowsPerPage: 20,
                  availableRowsPerPage: const [10, 20, 30],
                  columns: const [
                    DataColumn(label: Text("Cow Name")),
                    DataColumn(label: Text("Am")),
                    DataColumn(label: Text("Noon")),
                    DataColumn(label: Text("Pm")),
                    DataColumn(label: Text("Total"))
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
      DataCell(Text(item.id.toString())),
      DataCell(Text(item.amQuantity.toString())),
      DataCell(Text(item.noonQuantity.toString())),
      DataCell(Text(item.pmQuantity.toString())),
      DataCell(Text(item.totalMilkQuantity.toString())),
    ], onLongPress: () => {});
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
