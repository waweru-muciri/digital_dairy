import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});
  static const routePath = '/milk_sales';

  @override
  State<StatefulWidget> createState() => MilkSalesScreenState();
}

class MilkSalesScreenState extends State<MilkSalesScreen> {
  late List<MilkSale> _milkSalesList;
  final TextEditingController _milkSaleDateController =
      TextEditingController(text: getStringFromDate(DateTime.now()));

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<MilkSaleController>().getTodaysMilkSales());
    //start listening to changes on the date input field
    _milkSaleDateController.addListener(() {
      context
          .read<MilkSaleController>()
          .filterMilkSalesByDate(_milkSaleDateController.text);
    });
  }

  @override
  void dispose() {
    _milkSaleDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkSalesList = context.watch<MilkSaleController>().milkSalesList;

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
                    onPressed: () => context.pushNamed("addMilkSaleDetails"),
                    label: const Text("New Milk Sale"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: TextFormField(
              controller: _milkSaleDateController,
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Date',
                suffixIcon: IconButton(
                    onPressed: () async {
                      final DateTime? pickedDateTime = await selectDate(
                          context,
                          DateFormat("dd/MM/yyyy")
                              .parse(_milkSaleDateController.text));
                      final filterDateString =
                          DateFormat("dd/MM/yyyy").format(pickedDateTime!);
                      _milkSaleDateController.text = filterDateString;
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
            header: const Text("Milk Sales List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Client Name")),
              DataColumn(label: Text("Quantity (Ltrs)"), numeric: true),
              DataColumn(label: Text("Amount (Ksh)"), numeric: true),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _milkSalesList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<MilkSale> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getClient.clientName)),
      DataCell(Text('${item.getMilkSaleAmount}')),
      DataCell(Text('${item.getMilkSaleAmount * item.getClient.getUnitPrice}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkSaleDetails",
              pathParameters: {"editMilkSaleId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context.read<MilkSaleController>().deleteMilkSale(item);
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
