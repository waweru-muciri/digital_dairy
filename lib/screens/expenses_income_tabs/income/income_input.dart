import 'package:DigitalDairy/models/income.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/income_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class IncomeInputScreen extends StatefulWidget {
  const IncomeInputScreen({super.key, this.editIncomeId});
  final String? editIncomeId;

  @override
  IncomeFormState createState() {
    return IncomeFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class IncomeFormState extends State<IncomeInputScreen> {
  final TextEditingController _expenseDetailsController =
      TextEditingController();
  late TextEditingController _expenseDateController;
  final TextEditingController _expenseAmountController =
      TextEditingController(text: "0");
  late Income _expense;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<IncomeFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _expenseDateController = TextEditingController(
        text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  }

  @override
  void dispose() {
    _expenseDetailsController.dispose();
    _expenseDateController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editIncomeId = widget.editIncomeId;
    if (editIncomeId != null) {
      final clientsList = context.read<IncomeController>().incomesList;
      _expense = clientsList.firstWhere(
          (client) => client.getId == editIncomeId,
          orElse: () => Income());
      _expenseDetailsController.value =
          TextEditingValue(text: _expense.getDetails);
      _expenseDateController.value = TextEditingValue(
          text: DateFormat("dd/MM/yyyy").format(_expense.getIncomeDate));
      _expenseAmountController.value =
          TextEditingValue(text: _expense.getIncomeAmount.toString());
    } else {
      _expense = Income();
    } // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editIncomeId != null
                ? 'Edit ${DisplayTextUtil.incomeDetails}'
                : 'Add ${DisplayTextUtil.incomeDetails}',
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
                  child:
                          TextFormField(
                            controller: _expenseDateController,
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
                                            editIncomeId != null
                                                ? _expense.getIncomeDate
                                                : DateTime.now());
                                    _expenseDateController.text =
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
                            child: Text(DisplayTextUtil.incomeDetails,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _expenseDetailsController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Details cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Details',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Income Amount",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _expenseAmountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Income Amount cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Amount must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount (Ksh)',
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
                          String expenseDetails =
                              _expenseDetailsController.text.trim();
                          double expenseAmount = double.parse(
                              _expenseAmountController.text.trim());

                          _expense.setIncomeAmount = expenseAmount;
                          _expense.setIncomeDate = DateFormat("dd/MM/yyyy")
                              .parse(_expenseDateController.text);
                          _expense.setIncomeDetails = expenseDetails;

                          if (editIncomeId != null) {
                            //update the client in the db
                            await context
                                .read<IncomeController>()
                                .editIncome(_expense)
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
                                .addIncome(_expense)
                                .then((value) {
                              //reset the form
                              _expenseDetailsController.clear();
                              _expenseAmountController.clear();
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
                      child: const Text("Save Details"))
                ],
              )),
        )));
  }
}
