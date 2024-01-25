import 'package:DigitalDairy/models/income.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/income_controller.dart';
import 'package:provider/provider.dart';

class IncomeInputScreen extends StatefulWidget {
  const IncomeInputScreen({super.key, this.editIncomeId});
  final String? editIncomeId;

  @override
  IncomeFormState createState() {
    return IncomeFormState();
  }
}

class IncomeFormState extends State<IncomeInputScreen> {
  final TextEditingController _incomeDetailsController =
      TextEditingController();
  late TextEditingController _incomeDateController;
  final TextEditingController _incomeAmountController =
      TextEditingController(text: "0");
  Income? _incomeToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _incomeDateController =
        TextEditingController(text: getTodaysDateAsString());
  }

  @override
  void dispose() {
    _incomeDetailsController.dispose();
    _incomeDateController.dispose();
    _incomeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editIncomeId = widget.editIncomeId;
    if (editIncomeId != null) {
      final clientsList = context.read<IncomeController>().incomesList;
      _incomeToEdit = clientsList
          .firstWhereOrNull((income) => income.getId == editIncomeId);
      _incomeDetailsController.value =
          TextEditingValue(text: _incomeToEdit?.getDetails ?? '');
      _incomeDateController.value =
          TextEditingValue(text: _incomeToEdit?.getIncomeDate ?? '');
      _incomeAmountController.value = TextEditingValue(
          text: _incomeToEdit?.getIncomeAmount.toString() ?? '');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            editIncomeId != null
                ? 'Edit ${DisplayTextUtil.incomeDetails}'
                : 'New ${DisplayTextUtil.incomeDetails}',
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
                              controller: _incomeDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _incomeDateController.text)),
                          inputFieldLabel(
                              context, DisplayTextUtil.incomeDetails),
                          MyDefaultTextField(
                            controller: _incomeDetailsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Details cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Income Amount",
                          ),
                          MyDefaultTextField(
                            controller: _incomeAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Income Amount cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Amount must be a number";
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
                          String incomeDetails =
                              _incomeDetailsController.text.trim();
                          double incomeAmount =
                              double.parse(_incomeAmountController.text.trim());
                          final newIncome = Income();
                          newIncome.setIncomeAmount = incomeAmount;
                          newIncome.setIncomeDate = _incomeDateController.text;
                          newIncome.setIncomeDetails = incomeDetails;

                          if (editIncomeId != null) {
                            newIncome.setId = editIncomeId;
                            //update the client in the db
                            await context
                                .read<IncomeController>()
                                .editIncome(newIncome)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Income edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<IncomeController>()
                                .addIncome(newIncome)
                                .then((value) {
                              //reset the form
                              _incomeDetailsController.clear();
                              _incomeAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Income added successfully."));
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
