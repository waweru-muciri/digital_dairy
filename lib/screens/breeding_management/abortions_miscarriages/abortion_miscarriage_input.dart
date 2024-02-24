import 'package:DigitalDairy/controllers/cow_abortion_miscarriage_controller.dart';
import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/models/cow_abortion_miscarriage.dart';
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

class AbortionMiscarriageInputScreen extends StatefulWidget {
  const AbortionMiscarriageInputScreen(
      {super.key, this.editAbortionMiscarriageId});
  final String? editAbortionMiscarriageId;
  static const String addDetailsRoutePath = "/add_abortion_miscarriage_details";
  static const String editDetailsRoutePath =
      "/edit_abortion_miscarriage_details/:editAbortionMiscarriageId";

  @override
  AbortionMiscarriageFormState createState() {
    return AbortionMiscarriageFormState();
  }
}

class AbortionMiscarriageFormState
    extends State<AbortionMiscarriageInputScreen> {
  final TextEditingController _abortionMiscarriageCauseController =
      TextEditingController();
  final TextEditingController _abortionMiscarriageDateController =
      TextEditingController();
  final TextEditingController _abortionMiscarriageVetNameController =
      TextEditingController();
  final TextEditingController _abortionMiscarriageCostController =
      TextEditingController();
  final TextEditingController _cowController = TextEditingController();
  Cow? selectedCow;
  late List<Cow> _cowsList;
  String _abortionOrMiscarriage = 'Abortion';

  AbortionMiscarriage? _abortionMiscarriageToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _abortionMiscarriageCauseController.dispose();
    _abortionMiscarriageCostController.dispose();
    _abortionMiscarriageDateController.dispose();
    _abortionMiscarriageVetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editAbortionMiscarriageId = widget.editAbortionMiscarriageId;
    if (editAbortionMiscarriageId != null) {
      final abortionMiscarriagesList = context
          .read<AbortionMiscarriageController>()
          .abortionMiscarriagesList;
      _abortionMiscarriageToEdit = abortionMiscarriagesList.firstWhereOrNull(
        (abortionMiscarriage) =>
            abortionMiscarriage.getId == editAbortionMiscarriageId,
      );
      _abortionMiscarriageDateController.value = TextEditingValue(
          text: _abortionMiscarriageToEdit?.getAbortionMiscarriageDate ?? '');
      _abortionMiscarriageCostController.value = TextEditingValue(
          text: '${_abortionMiscarriageToEdit?.getAbortionMiscarriageCost}');
      _abortionMiscarriageVetNameController.value =
          TextEditingValue(text: _abortionMiscarriageToEdit?.getVetName ?? '');
      setState(() {
        selectedCow = _abortionMiscarriageToEdit?.getCow;
        _abortionOrMiscarriage =
            _abortionMiscarriageToEdit?.getAbortionOrMiscarriage ?? '';
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editAbortionMiscarriageId != null
                ? 'Edit ${DisplayTextUtil.abortionMiscarriageDetails}'
                : 'New ${DisplayTextUtil.abortionMiscarriageDetails}',
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
                            "Diagnosis Date",
                          ),
                          MyDefaultDateInputTextField(
                            controller: _abortionMiscarriageDateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date cannot be empty';
                              }
                              return null;
                            },
                          ),
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
                            "Abortion/Miscarriage",
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _abortionOrMiscarriage,
                                isDense: true,
                                iconEnabledColor: Colors.green,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                items: AbortionOrMiscarriage.values
                                    .map<DropdownMenuItem<String>>(
                                        (abortionOrMiscarriage) =>
                                            DropdownMenuItem<String>(
                                                value:
                                                    abortionOrMiscarriage.type,
                                                child: Text(
                                                    abortionOrMiscarriage
                                                        .type)))
                                    .toList(),
                                onChanged: (String? item) {
                                  setState(() {
                                    if (item != null) {
                                      _abortionOrMiscarriage = item;
                                    }
                                  });
                                },
                                validator: (String? abortionOrMiscarriage) {
                                  if (abortionOrMiscarriage == null) {
                                    return "Please select abortion/miscarriage.";
                                  }
                                  return null;
                                },
                              )),
                          inputFieldLabel(
                            context,
                            "Cause",
                          ),
                          MyDefaultTextField(
                              controller: _abortionMiscarriageCauseController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cause cannot be empty';
                                }
                                return null;
                              }),
                          inputFieldLabel(
                            context,
                            "Vet Name",
                          ),
                          MyDefaultTextField(
                            controller: _abortionMiscarriageVetNameController,
                          ),
                          inputFieldLabel(
                            context,
                            "Cost",
                          ),
                          MyDefaultTextField(
                            controller: _abortionMiscarriageCostController,
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
                          String cause =
                              _abortionMiscarriageCauseController.text;
                          String abortionMiscarriageDate =
                              _abortionMiscarriageDateController.text.trim();
                          String vetName =
                              _abortionMiscarriageVetNameController.text.trim();
                          String abortionMiscarriageCost =
                              _abortionMiscarriageCostController.text.trim();
                          //edit the properties that require editing
                          final newAbortionMiscarriage = AbortionMiscarriage();
                          newAbortionMiscarriage.setAbortionMiscarriageDate =
                              abortionMiscarriageDate;
                          newAbortionMiscarriage.setAbortionMiscarriageCause =
                              cause;
                          newAbortionMiscarriage.setAbortionMiscarriageCost =
                              double.parse(abortionMiscarriageCost);
                          newAbortionMiscarriage.setVetName = vetName;
                          newAbortionMiscarriage.setAbortionOrMiscarriage =
                              _abortionOrMiscarriage;
                          newAbortionMiscarriage.setCow = selectedCow!;

                          if (editAbortionMiscarriageId != null) {
                            newAbortionMiscarriage.setId =
                                editAbortionMiscarriageId;
                            //update the abortionMiscarriage  in the db
                            await context
                                .read<AbortionMiscarriageController>()
                                .editAbortionMiscarriage(newAbortionMiscarriage)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar("Item edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the _abortionMiscarriageToEdit in the db
                            await context
                                .read<AbortionMiscarriageController>()
                                .addAbortionMiscarriage(newAbortionMiscarriage)
                                .then((value) {
                              //reset the form
                              _abortionMiscarriageCauseController.clear();
                              _abortionMiscarriageDateController.clear();
                              _abortionMiscarriageVetNameController.clear();
                              _abortionMiscarriageCostController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar("Item added successfully."));
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
