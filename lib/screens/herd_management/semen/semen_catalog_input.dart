import 'package:DigitalDairy/controllers/semen_catalog_controller.dart';
import 'package:DigitalDairy/models/semen_catalog.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemenCatalogInputScreen extends StatefulWidget {
  const SemenCatalogInputScreen({super.key, this.editSemenCatalogId});
  final String? editSemenCatalogId;
  static const String addDetailsRoutePath = "/add_semenCatalog_details";
  static const String editDetailsRoutePath =
      "/edit_semenCatalog_details/:editSemenCatalogId";

  @override
  SemenCatalogFormState createState() {
    return SemenCatalogFormState();
  }
}

class SemenCatalogFormState extends State<SemenCatalogInputScreen> {
  final TextEditingController _bullCodeController = TextEditingController();
  final TextEditingController _bullNameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _numberOfStrawsController =
      TextEditingController();
  final TextEditingController _costPerStrawController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _purchaseDateController =
      TextEditingController(text: getStringFromDate(DateTime.now()));

  late SemenCatalog semenCatalog;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bullCodeController.dispose();
    _bullNameController.dispose();
    _breedController.dispose();
    _numberOfStrawsController.dispose();
    _costPerStrawController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editSemenCatalogId = widget.editSemenCatalogId;
    if (editSemenCatalogId != null) {
      final semenCatalogsList =
          context.read<SemenCatalogController>().semenCatalogsList;
      semenCatalog = semenCatalogsList.firstWhere(
          (semenCatalog) => semenCatalog.getId == editSemenCatalogId,
          orElse: () => SemenCatalog());
      _bullCodeController.value =
          TextEditingValue(text: semenCatalog.getBullCode);
      _bullNameController.value =
          TextEditingValue(text: semenCatalog.getBullName);
      _breedController.value = TextEditingValue(text: semenCatalog.getBreed);
      _numberOfStrawsController.value =
          TextEditingValue(text: '${semenCatalog.getNumberOfStraws}');
      _costPerStrawController.value =
          TextEditingValue(text: '${semenCatalog.getCostPerStraw}');
      _supplierController.value =
          TextEditingValue(text: semenCatalog.getSupplier);
    } else {
      semenCatalog = SemenCatalog();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editSemenCatalogId != null
                ? 'Edit ${DisplayTextUtil.semenCatalogDetails}'
                : 'New ${DisplayTextUtil.semenCatalogDetails}',
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Bull Code",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _bullCodeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bull code cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Bull Name",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _bullNameController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bull name be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Breed",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _breedController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Number of straws",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _numberOfStrawsController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Number of straws cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Number of straws must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Cost per straw",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _costPerStrawController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Cost per straw cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Cost per straw must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Supplier",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _supplierController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Supplier cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _purchaseDateController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  hintText: 'Date',
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime? pickedDateTime =
                                            await showCustomDatePicker(
                                                context,
                                                getDateFromString(
                                                    _purchaseDateController
                                                        .text));
                                        _purchaseDateController.text =
                                            getStringFromDate(pickedDateTime);
                                      },
                                      icon: const Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: Icon(
                                            Icons.calendar_month,
                                          ))),
                                ),
                              )),
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String bullCode = _bullCodeController.text.trim();
                          String bullName = _bullNameController.text.trim();
                          String bullBreed = _breedController.text.trim();
                          String supplierName = _supplierController.text.trim();
                          double costPerStraw =
                              double.parse(_costPerStrawController.text.trim());
                          int numberOfStraws =
                              int.parse(_numberOfStrawsController.text.trim());
                          //edit the properties that require editing
                          semenCatalog.setBullName = bullName;
                          semenCatalog.setBreed = bullBreed;
                          semenCatalog.setBullCode = bullCode;
                          semenCatalog.setCostPerStraw = costPerStraw;
                          semenCatalog.setNumberOfStraws = numberOfStraws;
                          semenCatalog.setSupplierName = supplierName;

                          if (editSemenCatalogId != null) {
                            //update the semenCatalog in the db
                            await context
                                .read<SemenCatalogController>()
                                .editSemenCatalog(semenCatalog)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Semen Catalog edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the semenCatalog in the db
                            await context
                                .read<SemenCatalogController>()
                                .addSemenCatalog(semenCatalog)
                                .then((value) {
                              //reset the form
                              _bullCodeController.clear();
                              _bullNameController.clear();
                              _breedController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Semen Catalog added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      child: const Text("Save Details"))
                ],
              )),
        )));
  }
}
