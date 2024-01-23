import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
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
  final TextEditingController __cowBirthWeightController =
      TextEditingController();

  Cow? _cowDam;
  CowBreed? _selectedCowBreed;
  CowType? _selectedCowType;
  CowGrade? _selectedCowGrade;
  late List<Cow> _cowsList;

  late Cow cowToSave;

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
    __cowBirthWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowsList = context.watch<CowController>().cowsList;

    String? editCowId = widget.editCowId;
    if (editCowId != null) {
      final cowsList = context.read<CowController>().cowsList;
      cowToSave = cowsList.firstWhere(
          (cowToSave) => cowToSave.getId == editCowId,
          orElse: () => Cow());
      _cowCodeController.value = TextEditingValue(text: cowToSave.getCowCode);
      _cowNameController.value = TextEditingValue(text: cowToSave.getName);
      _cowColorController.value =
          TextEditingValue(text: '${cowToSave.getColor}');
      _cowDateofBirthController.value =
          TextEditingValue(text: '${cowToSave.getDateOfBirth}');
      _cowPurchaseDateController.value =
          TextEditingValue(text: '${cowToSave.getDatePurchased}');
      _cowKSBNoController.value =
          TextEditingValue(text: '${cowToSave.getKSBNumber}');
      _cowSourceController.value =
          TextEditingValue(text: '${cowToSave.getSource}');
      setState(() {
        _cowDam = cowToSave.getDam;
      });
    } else {
      cowToSave = Cow();
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Cow Code",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowCodeController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value != null && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Cow code cannot be empty!";
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Cow Name",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowNameController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value != null && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Cow name cannot be empty!";
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "KSB Number",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowKSBNoController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Breed",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButton<CowBreed>(
                                isExpanded: true,
                                value: _selectedCowBreed,
                                isDense: true,
                                items: CowBreed.values
                                    .map((cowBreed) =>
                                        DropdownMenuItem<CowBreed>(
                                            child: Text(cowBreed.breed)))
                                    .toList(),
                                onChanged: (CowBreed? item) {
                                  setState(() {
                                    _selectedCowBreed = item;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Cow Type",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButton<CowType>(
                                isExpanded: true,
                                value: _selectedCowType,
                                isDense: true,
                                items: CowType.values
                                    .map((cowType) => DropdownMenuItem<CowType>(
                                        child: Text(cowType.type)))
                                    .toList(),
                                onChanged: (CowType? cowType) {
                                  setState(() {
                                    _selectedCowType = cowType;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Cow Grade",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: DropdownButton<CowGrade>(
                                isExpanded: true,
                                value: _selectedCowGrade,
                                isDense: true,
                                items: CowGrade.values
                                    .map((cowType) =>
                                        DropdownMenuItem<CowGrade>(
                                            child: Text(cowType.grade)))
                                    .toList(),
                                onChanged: (CowGrade? cowGrade) {
                                  setState(() {
                                    _selectedCowGrade = cowGrade;
                                  });
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Color",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowColorController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Date of Birth",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowDateofBirthController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime? pickedDateTime =
                                            await showCustomDatePicker(
                                                context,
                                                editCowId != null
                                                    ? getDateFromString(
                                                        '${cowToSave.getDateOfBirth}')
                                                    : DateTime.now());
                                        _cowDateofBirthController.text =
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Purchase Date",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowPurchaseDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime? pickedDateTime =
                                            await showCustomDatePicker(
                                                context,
                                                editCowId != null
                                                    ? getDateFromString(
                                                        '${cowToSave.getDatePurchased}')
                                                    : DateTime.now());
                                        _cowPurchaseDateController.text =
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Select Dam",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Birth Weight",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: __cowBirthWeightController,
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
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "Source",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _cowSourceController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              )),
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
                          double? birthWeight =
                              double.tryParse(_cowSourceController.text.trim());
                          //edit the properties that require editing
                          cowToSave.setCowCode = cowCode;
                          cowToSave.setName = cowName;
                          cowToSave.setColor = color;
                          cowToSave.setKSBNumber = ksbNumber;
                          cowToSave.setDatePurchased = dateOfPurchase;
                          cowToSave.setDateOfBirth = dateOfBirth;
                          cowToSave.setDam = _cowDam;
                          cowToSave.setBirthWeight = birthWeight;
                          cowToSave.setSource = source;
                          cowToSave.setBreed = _selectedCowBreed;
                          cowToSave.setCowType = _selectedCowType;
                          cowToSave.setGrade = _selectedCowGrade;

                          if (editCowId != null) {
                            //update the cow  in the db
                            await context
                                .read<CowController>()
                                .editCow(cowToSave)
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
                            //add the cowToSave in the db
                            await context
                                .read<CowController>()
                                .addCow(cowToSave)
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
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar("Cow added successfully."));
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
