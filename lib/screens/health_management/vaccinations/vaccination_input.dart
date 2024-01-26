import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/vaccination.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/vaccination_controller.dart';
import 'package:provider/provider.dart';

class VaccinationInputScreen extends StatefulWidget {
  const VaccinationInputScreen({super.key, this.editVaccinationId});
  final String? editVaccinationId;
  static const String addDetailsRoutePath = "/add_vaccination_details";
  static const String editDetailsRoutePath =
      "/edit_vaccination_details/:editVaccinationId";

  @override
  VaccinationFormState createState() {
    return VaccinationFormState();
  }
}

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

  Vaccination? _vaccinationToEdit;

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
      _vaccinationToEdit = vaccinationsList.firstWhereOrNull(
        (vaccination) => vaccination.getId == editVaccinationId,
      );
      _vaccinationDateController.value =
          TextEditingValue(text: _vaccinationToEdit?.getVaccinationDate ?? '');
      _vaccinationDetailsController.value =
          TextEditingValue(text: _vaccinationToEdit?.getVaccinationDate ?? '');
      _vaccinationCostController.value =
          TextEditingValue(text: '${_vaccinationToEdit?.getVaccinationCost}');
      _vaccinationVetNameController.value =
          TextEditingValue(text: _vaccinationToEdit?.getVaccinationDate ?? '');
      setState(() {
        selectedCow = _vaccinationToEdit?.getCow;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editVaccinationId != null
                ? 'Edit ${DisplayTextUtil.vaccinationDetails}'
                : 'New ${DisplayTextUtil.vaccinationDetails}',
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
                            "Vaccination Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _vaccinationDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _vaccinationDateController.text)),
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
                            "Vaccination Details",
                          ),
                          MyDefaultTextField(
                            controller: _vaccinationDetailsController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                          ),
                          inputFieldLabel(
                            context,
                            "Vet Name",
                          ),
                          MyDefaultTextField(
                            controller: _vaccinationVetNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
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
                          )
                        ],
                      )),
                  SaveButton(
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
                          final newVaccination = Vaccination();
                          newVaccination.setVaccination = vaccinationDetails;
                          newVaccination.setVaccinationDate = vaccinationDate;
                          newVaccination.setCow = selectedCow!;
                          newVaccination.setVaccinationCost =
                              double.parse(vaccinationCost);
                          newVaccination.setVetName = vetName;

                          if (editVaccinationId != null) {
                            newVaccination.setId = editVaccinationId;
                            //update the vaccination  in the db
                            await context
                                .read<VaccinationController>()
                                .editVaccination(newVaccination)
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
                            //add the _vaccinationToEdit in the db
                            await context
                                .read<VaccinationController>()
                                .addVaccination(newVaccination)
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
                      text: "Save Details")
                ],
              )),
        )));
  }
}
