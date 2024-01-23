import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/treatment.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/treatment_controller.dart';
import 'package:provider/provider.dart';

class TreatmentInputScreen extends StatefulWidget {
  const TreatmentInputScreen({super.key, this.editTreatmentId});
  final String? editTreatmentId;
  static const String addDetailsRoutePath = "/add_treatment_details";
  static const String editDetailsRoutePath =
      "/edit_treatment_details/:editTreatmentId";

  @override
  TreatmentFormState createState() {
    return TreatmentFormState();
  }
}

class TreatmentFormState extends State<TreatmentInputScreen> {
  final TextEditingController _treatmentDiagnosisController =
      TextEditingController();
  final TextEditingController _treatmentDateController =
      TextEditingController();
  final TextEditingController _treatmentDetailsController =
      TextEditingController();
  final TextEditingController _treatmentVetNameController =
      TextEditingController();
  final TextEditingController _treatmentCostController =
      TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;

  late Treatment treatmentToSave;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _treatmentDiagnosisController.dispose();
    _treatmentCostController.dispose();
    _treatmentDateController.dispose();
    _treatmentVetNameController.dispose();
    _treatmentDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editTreatmentId = widget.editTreatmentId;
    if (editTreatmentId != null) {
      final treatmentsList = context.read<TreatmentController>().treatmentsList;
      treatmentToSave = treatmentsList.firstWhere(
          (treatmentToSave) => treatmentToSave.getId == editTreatmentId,
          orElse: () => Treatment());
      _treatmentDiagnosisController.value =
          TextEditingValue(text: treatmentToSave.getDiagnosis);
      _treatmentDateController.value =
          TextEditingValue(text: treatmentToSave.getTreatmentDate);
      _treatmentDetailsController.value =
          TextEditingValue(text: treatmentToSave.getTreatment);
      _treatmentCostController.value =
          TextEditingValue(text: '${treatmentToSave.getTreatmentCost}');
      _treatmentVetNameController.value =
          TextEditingValue(text: treatmentToSave.getVetName);
      setState(() {
        selectedCow = treatmentToSave.getCow;
      });
    } else {
      treatmentToSave = Treatment();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editTreatmentId != null
                ? 'Edit ${DisplayTextUtil.treatmentDetails}'
                : 'New ${DisplayTextUtil.treatmentDetails}',
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
                            "Treatment Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _treatmentDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  treatmentToSave.getTreatmentDate)),
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
                            "Diagnosis",
                          ),
                          MyDefaultTextField(
                            controller: _treatmentDiagnosisController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Diagnosis cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Treatment Details",
                          ),
                          MyDefaultTextField(
                            controller: _treatmentDetailsController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                          ),
                          inputFieldLabel(
                            context,
                            "Vet Name",
                          ),
                          MyDefaultTextField(
                            controller: _treatmentVetNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
                            controller: _treatmentCostController,
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
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String diagnosis =
                              _treatmentDiagnosisController.text.trim();
                          String treatmentDate =
                              _treatmentDateController.text.trim();
                          String treatmentDetails =
                              _treatmentDetailsController.text.trim();
                          String vetName =
                              _treatmentVetNameController.text.trim();
                          String treatmentCost =
                              _treatmentCostController.text.trim();
                          //edit the properties that require editing
                          treatmentToSave.setTreatment = treatmentDetails;
                          treatmentToSave.setTreatmentDate = treatmentDate;
                          treatmentToSave.setDiagnosis = diagnosis;
                          treatmentToSave.setTreatmentCost =
                              double.parse(treatmentCost);
                          treatmentToSave.setVetName = vetName;
                          treatmentToSave.setCow = selectedCow!;

                          if (editTreatmentId != null) {
                            //update the treatment  in the db
                            await context
                                .read<TreatmentController>()
                                .editTreatment(treatmentToSave)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Treatment edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the treatmentToSave in the db
                            await context
                                .read<TreatmentController>()
                                .addTreatment(treatmentToSave)
                                .then((value) {
                              //reset the form
                              _treatmentDiagnosisController.clear();
                              _treatmentDateController.clear();
                              _treatmentDetailsController.clear();
                              _treatmentVetNameController.clear();
                              _treatmentCostController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Treatment added successfully."));
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
