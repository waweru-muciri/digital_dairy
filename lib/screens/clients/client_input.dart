import 'package:DigitalDairy/models/client.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class ClientInputScreen extends StatefulWidget {
  const ClientInputScreen({super.key});
  static const routeName = '/add_client_details';
  @override
  ClientFormState createState() {
    return ClientFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ClientFormState extends State<ClientInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _unitPriceController =
      TextEditingController(text: "0");
  bool _loadingStatus = false;

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
    _loadingStatus = context.watch<ClientController>().loadingStatus;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Client Details',
          ),
        ),
        body: _loadingStatus
            ? const Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 4,
                    value: null,
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name cannot be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'First Name',
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Last name cannot be empty';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Last Name',
                                      ),
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                    child: TextFormField(
                                      controller: _contactsController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Client Contacts',
                                      ),
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                    child: TextFormField(
                                      controller: _locationController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Client Location',
                                      ),
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                    child: TextFormField(
                                      controller: _unitPriceController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Unit price cannot be empty';
                                        } else if (double.tryParse(value) ==
                                            null) {
                                          return "Unit price must be a number";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Unit Price',
                                      ),
                                    ))
                              ],
                            )),
                        OutlinedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                String firstName = _firstNameController.text;
                                String lastName = _lastNameController.text;
                                String contacts = _contactsController.text;
                                String location = _locationController.text;
                                double unitPrice =
                                    double.parse(_unitPriceController.text);

                                final Client newClient = Client(
                                    firstName: firstName,
                                    lastName: lastName,
                                    location: location,
                                    contacts: contacts,
                                    unitPrice: unitPrice);

                                //save the client in the db
                                await context
                                    .read<ClientController>()
                                    .addClient(newClient)
                                    .then((value) => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Client added successfully.'))));
                              }
                            },
                            child: const Text("Save"))
                      ],
                    )),
              )));
  }
}
