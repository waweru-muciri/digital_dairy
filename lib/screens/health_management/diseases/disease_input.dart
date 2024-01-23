import 'package:DigitalDairy/models/disease.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
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
  late Disease disease;

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
      disease = diseasesList.firstWhere(
          (disease) => disease.getId == editDiseaseId,
          orElse: () => Disease());
      _diseaseNameController.value = TextEditingValue(text: disease.getName);
      _dateDiscoveredController.value =
          TextEditingValue(text: disease.getDateDiscovered);
      _diseaseDetailsController.value =
          TextEditingValue(text: disease.getDetails);
    } else {
      disease = Disease();
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
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _diseaseNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Disease name cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: textFormFieldDecoration,
                              )),
                          inputFieldLabel(
                            context,
                            "Date Discovered",
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _dateDiscoveredController,
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
                                                editDiseaseId != null
                                                    ? DateFormat("dd/MM/yyyy")
                                                        .parse(disease
                                                            .getDateDiscovered)
                                                    : DateTime.now());
                                        _dateDiscoveredController.text =
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
                          inputFieldLabel(
                            context,
                            "Disease Details",
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _diseaseDetailsController,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 3,
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
                          String diseaseName =
                              _diseaseNameController.text.trim();
                          String dateDiscovered =
                              _dateDiscoveredController.text.trim();
                          String details =
                              _diseaseDetailsController.text.trim();
                          //edit the properties that require editing
                          disease.setName = diseaseName;
                          disease.setDateDiscovered = dateDiscovered;
                          disease.setDetails = details;

                          if (editDiseaseId != null) {
                            //update the disease in the db
                            await context
                                .read<DiseaseController>()
                                .editDisease(disease)
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
                                .addDisease(disease)
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
