import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/controllers/cow_death_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_death.dart';
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

class CowDeathInputScreen extends StatefulWidget {
  const CowDeathInputScreen({super.key, this.editCowDeathId});
  final String? editCowDeathId;
  static const String addDetailsRoutePath = "/addCowDeathDetails";
  static const String editDetailsRoutePath =
      "/editCowDeathDetails/:editCowDeathId";

  @override
  CowDeathFormState createState() {
    return CowDeathFormState();
  }
}

class CowDeathFormState extends State<CowDeathInputScreen> {
  final TextEditingController _cowDeathDateController = TextEditingController();
  final TextEditingController _cowDeathDetailsController =
      TextEditingController();
  final TextEditingController _cowDeathVetNameController =
      TextEditingController();
  final TextEditingController _cowDeathCostController = TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;

  CowDeath? _cowDeathToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _cowDeathCostController.dispose();
    _cowDeathDateController.dispose();
    _cowDeathVetNameController.dispose();
    _cowDeathDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editCowDeathId = widget.editCowDeathId;
    if (editCowDeathId != null) {
      final cowDeathsList = context.read<CowDeathController>().cowDeathsList;
      _cowDeathToEdit = cowDeathsList.firstWhereOrNull(
        (cowDeath) => cowDeath.getId == editCowDeathId,
      );
      _cowDeathDateController.value =
          TextEditingValue(text: _cowDeathToEdit?.getDateOfDeath ?? '');
      _cowDeathDetailsController.value =
          TextEditingValue(text: _cowDeathToEdit?.getCauseOfDeath ?? '');
      _cowDeathCostController.value =
          TextEditingValue(text: '${_cowDeathToEdit?.getCowDeathCost}');
      _cowDeathVetNameController.value =
          TextEditingValue(text: _cowDeathToEdit?.getVetName ?? '');
      setState(() {
        selectedCow = _cowDeathToEdit?.getCow;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editCowDeathId != null
                ? 'Edit ${DisplayTextUtil.cowDeathDetails}'
                : 'New ${DisplayTextUtil.cowDeathDetails}',
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          inputFieldLabel(
                            context,
                            "Death Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _cowDeathDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _cowDeathDateController.text)),
                          inputFieldLabel(context, "Select Cow"),
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
                                  enabled: true,
                                );
                              }).toList(),
                            ),
                          ),
                          inputFieldLabel(
                            context,
                            "Cause of Death",
                          ),
                          MyDefaultTextField(
                            controller: _cowDeathDetailsController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                          ),
                          inputFieldLabel(
                            context,
                            "Vet Name",
                          ),
                          MyDefaultTextField(
                            controller: _cowDeathVetNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
                            controller: _cowDeathCostController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cost cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Cost must be a number";
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
                          String dateOfDeath =
                              _cowDeathDateController.text.trim();
                          String causeOfDeath =
                              _cowDeathDetailsController.text.trim();
                          String vetName =
                              _cowDeathVetNameController.text.trim();
                          String cowDeathCost =
                              _cowDeathCostController.text.trim();
                          //edit the properties that require editing
                          final newCowDeath = CowDeath();
                          newCowDeath.setCauseOfDeath = causeOfDeath;
                          newCowDeath.setDateOfDeath = dateOfDeath;
                          newCowDeath.setCowDeathCost =
                              double.parse(cowDeathCost);
                          newCowDeath.setVetName = vetName;
                          newCowDeath.setCow = selectedCow!;

                          if (editCowDeathId != null) {
                            newCowDeath.setId = editCowDeathId;
                            //update the cowDeath  in the db
                            await context
                                .read<CowDeathController>()
                                .editCowDeath(newCowDeath)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Cow death edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the _cowDeathToEdit in the db
                            await context
                                .read<CowDeathController>()
                                .addCowDeath(newCowDeath)
                                .then((value) {
                              //reset the form
                              _formKey.currentState?.reset();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Cow death added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save Death")
                ],
              )),
        )));
  }
}
