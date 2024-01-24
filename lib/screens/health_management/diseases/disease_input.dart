import 'package:DigitalDairy/models/disease.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/disease_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiseaseInputScreen extends StatefulWidget {
  const DiseaseInputScreen({super.key, this.editDiseaseId});
  final String? editDiseaseId;
  static const String addDetailsRoutePath = "/add_disease_details";
  static const String editDetailsRoutePath =
      "/edit_disease_details/:editDiseaseId";

  @override
  DiseaseFormState createState() {
    return DiseaseFormState();
  }
}

class DiseaseFormState extends State<DiseaseInputScreen> {
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _dateDiscoveredController =
      TextEditingController();
  final TextEditingController _diseaseDetailsController =
      TextEditingController();
  Disease? _diseaseToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _diseaseNameController.dispose();
    _dateDiscoveredController.dispose();
    _diseaseDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editDiseaseId = widget.editDiseaseId;
    if (editDiseaseId != null) {
      final diseasesList = context.read<DiseaseController>().diseasesList;
      _diseaseToEdit = diseasesList.firstWhereOrNull(
        (disease) => disease.getId == editDiseaseId,
      );
      _diseaseNameController.value =
          TextEditingValue(text: _diseaseToEdit?.getName);
      _dateDiscoveredController.value =
          TextEditingValue(text: _diseaseToEdit?.getDateDiscovered);
      _diseaseDetailsController.value =
          TextEditingValue(text: _diseaseToEdit?.getDetails);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editDiseaseId != null
                ? 'Edit ${DisplayTextUtil.diseaseDetails}'
                : 'New ${DisplayTextUtil.diseaseDetails}',
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
                            "Disease Name",
                          ),
                          MyDefaultTextField(
                            controller: _diseaseNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Disease name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Date Discovered",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _dateDiscoveredController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _dateDiscoveredController.text)),
                          inputFieldLabel(
                            context,
                            "Disease Details",
                          ),
                          MyDefaultTextField(
                            controller: _diseaseDetailsController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String diseaseName =
                              _diseaseNameController.text.trim();
                          String dateDiscovered =
                              _dateDiscoveredController.text.trim();
                          String details =
                              _diseaseDetailsController.text.trim();
                          //edit the properties that require editing
                          final newDisease = Disease();
                          newDisease.setName = diseaseName;
                          newDisease.setDateDiscovered = dateDiscovered;
                          newDisease.setDetails = details;

                          if (editDiseaseId != null) {
                            newDisease.setId = editDiseaseId;
                            //update the disease in the db
                            await context
                                .read<DiseaseController>()
                                .editDisease(newDisease)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Disease edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the disease in the db
                            await context
                                .read<DiseaseController>()
                                .addDisease(newDisease)
                                .then((value) {
                              //reset the form
                              _diseaseNameController.clear();
                              _dateDiscoveredController.clear();
                              _diseaseDetailsController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Disease added successfully."));
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
