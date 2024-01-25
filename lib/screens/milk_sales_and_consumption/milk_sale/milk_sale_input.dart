import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/util/display_text_util.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_date_input_field.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:provider/provider.dart';
import 'package:DigitalDairy/util/utils.dart';

class MilkSaleInputScreen extends StatefulWidget {
  const MilkSaleInputScreen({super.key, this.editMilkSaleId});
  final String? editMilkSaleId;
  static const String addDetailsRoutePath = "/add_milk_sale_details";
  static const String editDetailsRoutePath =
      "/edit_milk_sale_details/:editMilkSaleId";

  @override
  MilkSaleFormState createState() {
    return MilkSaleFormState();
  }
}

class MilkSaleFormState extends State<MilkSaleInputScreen> {
  final TextEditingController _milkSaleDateController =
      TextEditingController(text: getTodaysDateAsString());
  final TextEditingController _milkSaleAmountController =
      TextEditingController(text: "");
  final TextEditingController _clientFilterController = TextEditingController();
  late List<Client> _clientsList;
  MilkSale? _milkSaleToEdit;
  Client? selectedClient;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //get the list of clients
    Future.microtask(() => context.read<ClientController>().getClients());
  }

  @override
  void dispose() {
    _clientFilterController.dispose();
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
      _milkSaleToEdit = clientsList
          .firstWhereOrNull((client) => client.getId == editMilkSaleId);
      _milkSaleDateController.value =
          TextEditingValue(text: _milkSaleToEdit?.getMilkSaleDate ?? '');
      _milkSaleAmountController.value = TextEditingValue(
          text: _milkSaleToEdit?.getMilkSaleQuantity.toString() ?? '');
      setState(() {
        selectedClient = _milkSaleToEdit?.getClient;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkSaleId != null
                ? 'Edit ${DisplayTextUtil.milkSaleDetails}'
                : 'New ${DisplayTextUtil.milkSaleDetails}',
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
                              controller: _milkSaleDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              initialDate: getDateFromString(
                                  _milkSaleDateController.text)),
                          inputFieldLabel(context, "Select Client"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: DropdownMenu<Client>(
                              controller: _clientFilterController,
                              requestFocusOnTap: true,
                              initialSelection: selectedClient,
                              expandedInsets: EdgeInsets.zero,
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
                              inputDecorationTheme: const InputDecorationTheme(
                                  isDense: true, border: OutlineInputBorder()),
                              dropdownMenuEntries: _clientsList
                                  .map<DropdownMenuEntry<Client>>(
                                      (Client client) {
                                return DropdownMenuEntry<Client>(
                                  value: client,
                                  label: client.clientName,
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
                          )
                        ],
                      )),
                  saveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          double milkSaleQuantity = double.parse(
                              _milkSaleAmountController.text.trim());
                          final newMilkSale = MilkSale();
                          newMilkSale.setMilkSaleQuantity = milkSaleQuantity;
                          newMilkSale.setMilkSaleDate =
                              _milkSaleDateController.text;
                          newMilkSale.setClient = selectedClient!;
                          newMilkSale.setUnitPrice =
                              selectedClient!.getUnitPrice;

                          if (editMilkSaleId != null) {
                            newMilkSale.setId = editMilkSaleId;
                            //update the milk sale details in the db
                            await context
                                .read<MilkSaleController>()
                                .editMilkSale(newMilkSale)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk sale edited successfully!"));
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
                                .addMilkSale(newMilkSale)
                                .then((value) {
                              //reset the form
                              _clientFilterController.clear();
                              setState(() {
                                selectedClient = null;
                              });
                              _milkSaleAmountController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Milk sale added successfully."));
                            }).catchError((error) {
                              debugPrint("Error saving milk sale!");
                              debugPrint(error);
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
