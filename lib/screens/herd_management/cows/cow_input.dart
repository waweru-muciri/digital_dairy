import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CowInputScreen extends StatefulWidget {
  const CowInputScreen({super.key, this.editCowId});
  final String? editCowId;
  static const String addDetailsRoutePath = "/add_cow_details";
  static const String editDetailsRoutePath = "/edit_cow_details/:editCowId";

  @override
  CowInputFormState createState() {
    return CowInputFormState();
  }
}

class CowInputFormState extends State<CowInputScreen> {
  final TextEditingController _cowCodeController = TextEditingController();
  final TextEditingController _cowNameController = TextEditingController();
  final TextEditingController _cowSourceController = TextEditingController();
  final TextEditingController _cowColorController = TextEditingController();
  final TextEditingController _cowDateofBirthController =
      TextEditingController();
  final TextEditingController _cowPurchaseDateController =
      TextEditingController();
  final TextEditingController _cowKSBNoController = TextEditingController();
  final TextEditingController _cowDamController = TextEditingController();
  final TextEditingController _cowBirthWeightController =
      TextEditingController();

  Cow? _cowDam;
  String? _selectedCowBreed;
  String? _selectedCowType;
  String? _selectedCowGrade;
  late List<Cow> _cowsList;

  Cow? cowToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of cows
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _cowCodeController.dispose();
    _cowColorController.dispose();
    _cowDamController.dispose();
    _cowDateofBirthController.dispose();
    _cowKSBNoController.dispose();
    _cowNameController.dispose();
    _cowPurchaseDateController.dispose();
    _cowSourceController.dispose();
    _cowBirthWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editCowId = widget.editCowId;
    if (editCowId != null) {
      final cowsList = context.read<CowController>().cowsList;
      cowToEdit = cowsList.firstWhereOrNull(
        (cow) => cow.getId == editCowId,
      );
      _cowCodeController.value =
          TextEditingValue(text: '${cowToEdit?.getCowCode}');
      _cowNameController.value =
          TextEditingValue(text: "${cowToEdit?.getName}");
      _cowColorController.value =
          TextEditingValue(text: '${cowToEdit?.getColor}');
      _cowDateofBirthController.value =
          TextEditingValue(text: '${cowToEdit?.getDateOfBirth}');
      _cowPurchaseDateController.value =
          TextEditingValue(text: '${cowToEdit?.getDatePurchased}');
      _cowKSBNoController.value =
          TextEditingValue(text: '${cowToEdit?.getKSBNumber}');
      _cowSourceController.value =
          TextEditingValue(text: '${cowToEdit?.getSource}');
      setState(() {
        _cowDam = cowToEdit?.getDam;
        _selectedCowGrade = cowToEdit?.getGrade;
        _selectedCowBreed = cowToEdit?.getBreed;
        _selectedCowType = cowToEdit?.getCowType;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editCowId != null
                ? 'Edit ${DisplayTextUtil.cowDetails}'
                : 'New ${DisplayTextUtil.cowDetails}',
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
                            "Cow Code",
                          ),
                          MyDefaultTextField(
                            controller: _cowCodeController,
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return "Cow code cannot be empty!";
                              }
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Cow Name",
                          ),
                          MyDefaultTextField(
                            controller: _cowNameController,
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return "Cow name cannot be empty!";
                              }
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "KSB Number",
                          ),
                          MyDefaultTextField(
                            controller: _cowKSBNoController,
                          ),
                          inputFieldLabel(
                            context,
                            "Breed",
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedCowBreed,
                                isDense: true,
                                iconEnabledColor: Colors.green,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: CowBreed.values
                                    .map<DropdownMenuItem<String>>((cowBreed) =>
                                        DropdownMenuItem<String>(
                                            value: cowBreed.breed,
                                            child: Text(cowBreed.breed)))
                                    .toList(),
                                onChanged: (String? item) {
                                  setState(() {
                                    _selectedCowBreed = item;
                                  });
                                },
                                validator: (String? cowBreed) {
                                  if (cowBreed == null) {
                                    return "Breed not selected!";
                                  }
                                  return null;
                                },
                              )),
                          inputFieldLabel(
                            context,
                            "Cow Type",
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedCowType,
                                isDense: true,
                                iconEnabledColor: Colors.green,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: CowType.values
                                    .map<DropdownMenuItem<String>>((cowType) =>
                                        DropdownMenuItem<String>(
                                            value: cowType.type,
                                            child: Text(cowType.type)))
                                    .toList(),
                                onChanged: (String? cowType) {
                                  setState(() {
                                    _selectedCowType = cowType;
                                  });
                                },
                                validator: (String? cowType) {
                                  if (cowType == null) {
                                    return "Type not selected!";
                                  }
                                  return null;
                                },
                              )),
                          inputFieldLabel(
                            context,
                            "Cow Grade",
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedCowGrade,
                                isDense: true,
                                iconEnabledColor: Colors.green,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: CowGrade.values
                                    .map<DropdownMenuItem<String>>((cowGrade) =>
                                        DropdownMenuItem<String>(
                                            value: cowGrade.grade,
                                            child: Text(cowGrade.grade)))
                                    .toList(),
                                onChanged: (String? cowGrade) {
                                  setState(() {
                                    _selectedCowGrade = cowGrade;
                                  });
                                },
                                validator: (String? cowGrade) {
                                  if (cowGrade == null) {
                                    return "Grade is not selected!";
                                  }
                                  return null;
                                },
                              )),
                          inputFieldLabel(
                            context,
                            "Color",
                          ),
                          MyDefaultTextField(
                            controller: _cowColorController,
                          ),
                          inputFieldLabel(
                            context,
                            "Date of Birth",
                          ),
                          DefaultDateTextField(
                              controller: _cowDateofBirthController,
                              initialDate: getDateFromString(
                                  _cowDateofBirthController.text)),
                          inputFieldLabel(
                            context,
                            "Purchase Date",
                          ),
                          DefaultDateTextField(
                              controller: _cowPurchaseDateController,
                              initialDate: getDateFromString(
                                  _cowPurchaseDateController.text)),
                          inputFieldLabel(
                            context,
                            "Select Dam",
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<Cow>(
                              initialSelection: _cowDam,
                              controller: _cowDamController,
                              requestFocusOnTap: true,
                              expandedInsets: EdgeInsets.zero,
                              onSelected: (Cow? cow) {
                                setState(() {
                                  _cowDam = cow;
                                });
                              },
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
                            "Birth Weight",
                          ),
                          MyDefaultTextField(
                            controller: _cowBirthWeightController,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final inputValue = double.tryParse(value);
                                if (inputValue == null) {
                                  return "Cost must be a number";
                                } else if (inputValue <= 0) {
                                  return "Birth weight must be greater than 0";
                                }
                                return null;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          inputFieldLabel(
                            context,
                            "Source",
                          ),
                          MyDefaultTextField(
                            controller: _cowSourceController,
                          ),
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String cowCode = _cowCodeController.text.trim();
                          String cowName = _cowNameController.text.trim();
                          String color = _cowColorController.text.trim();
                          String dateOfPurchase =
                              _cowPurchaseDateController.text.trim();
                          String dateOfBirth =
                              _cowDateofBirthController.text.trim();
                          String ksbNumber = _cowKSBNoController.text.trim();
                          String source = _cowSourceController.text.trim();
                          double? birthWeight = double.tryParse(
                              _cowBirthWeightController.text.trim());
                          //edit the properties that require editing
                          final newCow = Cow();
                          newCow.setCowCode = cowCode;
                          newCow.setName = cowName;
                          newCow.setColor = color;
                          newCow.setKSBNumber = ksbNumber;
                          newCow.setDatePurchased = dateOfPurchase;
                          newCow.setDateOfBirth = dateOfBirth;
                          newCow.setBirthWeight = birthWeight;
                          newCow.setSource = source;
                          newCow.setDam = _cowDam;
                          newCow.setBreed = _selectedCowBreed;
                          newCow.setCowType = _selectedCowType;
                          newCow.setGrade = _selectedCowGrade;

                          if (editCowId != null) {
                            //set the cow id
                            newCow.setId = editCowId;
                            //update the cow  in the db
                            await context
                                .read<CowController>()
                                .editCow(newCow)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar("Cow edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the newCow in the db
                            await context
                                .read<CowController>()
                                .addCow(newCow)
                                .then((value) {
                              //reset the form
                              _cowCodeController.clear();
                              _cowNameController.clear();
                              _cowDamController.clear();
                              _cowDateofBirthController.clear();
                              _cowPurchaseDateController.clear();
                              _cowKSBNoController.clear();
                              _cowColorController.clear();
                              _cowSourceController.clear();
                              _cowBirthWeightController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar("Cow added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              debugPrint(error);
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
