import 'package:DigitalDairy/controllers/milk_sale_payment_controller.dart';
import 'package:DigitalDairy/models/milk_sale_payment.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkSalesPaymentsScreen extends StatefulWidget {
  const MilkSalesPaymentsScreen({super.key});
  static const routePath = '/milk_sales_payments';

  @override
  State<StatefulWidget> createState() => MilkSalesPaymentsScreenState();
}

class MilkSalesPaymentsScreenState extends State<MilkSalesPaymentsScreen> {
  late List<MilkSalePayment> _milkSalePaymentsList;
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
        .read<MilkSalePaymentController>()
        .filterMilkSalePaymentsByDates(getTodaysDateAsString()));
  }

  @override
  void dispose() {
    _fromDateFilterController.dispose();
    _toDateFilterController.dispose();
    super.dispose();
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortColumnAscending = ascending;
      _dataTableSource.setData(
          _milkSalePaymentsList, _sortColumnIndex, _sortColumnAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    _milkSalePaymentsList =
        context.watch<MilkSalePaymentController>().milkSalePaymentsList;
    _dataTableSource.setData(
        _milkSalePaymentsList, _sortColumnIndex, _sortColumnAscending);
    double totalMilkSalesPayments =
        context.read<MilkSalePaymentController>().getTotalMilkSalesPayment;
    double totalMilkSales =
        context.read<MilkSalePaymentController>().getTotalMilkSales;
    double outstandingPaymentsAmount = totalMilkSalesPayments - totalMilkSales;

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
                                        .read<MilkSalePaymentController>()
                                        .filterMilkSalePaymentsByClientName)),
                          ),
                          Expanded(
                              flex: 1,
                              child: getFilterIconButton(onPressed: () {
                                showDatesFilterBottomSheet(
                                    context,
                                    _fromDateFilterController,
                                    _toDateFilterController,
                                    context
                                        .read<MilkSalePaymentController>()
                                        .filterMilkSalePaymentsByDates);
                              })),
                        ],
                      )))),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      summaryTextDisplayRow(
                          "Total Payments:", "$totalMilkSalesPayments Ksh"),
                      summaryTextDisplayRow(
                          "Total Sales:", "$totalMilkSales Ksh"),
                      summaryTextDisplayRow("Outstanding Amount:",
                          "$outstandingPaymentsAmount Ksh"),
                    ],
                  )),
            )),
        PaginatedDataTable(
            header: const Text("Payments List"),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortColumnAscending,
            columns: [
              DataColumn(label: const Text("Date"), onSort: _sort),
              const DataColumn(label: Text("Client Name")),
              DataColumn(
                  label: const Text("Milk Sale Amount (Ksh)"),
                  numeric: true,
                  onSort: _sort),
              DataColumn(
                  label: const Text("Payment Amount (Ksh)"),
                  numeric: true,
                  onSort: _sort),
              const DataColumn(label: Text("Edit")),
              const DataColumn(label: Text("Delete")),
            ],
            source: _dataTableSource)
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  _DataSource({required this.context});

  late List<MilkSalePayment> sortedData = [];

  void setData(
      List<MilkSalePayment> rawData, int sortColumn, bool sortAscending) {
    sortedData = rawData
      ..sort((MilkSalePayment a, MilkSalePayment b) {
        late final Comparable<Object> cellA;
        late final Comparable<Object> cellB;
        switch (sortColumn) {
          case 0:
            cellA = a.getMilkSalePaymentDate;
            cellB = b.getMilkSalePaymentDate;
            break;
          case 2:
            cellA = a.getMilkSale.getMilkSaleMoneyAmount;
            cellB = b.getMilkSale.getMilkSaleMoneyAmount;
          case 3:
            cellA = a.getMilkSalePaymentAmount;
            cellB = b.getMilkSalePaymentAmount;
            break;
          default:
        }
        return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
      });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final item = sortedData[index];

    return DataRow(cells: [
      DataCell(Text(item.getMilkSalePaymentDate)),
      DataCell(Text(item.getMilkSale.getClient.clientName)),
      DataCell(Text('${item.getMilkSale.getMilkSaleMoneyAmount}')),
      DataCell(Text('${item.getMilkSalePaymentAmount}')),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editMilkSalePaymentDetails",
              pathParameters: {"editMilkSalePaymentId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<MilkSalePaymentController>()
              .deleteMilkSalePayment(item);
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
