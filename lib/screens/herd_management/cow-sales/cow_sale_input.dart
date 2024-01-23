import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/cow_sale_controller.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remarksController =
      TextEditingController(text: "");
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;

  late CowSale cowSaleToSave;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editCowSaleId = widget.editCowSaleId;
    if (editCowSaleId != null) {
      final cowSalesList = context.read<CowSaleController>().cowSalesList;
      cowSaleToSave = cowSalesList.firstWhere(
          (cowSaleToSave) => cowSaleToSave.getId == editCowSaleId,
          orElse: () => CowSale());
      _clientNameController.value =
          TextEditingValue(text: '$cowSaleToSave.getClientName');
      _dateController.value =
          TextEditingValue(text: cowSaleToSave.getCowSaleDate);
      _remarksController.value =
          TextEditingValue(text: '${cowSaleToSave.getRemarks}');
      _costController.value =
          TextEditingValue(text: '${cowSaleToSave.getCowSaleCost}');

      setState(() {
        selectedCow = cowSaleToSave.getCow;
      });
    } else {
      cowSaleToSave = CowSale();
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Date",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _dateController,
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
                                                editCowSaleId != null
                                                    ? DateFormat("dd/MM/yyyy")
                                                        .parse(cowSaleToSave
                                                            .getCowSaleDate)
                                                    : DateTime.now());
                                        _dateController.text =
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Select Cow",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<Cow>(
                              initialSelection: selectedCow,
                              controller: _cowController,
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Client Name",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _clientNameController,
                                decoration: textFormFieldDecoration,
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Cost",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
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
                                decoration: textFormFieldDecoration,
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Remarks",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _remarksController,
                                keyboardType: TextInputType.text,
                                decoration: textFormFieldDecoration,
                              )),
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
                          cowSaleToSave.setRemarks = remarks;
                          cowSaleToSave.setCowSaleDate = date;
                          cowSaleToSave.setCowSaleCost = double.parse(cost);
                          cowSaleToSave.setClientName = clientName;
                          cowSaleToSave.setCow = selectedCow!;

                          if (editCowSaleId != null) {
                            //update the cowSale  in the db
                            await context
                                .read<CowSaleController>()
                                .editCowSale(cowSaleToSave)
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
                            //add the cowSaleToSave in the db
                            await context
                                .read<CowSaleController>()
                                .addCowSale(cowSaleToSave)
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
