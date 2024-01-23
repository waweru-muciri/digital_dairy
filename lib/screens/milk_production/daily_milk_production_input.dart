import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:DigitalDairy/util/utils.dart';

class DailyMilkProductionInputScreen extends StatefulWidget {
  const DailyMilkProductionInputScreen(
      {super.key, this.editDailyMilkProductionId});
  final String? editDailyMilkProductionId;
  static const String addDetailsRoutePath =
      "/add_daily_milk_production_details";
  static const String editDetailsRoutePath =
      "/edit_daily_milk_production_details/:editDailyMilkProductionId";

  @override
  DailyMilkProductionFormState createState() {
    return DailyMilkProductionFormState();
  }
}

class DailyMilkProductionFormState
    extends State<DailyMilkProductionInputScreen> {
  final TextEditingController _dateController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _amAmountController =
      TextEditingController(text: "0");
  final TextEditingController _noonAmountController =
      TextEditingController(text: "0");

  final TextEditingController _pmAmountController =
      TextEditingController(text: "0");

  final TextEditingController _cowFilterController = TextEditingController();
  late List<Cow> _cowsList;
  late DailyMilkProduction _dailyMilkProduction;
  Cow? selectedCow;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of milk consumers
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _cowFilterController.dispose();
    _dateController.dispose();
    _amAmountController.dispose();
    _noonAmountController.dispose();
    _pmAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editDailyMilkProductionId = widget.editDailyMilkProductionId;
    if (editDailyMilkProductionId != null) {
      final cowsList = context
          .read<DailyMilkProductionController>()
          .dailyMilkProductionsList;
      _dailyMilkProduction = cowsList.firstWhere(
          (cow) => cow.getId == editDailyMilkProductionId,
          orElse: () => DailyMilkProduction());
      _dateController.value =
          TextEditingValue(text: _dailyMilkProduction.getMilkProductionDate);
      _amAmountController.value =
          TextEditingValue(text: '${_dailyMilkProduction.getAmQuantity}');
      _noonAmountController.value =
          TextEditingValue(text: '${_dailyMilkProduction.getNoonQuantity}');
      _pmAmountController.value =
          TextEditingValue(text: '${_dailyMilkProduction.getPmQuantity}');
      setState(() {
        selectedCow = _dailyMilkProduction.getCow;
      });
    } else {
      _dailyMilkProduction = DailyMilkProduction();
    } // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editDailyMilkProductionId != null
                ? 'Edit ${DisplayTextUtil.dailyMilkProductionDetails}'
                : 'New ${DisplayTextUtil.dailyMilkProductionDetails}',
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
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
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
                                                editDailyMilkProductionId !=
                                                        null
                                                    ? DateFormat("dd/MM/yyyy")
                                                        .parse(_dailyMilkProduction
                                                            .getMilkProductionDate)
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Am Quantity",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _amAmountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Am Quantity cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Am Quantity must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: textFormFieldDecoration,
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Noon Quantity",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _noonAmountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Noon Quantity cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Noon Quantity must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: textFormFieldDecoration,
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Pm Quantity",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _amAmountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pm Quantity cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Pm Quantity must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: textFormFieldDecoration,
                              ))
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          double amQuantity =
                              double.parse(_amAmountController.text.trim());
                          double noonQuantity =
                              double.parse(_noonAmountController.text.trim());
                          double pmQuantity =
                              double.parse(_pmAmountController.text.trim());
                          //modify the fields as appropriate
                          _dailyMilkProduction.setMilkProductionDate =
                              _dateController.text;
                          _dailyMilkProduction.setAmQuantity = amQuantity;
                          _dailyMilkProduction.setNoonQuantity = noonQuantity;
                          _dailyMilkProduction.setPmQuantity = pmQuantity;
                          _dailyMilkProduction.setCow = selectedCow!;
                          //save the data in the database
                          if (editDailyMilkProductionId != null) {
                            //update the milk consumption details in the db
                            await context
                                .read<DailyMilkProductionController>()
                                .editDailyMilkProduction(_dailyMilkProduction)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk Production edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the cow in the db
                            await context
                                .read<DailyMilkProductionController>()
                                .addDailyMilkProduction(_dailyMilkProduction)
                                .then((value) {
                              //reset the form
                              _cowFilterController.clear();
                              setState(() {
                                selectedCow = null;
                              });
                              _amAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk Production added successfully."));
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
