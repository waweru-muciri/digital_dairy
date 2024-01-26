import 'package:DigitalDairy/models/client.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:provider/provider.dart';

class ClientInputScreen extends StatefulWidget {
  const ClientInputScreen({super.key, this.editClientId});
  final String? editClientId;

  @override
  ClientFormState createState() {
    return ClientFormState();
  }
}

class ClientFormState extends State<ClientInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _unitPriceController =
      TextEditingController(text: "0");
  Client? _clientToEdit;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<ClientFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactsController.dispose();
    _locationController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editClientId = widget.editClientId;
    if (editClientId != null) {
      final clientsList = context.read<ClientController>().clientsList;
      _clientToEdit = clientsList.firstWhereOrNull(
        (client) => client.getId == editClientId,
      );
      _firstNameController.value =
          TextEditingValue(text: _clientToEdit?.getFirstName ?? '');
      _lastNameController.value =
          TextEditingValue(text: _clientToEdit?.getLastName ?? '');
      _contactsController.value =
          TextEditingValue(text: _clientToEdit?.getContacts ?? '');
      _locationController.value =
          TextEditingValue(text: _clientToEdit?.getLocation ?? '');
      _unitPriceController.value =
          TextEditingValue(text: _clientToEdit?.getUnitPrice.toString() ?? '');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            editClientId != null ? 'Edit Client Details' : 'Add Client Details',
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          inputFieldLabel(
                            context,
                            "First Name",
                          ),
                          MyDefaultTextField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Last Name",
                          ),
                          MyDefaultTextField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Contacts",
                          ),
                          MyDefaultTextField(
                            controller: _contactsController,
                          ),
                          inputFieldLabel(
                            context,
                            "Location",
                          ),
                          MyDefaultTextField(
                            controller: _locationController,
                          ),
                          inputFieldLabel(
                            context,
                            "Unit Price",
                          ),
                          MyDefaultTextField(
                            controller: _unitPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Unit price cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Unit price must be a number";
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
                          String firstName = _firstNameController.text.trim();
                          String lastName = _lastNameController.text.trim();
                          String contacts = _contactsController.text.trim();
                          String location = _locationController.text.trim();
                          double unitPrice =
                              double.parse(_unitPriceController.text);
                          //edit the properties as required
                          final newClient = Client();
                          newClient.setFirstName = firstName;
                          newClient.setLastName = lastName;
                          newClient.setContacts = contacts;
                          newClient.setLocation = location;
                          newClient.setUnitPrice = unitPrice;

                          if (editClientId != null) {
                            newClient.setId = editClientId;
                            //update the client in the db
                            await context
                                .read<ClientController>()
                                .editClient(newClient)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Client edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<ClientController>()
                                .addClient(newClient)
                                .then((value) {
                              //reset the form
                              _firstNameController.clear();
                              _lastNameController.clear();
                              _contactsController.clear();
                              _locationController.clear();
                              _unitPriceController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Client added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save Client")
                ],
              )),
        )));
  }
}
