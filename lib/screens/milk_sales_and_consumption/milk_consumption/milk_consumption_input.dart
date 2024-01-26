import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkConsumptionInputScreen extends StatefulWidget {
  const MilkConsumptionInputScreen({super.key, this.editMilkConsumptionId});
  final String? editMilkConsumptionId;
  static const String addDetailsRoutePath = "/add_milk_consumption_details";
  static const String editDetailsRoutePath =
      "/edit_milk_consumption_details/:editMilkConsumptionId";

  @override
  MilkConsumptionFormState createState() {
    return MilkConsumptionFormState();
  }
}

class MilkConsumptionFormState extends State<MilkConsumptionInputScreen> {
  final TextEditingController _milkConsumptionDateController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _milkConsumptionAmountController =
      TextEditingController(text: "0");
  final TextEditingController _milkConsumerFilterController =
      TextEditingController();
  late List<MilkConsumer> _milkConsumersList;
  MilkConsumption? _milkConsumptionToEdit;
  MilkConsumer? selectedMilkConsumer;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of milk consumers
    Future.microtask(
        () => context.read<MilkConsumerController>().getMilkConsumers());
  }

  @override
  void dispose() {
    _milkConsumerFilterController.dispose();
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
      _milkConsumptionToEdit = milkConsumersList.firstWhereOrNull(
        (milkConsumer) => milkConsumer.getId == editMilkConsumptionId,
      );
      _milkConsumptionDateController.value = TextEditingValue(
          text: _milkConsumptionToEdit?.getMilkConsumptionDate ?? '');
      _milkConsumptionAmountController.value = TextEditingValue(
          text: _milkConsumptionToEdit?.getMilkConsumptionAmount.toString() ??
              '');
      setState(() {
        selectedMilkConsumer = _milkConsumptionToEdit?.getMilkConsumer;
      });
    }
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkConsumptionId != null
                ? 'Edit ${DisplayTextUtil.milkConsumptionDetails}'
                : 'New ${DisplayTextUtil.milkConsumptionDetails}',
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
                          inputFieldLabel(
                            context,
                            "Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _milkConsumptionDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _milkConsumptionDateController.text)),
                          inputFieldLabel(context, "Select Consumer"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<MilkConsumer>(
                              initialSelection: selectedMilkConsumer,
                              controller: _milkConsumerFilterController,
                              requestFocusOnTap: true,
                              label: const Text('Consumer'),
                              expandedInsets: EdgeInsets.zero,
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
                              inputDecorationTheme: const InputDecorationTheme(
                                  isDense: true, border: OutlineInputBorder()),
                              dropdownMenuEntries: _milkConsumersList
                                  .map<DropdownMenuEntry<MilkConsumer>>(
                                      (MilkConsumer milkConsumer) {
                                return DropdownMenuEntry<MilkConsumer>(
                                  value: milkConsumer,
                                  label: milkConsumer.getMilkConsumerName,
                                  enabled: true,
                                );
                              }).toList(),
                            ),
                          ),
                          inputFieldLabel(
                            context,
                            "Milk Sale Quantity",
                          ),
                          MyDefaultTextField(
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
                          )
                        ],
                      )),
                  SaveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          double milkConsumptionAmount = double.parse(
                              _milkConsumptionAmountController.text.trim());

                          final newMilkConsumption = MilkConsumption();
                          newMilkConsumption.setMilkConsumptionAmount =
                              milkConsumptionAmount;
                          newMilkConsumption.setMilkConsumptionDate =
                              _milkConsumptionDateController.text;
                          newMilkConsumption.setMilkConsumer =
                              selectedMilkConsumer!;

                          if (editMilkConsumptionId != null) {
                            newMilkConsumption.setId = editMilkConsumptionId;
                            //update the milk consumption details in the db
                            await context
                                .read<MilkConsumptionController>()
                                .editMilkConsumption(newMilkConsumption)
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
                                .addMilkConsumption(newMilkConsumption)
                                .then((value) {
                              //reset the form
                              _milkConsumerFilterController.clear();
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
                      text: "Save Details")
                ],
              )),
        )));
  }
}
