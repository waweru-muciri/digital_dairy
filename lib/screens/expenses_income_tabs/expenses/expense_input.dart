import 'package:DigitalDairy/models/expense.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:provider/provider.dart';

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
  Expense? _expense;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _expenseDateController =
        TextEditingController(text: getTodaysDateAsString());
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
      final expensesList = context.read<ExpenseController>().expensesList;
      _expense = expensesList
          .firstWhereOrNull((expense) => expense.getId == editExpenseId);
      _expenseDetailsController.value =
          TextEditingValue(text: _expense?.getDetails ?? '');
      _expenseDateController.value =
          TextEditingValue(text: _expense?.getExpenseDate ?? '');
      _expenseAmountController.value =
          TextEditingValue(text: _expense?.getExpenseAmount.toString() ?? '');
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
                          inputFieldLabel(
                            context,
                            "Date",
                          ),
                          MyDefaultDateInputTextField(
                              controller: _expenseDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _expenseDateController.text)),
                          inputFieldLabel(
                              context, DisplayTextUtil.expenseDetails),
                          MyDefaultTextField(
                            controller: _expenseDetailsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Details cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Expense Amount",
                          ),
                          MyDefaultTextField(
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
                          )
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
                          final newExpense = Expense();
                          newExpense.setExpenseAmount = expenseAmount;
                          newExpense.setExpenseDate =
                              _expenseDateController.text;
                          newExpense.setExpenseDetails = expenseDetails;

                          if (editExpenseId != null) {
                            newExpense.setId = editExpenseId;
                            //update the client in the db
                            await context
                                .read<ExpenseController>()
                                .editExpense(newExpense)
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
                                .addExpense(newExpense)
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
