import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_payment_controller.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/models/milk_sale_payment.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/src/iterable_extensions.dart';

class MilkSalePaymentInputScreen extends StatefulWidget {
  const MilkSalePaymentInputScreen({super.key, this.milkSaleId});
  final String? milkSaleId;
  final String? editMilkSalePaymentId = null;
  static const String addDetailsRoutePath =
      "/add_milk_sale_payment_details/:milkSaleId";
  static const String editDetailsRoutePath =
      "/edit_milk_sale_payment_details/:editMilkSalePaymentId";

  @override
  MilkSalePaymentFormState createState() {
    return MilkSalePaymentFormState();
  }
}

class MilkSalePaymentFormState extends State<MilkSalePaymentInputScreen> {
  final TextEditingController _dateController =
      TextEditingController(text: getStringFromDate(DateTime.now()));
  final TextEditingController _amountController =
      TextEditingController(text: "0");
  final TextEditingController _detailsController =
      TextEditingController(text: "");
  late MilkSalePayment _milkSalePayment;
  late MilkSale? _selectedMilkSale;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if the editMilkSalePaymentId is not null then it means the payments list is already loaded
    String? editMilkSalePaymentId = widget.editMilkSalePaymentId;
    if (editMilkSalePaymentId != null) {
      _milkSalePayment = context
          .read<MilkSalePaymentController>()
          .milkSalePaymentsList
          .firstWhere(
              (milkSalePayment) =>
                  milkSalePayment.getId == editMilkSalePaymentId,
              orElse: () => MilkSalePayment());
      _dateController.value =
          TextEditingValue(text: _milkSalePayment.getMilkSalePaymentDate);
      _amountController.value = TextEditingValue(
          text: _milkSalePayment.getMilkSalePaymentAmount.toString());
      _detailsController.value =
          TextEditingValue(text: '${_milkSalePayment.getDetails}');
      _selectedMilkSale = _milkSalePayment.getMilkSale;
    }

    String? milkSaleId = widget.milkSaleId;
    final milkSalesList = context.read<MilkSaleController>().milkSalesList;
    _selectedMilkSale = milkSalesList.firstWhereOrNull(
      (milkSale) => milkSale.getId == milkSaleId,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkSalePaymentId != null
                ? 'Edit ${DisplayTextUtil.milkSalePaymentDetails}'
                : 'New ${DisplayTextUtil.milkSalePaymentDetails}',
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_selectedMilkSale != null)
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              summaryTextDisplayRow("Milk Sales Date:",
                                  "${_selectedMilkSale?.getMilkSaleDate}"),
                              summaryTextDisplayRow("Client:",
                                  '${_selectedMilkSale?.getClient.clientName}'),
                              summaryTextDisplayRow("Milk Sales Amount:",
                                  "${_selectedMilkSale?.getMilkSaleMoneyAmount} Ksh"),
                              summaryTextDisplayRow("Outstanding Balances:",
                                  "${_milkSalePayment.getMilkSaleOutstandingPayment()} Kgs"),
                            ],
                          )),
                    ))
              else
                const Text('Milk sale not selected!'),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Previous Payments",
                              style:
                                  Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                          ],
                        )),
                  )),
              Form(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text("Payment Date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: TextFormField(
                                      controller: _dateController,
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
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              final DateTime? pickedDateTime =
                                                  await showCustomDatePicker(
                                                      context,
                                                      getDateFromString(
                                                          _dateController
                                                              .text));
                                              _dateController.text =
                                                  getStringFromDate(
                                                      pickedDateTime);
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text("Payment Amount",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: TextFormField(
                                      controller: _amountController,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          var inputNumber =
                                              double.tryParse(value);
                                          if (inputNumber == null) {
                                            return "Amount must be a number";
                                          }
                                          if (inputNumber <= 0) {
                                            return "Amount must be greater than 0";
                                          }
                                          return null;
                                        }
                                        return 'Amount cannot be empty';
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text("Payment Details",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: TextFormField(
                                      controller: _detailsController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
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
                                double milkSalePaymentAmount =
                                    double.parse(_amountController.text.trim());
                                _milkSalePayment.setMilkSalePaymentAmount =
                                    milkSalePaymentAmount;
                                _milkSalePayment.setMilkSalePaymentDate =
                                    _dateController.text.trim();
                                _milkSalePayment.setDetails =
                                    _detailsController.text.trim();

                                if (editMilkSalePaymentId != null) {
                                  //update the milk sale details in the db
                                  await context
                                      .read<MilkSalePaymentController>()
                                      .editMilkSalePayment(_milkSalePayment)
                                      .then((_) {
                                    //remove the loading dialog
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        successSnackBar(
                                            "Payment edited successfully!"));
                                  }).catchError((error) {
                                    //remove the loading dialog
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        errorSnackBar("Saving failed!"));
                                  });
                                } else {
                                  //this is a new milk sale payment so add the milk sale to it
                                  if (_selectedMilkSale != null) {
                                    _milkSalePayment.setMilkSale =
                                        _selectedMilkSale!;
                                  }
                                  //add the payment to the db
                                  await context
                                      .read<MilkSalePaymentController>()
                                      .addMilkSalePayment(_milkSalePayment)
                                      .then((value) {
                                    //reset the form
                                    _amountController.clear();
                                    _detailsController.clear();
                                    //remove the loading dialog
                                    Navigator.of(context).pop();
                                    //show a snackbar showing the user that saving has been successful
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        successSnackBar(
                                            "Payment added successfully."));
                                  }).catchError((error) {
                                    debugPrint("Error saving payment!");
                                    debugPrint(error);
                                    //remove the loading dialog
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        errorSnackBar("Saving failed!"));
                                  });
                                }
                              }
                            },
                            child: const Text("Save"))
                      ],
                    )),
              )
            ],
          ),
        )));
  }
}
