import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class MilkConsumptionInputScreen extends StatefulWidget {
  const MilkConsumptionInputScreen({super.key, this.editMilkConsumptionId});
  final String? editMilkConsumptionId;
  static const String addDetailsRouteName = "/add_milk_consumption_details";
  static const String editDetailsRouteName = "edit_milk_consumption_details";

  @override
  MilkConsumptionFormState createState() {
    return MilkConsumptionFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MilkConsumptionFormState extends State<MilkConsumptionInputScreen> {
  late TextEditingController _milkConsumptionDateController;
  final TextEditingController _milkConsumptionAmountController =
      TextEditingController(text: "0");
  final TextEditingController _milkConsumerController = TextEditingController();
  late List<MilkConsumer> _milkConsumersList;
  late MilkConsumption _milkConsumption;
  late MilkConsumer? selectedMilkConsumer;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MilkConsumptionFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _milkConsumptionDateController = TextEditingController(
        text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  }

  @override
  void dispose() {
    _milkConsumerController.dispose();
    _milkConsumptionDateController.dispose();
    _milkConsumptionAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _milkConsumersList =
        context.watch<MilkConsumerController>().milkConsumersList;

    String? editMilkConsumptionId = widget.editMilkConsumptionId;
    if (editMilkConsumptionId != null) {
      final milkConsumersList =
          context.read<MilkConsumptionController>().milkConsumptionsList;
      _milkConsumption = milkConsumersList.firstWhere(
          (milkConsumer) => milkConsumer.getId == editMilkConsumptionId,
          orElse: () => MilkConsumption());
      _milkConsumptionDateController.value = TextEditingValue(
          text: DateFormat("dd/MM/yyyy")
              .format(_milkConsumption.getMilkConsumptionDate));
      _milkConsumptionAmountController.value = TextEditingValue(
          text: _milkConsumption.getMilkConsumptionAmount.toString());
    } else {
      _milkConsumption = MilkConsumption();
    } // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkConsumptionId != null
                ? 'Edit ${DisplayTextUtil.milkConsumptionDetails}'
                : 'Add ${DisplayTextUtil.milkConsumptionDetails}',
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
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Date",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _milkConsumptionDateController,
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
                                                editMilkConsumptionId != null
                                                    ? _milkConsumption
                                                        .getMilkConsumptionDate
                                                    : DateTime.now());
                                        _milkConsumptionDateController.text =
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
                            child: Text("Consumer",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<MilkConsumer>(
                              initialSelection: _milkConsumersList.first,
                              controller: _milkConsumerController,
                              requestFocusOnTap: true,
                              label: const Text('Consumer'),
                              onSelected: (MilkConsumer? milkConsumer) {
                                setState(() {
                                  selectedMilkConsumer = milkConsumer;
                                });
                              },
                              errorText: selectedMilkConsumer == null
                                  ? 'Consumer cannot be empty!'
                                  : null,
                              enableFilter: true,
                              enableSearch: true,
                              dropdownMenuEntries: _milkConsumersList
                                  .map<DropdownMenuEntry<MilkConsumer>>(
                                      (MilkConsumer milkConsumer) {
                                return DropdownMenuEntry<MilkConsumer>(
                                  value: milkConsumer,
                                  label: milkConsumer.milkConsumerName,
                                  enabled: true,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Colors.amber,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Milk Sale Quantity",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _milkConsumptionAmountController,
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
                          double milkConsumptionAmount = double.parse(
                              _milkConsumptionAmountController.text.trim());
                          _milkConsumption.setMilkConsumptionAmount =
                              milkConsumptionAmount;
                          _milkConsumption.setMilkConsumptionDate =
                              DateFormat("dd/MM/yyyy")
                                  .parse(_milkConsumptionDateController.text);
                          _milkConsumption.setMilkConsumer =
                              selectedMilkConsumer!;

                          if (editMilkConsumptionId != null) {
                            //update the milk consumption details in the db
                            await context
                                .read<MilkConsumptionController>()
                                .editMilkConsumption(_milkConsumption)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk Consumption edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the milkConsumer in the db
                            await context
                                .read<MilkConsumptionController>()
                                .addMilkConsumption(_milkConsumption)
                                .then((value) {
                              //reset the form
                              _milkConsumerController.clear();
                              setState(() {
                                selectedMilkConsumer = null;
                              });
                              _milkConsumptionAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk Consumption added successfully."));
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
