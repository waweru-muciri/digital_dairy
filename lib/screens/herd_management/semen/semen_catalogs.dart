import 'package:DigitalDairy/controllers/semen_catalog_controller.dart';
import 'package:DigitalDairy/models/semen_catalog.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SemenCatalogsScreen extends StatefulWidget {
  const SemenCatalogsScreen({super.key});
  static const routePath = '/semen_catalogs';

  @override
  State<StatefulWidget> createState() => SemenCatalogsScreenState();
}

class SemenCatalogsScreenState extends State<SemenCatalogsScreen> {
  late List<SemenCatalog> _semenCatalogList;
  final TextEditingController _semenCatalogFilterController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<SemenCatalogController>().getSemenCatalogs());
  }

  @override
  void dispose() {
    _semenCatalogFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _semenCatalogList =
        context.watch<SemenCatalogController>().semenCatalogsList;

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
                                        .pushNamed("addSemenCatalogDetails"),
                                    label: const Text("New"),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: FilterInputField(
                                  onQueryChanged: context
                                      .read<SemenCatalogController>()
                                      .filterSemenCatalogs)),
                        ],
                      )))),
        ),
        PaginatedDataTable(
            header: const Text(DisplayTextUtil.semenCatalogsList),
            rowsPerPage: 20,
            availableRowsPerPage: const [20, 30, 50],
            sortAscending: false,
            sortColumnIndex: 0,
            columns: const [
              DataColumn(label: Text("Purchase Date")),
              DataColumn(label: Text("Bull Code")),
              DataColumn(label: Text("Bull Name")),
              DataColumn(label: Text("Breed")),
              DataColumn(label: Text("Number of Straws")),
              DataColumn(label: Text("Cost Per Straw")),
              DataColumn(label: Text("Supplier")),
              DataColumn(label: Text("Edit")),
              DataColumn(label: Text("Delete")),
            ],
            source: _DataSource(data: _semenCatalogList, context: context))
      ]),
    ));
  }
}

class _DataSource extends DataTableSource {
  final List<SemenCatalog> data;
  final BuildContext context;
  _DataSource({required this.data, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.getPurchaseDate ?? '')),
      DataCell(Text(item.getBullCode)),
      DataCell(Text(item.getBullName)),
      DataCell(Text(item.getBreed)),
      DataCell(Text('${item.getNumberOfStraws}')),
      DataCell(Text('${item.getCostPerStraw}')),
      DataCell(Text(item.getSupplier)),
      DataCell(const Icon(Icons.edit),
          onTap: () => context.pushNamed("editSemenCatalogDetails",
              pathParameters: {"editSemenCatalogId": '${item.getId}'})),
      DataCell(const Icon(Icons.delete), onTap: () async {
        deleteFunc() async {
          return await context
              .read<SemenCatalogController>()
              .deleteSemenCatalog(item);
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
