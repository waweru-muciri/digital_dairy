import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/vaccination.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/vaccination_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class VaccinationInputScreen extends StatefulWidget {
  const VaccinationInputScreen({super.key, this.editVaccinationId});
  final String? editVaccinationId;
  static const String addDetailsRouteName = "/add_vaccination_details";
  static const String editDetailsRouteName =
      "/edit_vaccination_details/:editVaccinationId";

  @override
  VaccinationFormState createState() {
    return VaccinationFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class VaccinationFormState extends State<VaccinationInputScreen> {
  final TextEditingController _vaccinationDateController =
      TextEditingController();
  final TextEditingController _vaccinationDetailsController =
      TextEditingController();
  final TextEditingController _vaccinationVetNameController =
      TextEditingController();
  final TextEditingController _vaccinationCostController =
      TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;

  late Vaccination vaccinationToSave;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<VaccinationFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _vaccinationCostController.dispose();
    _vaccinationDateController.dispose();
    _vaccinationVetNameController.dispose();
    _vaccinationDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editVaccinationId = widget.editVaccinationId;
    if (editVaccinationId != null) {
      final vaccinationsList =
          context.read<VaccinationController>().vaccinationsList;
      vaccinationToSave = vaccinationsList.firstWhere(
          (vaccinationToSave) => vaccinationToSave.getId == editVaccinationId,
          orElse: () => Vaccination());
      _vaccinationDateController.value =
          TextEditingValue(text: vaccinationToSave.getVaccinationDate);
      _vaccinationDetailsController.value =
          TextEditingValue(text: vaccinationToSave.getVaccination);
      _vaccinationCostController.value =
          TextEditingValue(text: '${vaccinationToSave.getVaccinationCost}');
      _vaccinationVetNameController.value =
          TextEditingValue(text: vaccinationToSave.getVetName);
      setState(() {
        selectedCow = vaccinationToSave.getCow;
      });
    } else {
      vaccinationToSave = Vaccination();
    }
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editVaccinationId != null
                ? 'Edit ${DisplayTextUtil.vaccinationDetails}'
                : 'Add ${DisplayTextUtil.vaccinationDetails}',
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
                            child: Text("Vaccination Date",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _vaccinationDateController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Date',
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime pickedDateTime =
                                            await selectDate(
                                                context,
                                                editVaccinationId != null
                                                    ? DateFormat("dd/MM/yyyy")
                                                        .parse(vaccinationToSave
                                                            .getVaccinationDate)
                                                    : DateTime.now());
                                        _vaccinationDateController.text =
                                            DateFormat("dd/MM/yyyy")
                                                .format(pickedDateTime);
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
                              "Vaccination Details",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _vaccinationDetailsController,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Vet Name",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _vaccinationVetNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
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
                                controller: _vaccinationCostController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Quantity cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Quantity must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ))
                        ],
                      )),
                  OutlinedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String vaccinationDate =
                              _vaccinationDateController.text.trim();
                          String vaccinationDetails =
                              _vaccinationDetailsController.text.trim();
                          String vetName =
                              _vaccinationVetNameController.text.trim();
                          String vaccinationCost =
                              _vaccinationCostController.text.trim();
                          //edit the properties that require editing
                          vaccinationToSave.setVaccination = vaccinationDetails;
                          vaccinationToSave.setVaccinationDate =
                              vaccinationDate;
                          vaccinationToSave.setCow = selectedCow!;
                          vaccinationToSave.setVaccinationCost =
                              double.parse(vaccinationCost);
                          vaccinationToSave.setVetName = vetName;

                          if (editVaccinationId != null) {
                            //update the vaccination  in the db
                            await context
                                .read<VaccinationController>()
                                .editVaccination(vaccinationToSave)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Vaccination edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the vaccinationToSave in the db
                            await context
                                .read<VaccinationController>()
                                .addVaccination(vaccinationToSave)
                                .then((value) {
                              //reset the form
                              _vaccinationDateController.clear();
                              _vaccinationDetailsController.clear();
                              _vaccinationVetNameController.clear();
                              _vaccinationCostController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Vaccination added successfully."));
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