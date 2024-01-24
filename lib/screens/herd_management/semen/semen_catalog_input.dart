import 'package:DigitalDairy/controllers/semen_catalog_controller.dart';
import 'package:DigitalDairy/models/semen_catalog.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
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
      TextEditingController(text: getTodaysDateAsString());

  SemenCatalog? _semenCatalogToEdit;
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
      _semenCatalogToEdit = semenCatalogsList.firstWhereOrNull(
          (semenCatalog) => semenCatalog.getId == editSemenCatalogId);
      _bullCodeController.value =
          TextEditingValue(text: _semenCatalogToEdit?.getBullCode);
      _bullNameController.value =
          TextEditingValue(text: _semenCatalogToEdit?.getBullName);
      _breedController.value =
          TextEditingValue(text: _semenCatalogToEdit?.getBreed);
      _numberOfStrawsController.value =
          TextEditingValue(text: '${_semenCatalogToEdit?.getNumberOfStraws}');
      _costPerStrawController.value =
          TextEditingValue(text: '${_semenCatalogToEdit?.getCostPerStraw}');
      _supplierController.value =
          TextEditingValue(text: _semenCatalogToEdit?.getSupplier ?? '');
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 36),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  inputFieldLabel(
                                    context,
                                    "Bull Code",
                                  ),
                                  MyDefaultTextField(
                                    controller: _bullCodeController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Bull code cannot be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  inputFieldLabel(
                                    context,
                                    "Bull Name",
                                  ),
                                  MyDefaultTextField(
                                    controller: _bullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Bull name be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  inputFieldLabel(
                                    context,
                                    "Breed",
                                  ),
                                  MyDefaultTextField(
                                    controller: _breedController,
                                  ),
                                  inputFieldLabel(context, "Number of straws"),
                                  MyDefaultTextField(
                                    controller: _numberOfStrawsController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Number of straws cannot be empty';
                                      } else if (double.tryParse(value) ==
                                          null) {
                                        return "Number of straws must be a number";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  inputFieldLabel(
                                    context,
                                    "Cost per straw",
                                  ),
                                  MyDefaultTextField(
                                    controller: _costPerStrawController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Cost per straw cannot be empty';
                                      } else if (double.tryParse(value) ==
                                          null) {
                                        return "Cost per straw must be a number";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  inputFieldLabel(
                                    context,
                                    "Supplier",
                                  ),
                                  MyDefaultTextField(
                                    controller: _supplierController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Supplier cannot be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  inputFieldLabel(
                                    context,
                                    "Purchase Date",
                                  ),
                                  MyDefaultDateInputTextField(
                                      controller: _purchaseDateController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Date cannot be empty';
                                        }
                                        return null;
                                      },
                                      initialDate: getDateFromString(
                                          _purchaseDateController.text))
                                ])),
                        saveButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                //show a loading dialog to the user while we save the info
                                showLoadingDialog(context);
                                String bullCode =
                                    _bullCodeController.text.trim();
                                String bullName =
                                    _bullNameController.text.trim();
                                String bullBreed = _breedController.text.trim();
                                String supplierName =
                                    _supplierController.text.trim();
                                double costPerStraw = double.parse(
                                    _costPerStrawController.text.trim());
                                int numberOfStraws = int.parse(
                                    _numberOfStrawsController.text.trim());
                                //edit the properties that require editing
                                final newSemenCatalog = SemenCatalog();
                                newSemenCatalog.setBullName = bullName;
                                newSemenCatalog.setBreed = bullBreed;
                                newSemenCatalog.setBullCode = bullCode;
                                newSemenCatalog.setCostPerStraw = costPerStraw;
                                newSemenCatalog.setNumberOfStraws =
                                    numberOfStraws;
                                newSemenCatalog.setSupplierName = supplierName;

                                if (editSemenCatalogId != null) {
                                  newSemenCatalog.setId = editSemenCatalogId;
                                  //update the newSemenCatalog in the db
                                  await context
                                      .read<SemenCatalogController>()
                                      .editSemenCatalog(newSemenCatalog)
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
                                  //add the newSemenCatalog in the db
                                  await context
                                      .read<SemenCatalogController>()
                                      .addSemenCatalog(newSemenCatalog)
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
                      ]),
                ))));
  }
}
