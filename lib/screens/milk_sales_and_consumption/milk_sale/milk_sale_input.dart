import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class MilkSaleInputScreen extends StatefulWidget {
  const MilkSaleInputScreen({super.key, this.editMilkSaleId});
  final String? editMilkSaleId;
  static const String addDetailsRouteName = "/add_milk_sale_details";
  static const String editDetailsRouteName = "edit_milk_sale_details";

  @override
  MilkSaleFormState createState() {
    return MilkSaleFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MilkSaleFormState extends State<MilkSaleInputScreen> {
  late TextEditingController _milkSaleDateController;
  final TextEditingController _milkSaleAmountController =
      TextEditingController(text: "0");
  final TextEditingController _clientController = TextEditingController();
  late List<Client> _clientsList;
  late MilkSale _milkSale;
  late Client? selectedClient;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MilkSaleFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _milkSaleDateController = TextEditingController(
        text: DateFormat("dd/MM/yyyy").format(DateTime.now()));
  }

  @override
  void dispose() {
    _clientController.dispose();
    _milkSaleDateController.dispose();
    _milkSaleAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clientsList = context.watch<ClientController>().clientsList;

    String? editMilkSaleId = widget.editMilkSaleId;
    if (editMilkSaleId != null) {
      final clientsList = context.read<MilkSaleController>().milkSalesList;
      _milkSale = clientsList.firstWhere(
          (client) => client.getId == editMilkSaleId,
          orElse: () => MilkSale());
      _milkSaleDateController.value = TextEditingValue(
          text: DateFormat("dd/MM/yyyy").format(_milkSale.getMilkSaleDate));
      _milkSaleAmountController.value =
          TextEditingValue(text: _milkSale.getMilkSaleAmount.toString());
    } else {
      _milkSale = MilkSale();
    } // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkSaleId != null
                ? 'Edit ${DisplayTextUtil.milkSaleDetails}'
                : 'Add ${DisplayTextUtil.milkSaleDetails}',
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
                                controller: _milkSaleDateController,
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
                                                editMilkSaleId != null
                                                    ? _milkSale.getMilkSaleDate
                                                    : DateTime.now());
                                        _milkSaleDateController.text =
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
                            child: Text("Client",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<Client>(
                              initialSelection: _clientsList.first,
                              controller: _clientController,
                              requestFocusOnTap: true,
                              label: const Text('Client'),
                              onSelected: (Client? client) {
                                setState(() {
                                  selectedClient = client;
                                });
                              },
                              errorText: selectedClient == null
                                  ? 'Client cannot be empty!'
                                  : null,
                              enableFilter: true,
                              enableSearch: true,
                              dropdownMenuEntries: _clientsList
                                  .map<DropdownMenuEntry<Client>>(
                                      (Client client) {
                                return DropdownMenuEntry<Client>(
                                  value: client,
                                  label: client.clientName,
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
                                controller: _milkSaleAmountController,
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
                          double milkSaleAmount = double.parse(
                              _milkSaleAmountController.text.trim());
                          _milkSale.setMilkSaleAmount = milkSaleAmount;
                          _milkSale.setMilkSaleDate = DateFormat("dd/MM/yyyy")
                              .parse(_milkSaleDateController.text);
                          _milkSale.setClient = selectedClient!;

                          if (editMilkSaleId != null) {
                            //update the milk sale details in the db
                            await context
                                .read<MilkSaleController>()
                                .editMilkSale(_milkSale)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "MilkSale edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<MilkSaleController>()
                                .addMilkSale(_milkSale)
                                .then((value) {
                              //reset the form
                              _clientController.clear();
                              setState(() {
                                selectedClient = null;
                              });
                              _milkSaleAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "MilkSale added successfully."));
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
