import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/controllers/pregnancy_diagnosis_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_pregnancy_diagnosis.dart';
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

class PregnancyDiagnosisInputScreen extends StatefulWidget {
  const PregnancyDiagnosisInputScreen(
      {super.key, this.editPregnancyDiagnosisId});
  final String? editPregnancyDiagnosisId;
  static const String addDetailsRoutePath = "/add_pregnancy_diagnosis_details";
  static const String editDetailsRoutePath =
      "/edit_pregnancy_diagnosis_details/:editPregnancyDiagnosisId";

  @override
  PregnancyDiagnosisFormState createState() {
    return PregnancyDiagnosisFormState();
  }
}

class PregnancyDiagnosisFormState extends State<PregnancyDiagnosisInputScreen> {
  final TextEditingController _pregnancyDiagnosisDiagnosisController =
      TextEditingController();
  final TextEditingController _pregnancyDiagnosisDateController =
      TextEditingController();
  final TextEditingController _pregnancyDiagnosisVetNameController =
      TextEditingController();
  final TextEditingController _pregnancyDiagnosisCostController =
      TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;
  bool pregnancyResultPositive = true;

  PregnancyDiagnosis? _pregnancyDiagnosisToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _pregnancyDiagnosisDiagnosisController.dispose();
    _pregnancyDiagnosisCostController.dispose();
    _pregnancyDiagnosisDateController.dispose();
    _pregnancyDiagnosisVetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editPregnancyDiagnosisId = widget.editPregnancyDiagnosisId;
    if (editPregnancyDiagnosisId != null) {
      final pregnancyDiagnosissList =
          context.read<PregnancyDiagnosisController>().pregnancyDiagnosissList;
      _pregnancyDiagnosisToEdit = pregnancyDiagnosissList.firstWhereOrNull(
        (pregnancyDiagnosis) =>
            pregnancyDiagnosis.getId == editPregnancyDiagnosisId,
      );
      _pregnancyDiagnosisDateController.value = TextEditingValue(
          text: _pregnancyDiagnosisToEdit?.getPregnancyDiagnosisDate ?? '');
      _pregnancyDiagnosisCostController.value = TextEditingValue(
          text: '${_pregnancyDiagnosisToEdit?.getPregnancyDiagnosisCost}');
      _pregnancyDiagnosisVetNameController.value =
          TextEditingValue(text: _pregnancyDiagnosisToEdit?.getVetName ?? '');
      setState(() {
        selectedCow = _pregnancyDiagnosisToEdit?.getCow;
        pregnancyResultPositive =
            _pregnancyDiagnosisToEdit?.getPregnancyDiagnosisResult ?? false;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editPregnancyDiagnosisId != null
                ? 'Edit ${DisplayTextUtil.pregnancyDiagnosisDetails}'
                : 'New ${DisplayTextUtil.pregnancyDiagnosisDetails}',
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
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          inputFieldLabel(
                            context,
                            "Diagnosis Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _pregnancyDiagnosisDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _pregnancyDiagnosisDateController.text)),
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
                            "Diagnosis",
                          ),
                          MyDefaultTextField(
                            controller: _pregnancyDiagnosisDiagnosisController,
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
                            "Pregnancy Diagnosis Result",
                          ),
                          Row(
                            children: <Widget>[
                              const Expanded(child: Text("Positive")),
                              Expanded(
                                child: Switch(
                                    // This bool value toggles the switch.
                                    value: pregnancyResultPositive,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        pregnancyResultPositive = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          inputFieldLabel(
                            context,
                            "Vet Name",
                          ),
                          MyDefaultTextField(
                            controller: _pregnancyDiagnosisVetNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
                            controller: _pregnancyDiagnosisCostController,
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
                          String pregnancyDiagnosisDate =
                              _pregnancyDiagnosisDateController.text.trim();
                          String vetName =
                              _pregnancyDiagnosisVetNameController.text.trim();
                          String pregnancyDiagnosisCost =
                              _pregnancyDiagnosisCostController.text.trim();
                          //edit the properties that require editing
                          final newPregnancyDiagnosis = PregnancyDiagnosis();
                          newPregnancyDiagnosis.setPregnancyDiagnosisDate =
                              pregnancyDiagnosisDate;
                          newPregnancyDiagnosis.setPregnancyDiagnosisResult =
                              pregnancyResultPositive;
                          newPregnancyDiagnosis.setPregnancyDiagnosisCost =
                              double.parse(pregnancyDiagnosisCost);
                          newPregnancyDiagnosis.setVetName = vetName;
                          newPregnancyDiagnosis.setCow = selectedCow!;

                          if (editPregnancyDiagnosisId != null) {
                            newPregnancyDiagnosis.setId =
                                editPregnancyDiagnosisId;
                            //update the pregnancyDiagnosis  in the db
                            await context
                                .read<PregnancyDiagnosisController>()
                                .editPregnancyDiagnosis(newPregnancyDiagnosis)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Pregnancy diagnosis edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the _pregnancyDiagnosisToEdit in the db
                            await context
                                .read<PregnancyDiagnosisController>()
                                .addPregnancyDiagnosis(newPregnancyDiagnosis)
                                .then((value) {
                              //reset the form
                              _pregnancyDiagnosisDiagnosisController.clear();
                              _pregnancyDiagnosisDateController.clear();
                              _pregnancyDiagnosisVetNameController.clear();
                              _pregnancyDiagnosisCostController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Pregnancy diagnosis added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save Diagnosis")
                ],
              )),
        )));
  }
}
