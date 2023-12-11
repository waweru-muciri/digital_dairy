import 'package:DigitalDairy/models/expense.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class ExpenseInputScreen extends StatefulWidget {
  const ExpenseInputScreen({super.key, this.editExpenseId});
  final String? editExpenseId;

  @override
  ExpenseFormState createState() {
    return ExpenseFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ExpenseFormState extends State<ExpenseInputScreen> {
  final TextEditingController _expenseDetailsController =
      TextEditingController();
  final TextEditingController _expenseDateController = TextEditingController(
      text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  final TextEditingController _expenseAmountController =
      TextEditingController(text: "0");
  late Expense? expenseDetails;
  DateTime selectedDate = DateTime.now();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<ExpenseFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
      final matchingExpensesList =
          clientsList.where((client) => client.getId == editExpenseId);
      if (matchingExpensesList.isNotEmpty) {
        expenseDetails = matchingExpensesList.first;
        if (expenseDetails != null) {
          _expenseDetailsController.value =
              TextEditingValue(text: expenseDetails!.getDetails);
          _expenseDateController.value = TextEditingValue(
              text: DateFormat("dd/MM/yyyy")
                  .format(expenseDetails!.getExpenseDate));
          _expenseAmountController.value = TextEditingValue(
              text: expenseDetails!.getExpenseAmount.toString());
        }
      }
    }
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editExpenseId != null
                ? 'Edit Expense Details'
                : 'Add Expense Details',
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _expenseDetailsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date cannot be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Date',
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    final DateTime pickedDateTime =
                                        await selectDate(context, selectedDate);
                                    setState(() {
                                      selectedDate = pickedDateTime;
                                    });
                                  },
                                  icon: const Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        Icons.calendar_view_day,
                                      ))),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: TextFormField(
                                controller: _expenseDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Details cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Details',
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
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
                                  labelText: 'Amount (Ksh)',
                                ),
                              ))
                        ],
                      )),
                  FilledButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String expenseDetails =
                              _expenseDetailsController.text.trim();
                          String expenseDate =
                              _expenseDateController.text.trim();
                          double expenseAmount = double.parse(
                              _expenseAmountController.text.trim());

                          Expense newExpense = Expense();
                          newExpense.setExpenseAmount = expenseAmount;
                          newExpense.setExpenseDate = selectedDate;
                          newExpense.seExpenseDetails = expenseDetails;

                          if (editExpenseId != null) {
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
                              _expenseDateController.clear();
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
