import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/cow_sale_controller.dart';
import 'package:provider/provider.dart';

class CowSaleInputScreen extends StatefulWidget {
  const CowSaleInputScreen({super.key, this.editCowSaleId});
  final String? editCowSaleId;
  static const String addDetailsRoutePath = "/add_cowSale_details";
  static const String editDetailsRoutePath =
      "/edit_cow_sale_details/:editCowSaleId";

  @override
  CowSaleFormState createState() {
    return CowSaleFormState();
  }
}

class CowSaleFormState extends State<CowSaleInputScreen> {
  final TextEditingController _clientNameController =
      TextEditingController(text: "");
  final TextEditingController _dateController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _remarksController =
      TextEditingController(text: "");
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _cowFilterController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;

  CowSale? cowSaleToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _costController.dispose();
    _dateController.dispose();
    _remarksController.dispose();
    _cowFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editCowSaleId = widget.editCowSaleId;
    if (editCowSaleId != null) {
      final cowSalesList = context.read<CowSaleController>().cowSalesList;
      cowSaleToEdit = cowSalesList.firstWhereOrNull(
        (cowSaleToEdit) => cowSaleToEdit.getId == editCowSaleId,
      );
      _clientNameController.value =
          TextEditingValue(text: '${cowSaleToEdit?.getClientName}');
      _dateController.value =
          TextEditingValue(text: "${cowSaleToEdit?.getCowSaleDate}");
      _remarksController.value =
          TextEditingValue(text: '${cowSaleToEdit?.getRemarks}');
      _costController.value =
          TextEditingValue(text: '${cowSaleToEdit?.getCowSaleCost}');

      setState(() {
        selectedCow = cowSaleToEdit!.getCow;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editCowSaleId != null
                ? 'Edit ${DisplayTextUtil.cowSaleDetails}'
                : 'New ${DisplayTextUtil.cowSaleDetails}',
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
                          inputFieldLabel(
                            context,
                            "Date",
                          ),
                          DefaultDateTextField(
                              controller: _dateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate:
                                  getDateFromString(_dateController.text)),
                          inputFieldLabel(context, "Select Cow"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<Cow>(
                              initialSelection: selectedCow,
                              controller: _cowFilterController,
                              requestFocusOnTap: true,
                              expandedInsets: EdgeInsets.zero,
                              onSelected: (Cow? cow) {
                                setState(() {
                                  selectedCow = cow;
                                });
                              },
                              errorText: selectedCow == null
                                  ? 'Cow cannot be empty!'
                                  : null,
                              enableFilter: true,
                              enableSearch: true,
                              inputDecorationTheme: const InputDecorationTheme(
                                  isDense: true, border: OutlineInputBorder()),
                              dropdownMenuEntries: _cowsList
                                  .map<DropdownMenuEntry<Cow>>((Cow cow) {
                                return DropdownMenuEntry<Cow>(
                                  value: cow,
                                  label: cow.cowName,
                                  enabled: true,
                                );
                              }).toList(),
                            ),
                          ),
                          inputFieldLabel(
                            context,
                            "Client Name",
                          ),
                          MyDefaultTextField(
                            controller: _clientNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
                            controller: _costController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cost cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Cost must be a number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          inputFieldLabel(
                            context,
                            "Remarks",
                          ),
                          MyDefaultTextField(
                            controller: _remarksController,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String date = _dateController.text.trim();
                          String remarks = _remarksController.text.trim();
                          String clientName = _clientNameController.text.trim();
                          String cost = _costController.text.trim();
                          //edit the properties that require editing
                          final newCowSale = CowSale();
                          newCowSale.setRemarks = remarks;
                          newCowSale.setCowSaleDate = date;
                          newCowSale.setCowSaleCost = double.parse(cost);
                          newCowSale.setClientName = clientName;
                          newCowSale.setCow = selectedCow!;

                          if (editCowSaleId != null) {
                            //set the id of the object instance
                            newCowSale.setId = editCowSaleId;
                            //update the cow sale  in the db
                            await context
                                .read<CowSaleController>()
                                .editCowSale(newCowSale)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Cow Sale edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the newCowSale in the db
                            await context
                                .read<CowSaleController>()
                                .addCowSale(newCowSale)
                                .then((value) {
                              //reset the form
                              _clientNameController.clear();
                              _dateController.clear();
                              _remarksController.clear();
                              _costController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Cow Sale added successfully."));
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
