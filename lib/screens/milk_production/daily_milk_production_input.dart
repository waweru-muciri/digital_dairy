import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _amAmountController =
      TextEditingController(text: "");
  final TextEditingController _noonAmountController =
      TextEditingController(text: "");

  final TextEditingController _pmAmountController =
      TextEditingController(text: "");

  final TextEditingController _cowFilterController = TextEditingController();
  late List<Cow> _cowsList;
  DailyMilkProduction? _dailyMilkProductionToEdit;
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
      _dailyMilkProductionToEdit = cowsList.firstWhereOrNull(
        (cow) => cow.getId == editDailyMilkProductionId,
      );
      _dateController.text =
          _dailyMilkProductionToEdit?.getMilkProductionDate ?? '';
      _amAmountController.text = '${_dailyMilkProductionToEdit?.getAmQuantity}';
      _noonAmountController.text =
          '${_dailyMilkProductionToEdit?.getNoonQuantity}';
      _pmAmountController.text = '${_dailyMilkProductionToEdit?.getPmQuantity}';
      setState(() {
        selectedCow = _dailyMilkProductionToEdit?.getCow;
      });
    }
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
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
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
                          inputFieldLabel(
                            context,
                            "Date",
                          ),
                          MyDefaultDateInputTextField(
                            controller: _dateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date cannot be empty';
                              }
                              return null;
                            },
                            initialDate:
                                getDateFromString(_dateController.text),
                          ),
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
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              dropdownMenuEntries: _cowsList
                                  .map<DropdownMenuEntry<Cow>>((Cow cow) {
                                return DropdownMenuEntry<Cow>(
                                  value: cow,
                                  label: cow.cowName,
                                  labelWidget: Text(cow.cowName),
                                  enabled: true,
                                );
                              }).toList(),
                            ),
                          ),
                          inputFieldLabel(
                            context,
                            "Am Quantity",
                          ),
                          MyDefaultTextField(
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
                          ),
                          inputFieldLabel(
                            context,
                            "Noon Quantity",
                          ),
                          MyDefaultTextField(
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
                          ),
                          inputFieldLabel(
                            context,
                            "Pm Quantity",
                          ),
                          MyDefaultTextField(
                            controller: _pmAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pm Quantity cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Pm Quantity must be a number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          )
                        ],
                      )),
                  SaveButton(
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
                          DailyMilkProduction newDailyMilkProduction =
                              DailyMilkProduction();
                          newDailyMilkProduction.setMilkProductionDate =
                              _dateController.text;
                          newDailyMilkProduction.setAmQuantity = amQuantity;
                          newDailyMilkProduction.setNoonQuantity = noonQuantity;
                          newDailyMilkProduction.setPmQuantity = pmQuantity;
                          newDailyMilkProduction.setCow = selectedCow!;
                          //save the data in the database
                          if (editDailyMilkProductionId != null) {
                            newDailyMilkProduction.setId =
                                editDailyMilkProductionId;
                            //update the milk consumption details in the db
                            await context
                                .read<DailyMilkProductionController>()
                                .editDailyMilkProduction(newDailyMilkProduction)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk production edited successfully!"));
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
                                .addDailyMilkProduction(newDailyMilkProduction)
                                .then((value) {
                              //reset the form
                              _amAmountController.clear();
                              _noonAmountController.clear();
                              _pmAmountController.clear();
                              setState(() {
                                selectedCow = null;
                              });
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk production added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save")
                ],
              )),
        )));
  }
}
