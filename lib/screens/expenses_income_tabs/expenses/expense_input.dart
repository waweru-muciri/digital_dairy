import 'package:DigitalDairy/models/expense.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseInputScreen extends StatefulWidget {
  const ExpenseInputScreen({super.key, this.editExpenseId});
  final String? editExpenseId;

  @override
  ExpenseFormState createState() {
    return ExpenseFormState();
  }
}

class ExpenseFormState extends State<ExpenseInputScreen> {
  final TextEditingController _expenseDetailsController =
      TextEditingController();
  late TextEditingController _expenseDateController;
  final TextEditingController _expenseAmountController =
      TextEditingController(text: "0");
  late Expense _expense;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _expenseDateController =
        TextEditingController(text: getStringFromDate(DateTime.now()));
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
    String? editExpenseId = widget.editExpenseId;
    if (editExpenseId != null) {
      final clientsList = context.read<ExpenseController>().expensesList;
      _expense = clientsList.firstWhere(
          (client) => client.getId == editExpenseId,
          orElse: () => Expense());
      _expenseDetailsController.value =
          TextEditingValue(text: _expense.getDetails);
      _expenseDateController.value =
          TextEditingValue(text: _expense.getExpenseDate);
      _expenseAmountController.value =
          TextEditingValue(text: _expense.getExpenseAmount.toString());
    } else {
      _expense = Expense();
    } // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editExpenseId != null
                ? 'Edit ${DisplayTextUtil.expenseDetails}'
                : 'New ${DisplayTextUtil.expenseDetails}',
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
                                  isDense: true,
                                  hintText: 'Date',
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        final DateTime? pickedDateTime =
                                            await showCustomDatePicker(
                                                context,
                                                editExpenseId != null
                                                    ? getDateFromString(
                                                        _expense.getExpenseDate)
                                                    : DateTime.now());
                                        _expenseDateController.text =
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
                            child: Text(DisplayTextUtil.expenseDetails,
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
                                  isDense: true,
                                  hintText: 'Details',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("Expense Amount",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextFormField(
                                controller: _expenseAmountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Expense Amount cannot be empty';
                                  } else if (double.tryParse(value) == null) {
                                    return "Amount must be a number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  hintText: 'Amount (Ksh)',
                                ),
                              ))
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String expenseDetails =
                              _expenseDetailsController.text.trim();
                          double expenseAmount = double.parse(
                              _expenseAmountController.text.trim());

                          _expense.setExpenseAmount = expenseAmount;
                          _expense.setExpenseDate = _expenseDateController.text;
                          _expense.setExpenseDetails = expenseDetails;

                          if (editExpenseId != null) {
                            //update the client in the db
                            await context
                                .read<ExpenseController>()
                                .editExpense(_expense)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Expense edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<ExpenseController>()
                                .addExpense(_expense)
                                .then((value) {
                              //reset the form
                              _expenseDetailsController.clear();
                              _expenseAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Expense added successfully."));
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
